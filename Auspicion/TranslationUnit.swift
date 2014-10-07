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
    
    convenience init(index: Index, astFileName: String) {
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
    
    convenience init(index: Index, sourceFile: String, args: Array<String>) {
        self.init(index: index, sourceFile: sourceFile, args: args, unsavedFiles: Dictionary<String, String>())
    }
    
    deinit {
        clang_disposeTranslationUnit(self.context)
    }
    
    var usage: TUResourceUsage {
        get {
            return TUResourceUsage(clang_getCXTUResourceUsage(self.context))
        }
    }
    
    func reparse() -> Bool {
        return clang_defaultReparseOptions(self.context) == 0
    }
    
    func defaultParseOptions() -> UInt32 {
        return clang_defaultReparseOptions(self.context)
    }
    
    func reparse(unsavedFiles: Dictionary<String, String>, options: UInt32) -> Bool {
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
    
    var cursor: Cursor {
        get {
            return Cursor(clang_getTranslationUnitCursor(self.context))
        }
    }
    
    func cursor(location: SourceLocation) -> Cursor {
        return Cursor(clang_getCursor(self.context, location.context))
    }
    
    func file(path: String) -> File {
        return File(clang_getFile(self.context, path))
    }
    
    func tokenize(range: SourceRange) -> Array<Token> {
        var tokens: UnsafeMutablePointer<CXToken> = UnsafeMutablePointer<CXToken>.null()
        var count: UInt32 = 0
        clang_tokenize(self.context, range.context, &tokens, &count)
        var found: Array<Token> = Array<Token>()
        for var i: UInt32 = 0; i < count; i++ {
            found.append(Token(tokens[Int(i)]))
        }
        return found
    }
    
    internal let context: CXTranslationUnit
}
