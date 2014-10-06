//
//  TranslationUnit.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public final class TUResourceUsage {
    init(_ context: CXTUResourceUsage) {
        self.context = context
    }
    
    deinit {
        clang_disposeCXTUResourceUsage(self.context)
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
    
//    convenience init(index: Index, sourceFile: String, args: Array<String>, unsavedFiles: Dictionary<String, String>?) {
//        clang_createTranslationUnitFromSourceFile(index.context, sourceFile, args.count as Int32, args.withUnsafeBufferPointer { $0.baseAddress }, 0, nil)
//    }
//    
    /*
    CXTranslationUnit clang_createTranslationUnitFromSourceFile(
    CXIndex CIdx,
    const char *source_filename,
    int num_clang_command_line_args,
    const char * const *clang_command_line_args,
    unsigned num_unsaved_files,
    struct CXUnsavedFile *unsaved_files);
*/
    
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
    
    var cursor: Cursor {
        get {
            return Cursor(clang_getTranslationUnitCursor(self.context))
        }
    }
    
    func file(path: String) -> File {
        return File(clang_getFile(self.context, path))
    }
    
    internal let context: CXTranslationUnit
}
