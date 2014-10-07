//
//  SourceRange.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public final class SourceRange {
    init(_ context: CXSourceRange) {
        self.context = context
    }
    
    public convenience init(begin: SourceLocation, end: SourceLocation) {
        self.init(clang_getRange(begin.context, end.context))
    }
    
    private var _start: SourceLocation? = nil
    public var start: SourceLocation {
        if _start == nil {
            _start = SourceLocation(clang_getRangeStart(self.context))
        }
        return _start!
    }
    
    private var _end: SourceLocation? = nil
    public var end: SourceLocation {
        if _end == nil {
            _end = SourceLocation(clang_getRangeEnd(self.context))
        }
        return _end!
    }
    
    internal let context: CXSourceRange
}

public func ==(lhs: SourceRange, rhs: SourceRange) -> Bool {
    return clang_equalRanges(lhs.context, rhs.context) != 0
}

extension SourceRange : Equatable {
    
}