//
//  SourceLocation.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public final class SourceLocation {
    init(_ context: CXSourceLocation) {
        self.context = context
    }
    
    var inSystemHeader: Bool {
        get {
            return clang_Location_isInSystemHeader(self.context) != 0
        }
    }
    
    var inMainFile: Bool {
        get {
            return clang_Location_isFromMainFile(self.context) != 0
        }
    }
    
    private func getSpellingInfo() {
        if _spellingFile == nil || _spellingLine == nil || _spellingColumn == nil || _spellingOffset == nil {
            var f: CXFile = nil
            var l: UInt32 = 0
            var c: UInt32 = 0
            var o: UInt32 = 0
            clang_getSpellingLocation(self.context, &f, &l, &c, &o)
            _spellingFile = File(f)
            _spellingLine = l
            _spellingColumn = c
            _spellingOffset = o
        }
    }
    
    private var _spellingFile: File? = nil
    var spellingFile: File {
        get {
            getSpellingInfo()
            return _spellingFile!
        }
    }
    
    private var _spellingLine: UInt32? = nil
    var spellingLine: UInt32 {
        get {
            getSpellingInfo()
            return _spellingLine!
        }
    }
    
    private var _spellingColumn: UInt32? = nil
    var spellingColumn: UInt32 {
        get {
            getSpellingInfo()
            return _spellingColumn!
        }
    }
    
    private var _spellingOffset: UInt32? = nil
    var spellingOffset: UInt32 {
        get {
            getSpellingInfo()
            return _spellingOffset!
        }
    }
    
    private func getFileInfo() {
        if _file == nil || _line == nil || _column == nil || _offset == nil {
            var f: CXFile = nil
            var l: UInt32 = 0
            var c: UInt32 = 0
            var o: UInt32 = 0
            clang_getSpellingLocation(self.context, &f, &l, &c, &o)
            _file = File(f)
            _line = l
            _column = c
            _offset = o
        }
    }
    
    private var _file: File? = nil
    var file: File {
        get {
            getFileInfo()
            return _file!
        }
    }
    
    private var _line: UInt32? = nil
    var line: UInt32 {
        get {
            getFileInfo()
            return _line!
        }
    }
    
    private var _column: UInt32? = nil
    var column: UInt32 {
        get {
            getFileInfo()
            return _column!
        }
    }
    
    private var _offset: UInt32? = nil
    var offset: UInt32 {
        get {
            getFileInfo()
            return _offset!
        }
    }
    
    internal let context: CXSourceLocation
}

public func ==(lhs: SourceLocation, rhs: SourceLocation) -> Bool {
    return clang_equalLocations(lhs.context, rhs.context) != 0
}

extension SourceLocation : Equatable {
    
}