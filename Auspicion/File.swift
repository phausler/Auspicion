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
    public var path: String {
        get {
            if _path == nil {
                let val = clang_getFileName(self.context)
                _path = String.fromCXString(val)
                clang_disposeString(val)
            }
            return _path!
        }
    }
    
    public var lastModification: time_t {
        get {
            return clang_getFileTime(self.context)
        }
    }
    
    internal let context: CXFile
}
