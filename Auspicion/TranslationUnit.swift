//
//  TranslationUnit.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang
import Foundation

public final class TUResourceUsage {
    init(_ context: CXTUResourceUsage) {
        self.context = context
    }
    
    deinit {
        clang_disposeCXTUResourceUsage(self.context)
    }
    
    subscript (key: CXTUResourceUsageKind) -> UInt? {
        for var i: UInt32 = 0; i < self.context.numEntries; i++ {
            let idx = Int(i)
            if self.context.entries[idx].kind == key {
                return self.context.entries[idx].amount
            }
        }
        return nil
    }
    
    internal let context: CXTUResourceUsage
}

public final class TranslationUnit {
    init(_ context: CXTranslationUnit) {
        self.context = context
    }
    
    public convenience init(index: Index, astFileName: String) {
        self.init(clang_createTranslationUnit(index.context, astFileName))
    }
    
    convenience init(index: Index, sourceFile: String, args: Array<String>, unsavedFiles: Dictionary<String, String>) {
        // This entire section seems rather dirty and ineffecient
        var buffer = UnsafeMutablePointer<UnsafePointer<Int8>>.alloc(args.count + 1)
        var idx = 0
        for arg in args {
            let cStr: UnsafePointer<Void> = arg.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!.bytes
            buffer[idx] = unsafeBitCast(cStr, UnsafePointer<Int8>.self)
            idx++
        }
        
        var unsavedBuffer = UnsafeMutablePointer<CXUnsavedFile>.null()
        var unsavedCount: UInt32 = UInt32(unsavedFiles.count)
        idx = 0
        if unsavedCount > 0 {
            unsavedBuffer = UnsafeMutablePointer<CXUnsavedFile>.alloc(Int(unsavedCount))
            for (key, value) in unsavedFiles {
                let path: UnsafePointer<Void> = key.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!.bytes
                var data: NSData = value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                let contents: UnsafePointer<Void> = data.bytes
                unsavedBuffer[idx].Filename = unsafeBitCast(path, UnsafePointer<Int8>.self)
                unsavedBuffer[idx].Contents = unsafeBitCast(contents, UnsafePointer<Int8>.self)
                unsavedBuffer[idx].Length = UInt(data.length)
                idx++
            }
        }
        
        self.init(clang_createTranslationUnitFromSourceFile(index.context, sourceFile, Int32(args.count), buffer, unsavedCount, unsavedBuffer))
        
        buffer.dealloc(args.count + 1)
        if unsavedCount > 0 {
            unsavedBuffer.dealloc(Int(unsavedCount))
        }
    }
    
    public convenience init(index: Index, sourceFile: String, args: Array<String>) {
        self.init(index: index, sourceFile: sourceFile, args: args, unsavedFiles: Dictionary<String, String>())
    }
    
    deinit {
        if _tokenCount > 0 {
            clang_disposeTokens(self.context, _tokens, _tokenCount)
        }
        clang_disposeTranslationUnit(self.context)
    }
    
    public var usage: TUResourceUsage {
        get {
            return TUResourceUsage(clang_getCXTUResourceUsage(self.context))
        }
    }
    
    public func reparse() -> Bool {
        return clang_defaultReparseOptions(self.context) == 0
    }
    
    public func defaultParseOptions() -> UInt32 {
        return clang_defaultReparseOptions(self.context)
    }
    
    public func reparse(unsavedFiles: Dictionary<String, String>, options: UInt32) -> Bool {
        var unsavedBuffer = UnsafeMutablePointer<CXUnsavedFile>.null()
        var unsavedCount: UInt32 = UInt32(unsavedFiles.count)
        var idx = 0
        if unsavedCount > 0 {
            unsavedBuffer = UnsafeMutablePointer<CXUnsavedFile>.alloc(Int(unsavedCount))
            for (key, value) in unsavedFiles {
                let path: UnsafePointer<Void> = key.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!.bytes
                var data: NSData = value.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
                let contents: UnsafePointer<Void> = data.bytes
                unsavedBuffer[idx].Filename = unsafeBitCast(path, UnsafePointer<Int8>.self)
                unsavedBuffer[idx].Contents = unsafeBitCast(contents, UnsafePointer<Int8>.self)
                unsavedBuffer[idx].Length = UInt(data.length)
                idx++
            }
        }
        
        return clang_reparseTranslationUnit(self.context, unsavedCount, unsavedBuffer, options) == 0
    }
    
    public var cursor: Cursor {
        get {
            return Cursor(clang_getTranslationUnitCursor(self.context))
        }
    }
    
    public func cursor(location: SourceLocation) -> Cursor {
        return Cursor(clang_getCursor(self.context, location.context))
    }
    
    public func file(path: String) -> File {
        return File(clang_getFile(self.context, path))
    }
    
    private var _tokens: UnsafeMutablePointer<CXToken> = UnsafeMutablePointer<CXToken>.null()
    private var _tokenCount: UInt32 = 0
    
    public func tokenize(range: SourceRange) -> Array<Token> {
        if _tokenCount > 0 {
            clang_disposeTokens(self.context, _tokens, _tokenCount)
        }
        clang_tokenize(self.context, range.context, &_tokens, &_tokenCount)
        var found: Array<Token> = Array<Token>()
        for var i: UInt32 = 0; i < _tokenCount; i++ {
            found.append(Token(_tokens[Int(i)]))
        }
        return found
    }
    
    
    public func save(path: String, options: UInt32) -> Bool {
        return clang_saveTranslationUnit(self.context, path, options) == CXSaveError_None
    }
    
    internal let context: CXTranslationUnit
}
