//
//  File.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang
import Darwin

public final class File {
    init(_ context: CXFile) {
        self.context = context
    }
    
    private var _path: String? = nil
    var path: String {
        get {
            if _path == nil {
                _path = String.fromCXString(clang_getFileName(self.context))
            }
            return _path!
        }
    }
    
    var lastModification: time_t {
        get {
            return clang_getFileTime(self.context)
        }
    }
    
    internal let context: CXFile
}
