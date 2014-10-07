//
//  Token.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public final class Token {
    init(_ context: CXToken) {
        self.context = context
    }
    
    private var _kind: CXTokenKind? = nil
    public var kind: CXTokenKind {
        get {
            if _kind == nil {
                _kind = clang_getTokenKind(self.context)
            }
            return _kind!
        }
    }
    
    public func spelling(tu: TranslationUnit) -> String {
        let val = clang_getTokenSpelling(tu.context, self.context)
        let str = String.fromCXString(val)
        clang_disposeString(val)
        return str
    }
    
    public func location(tu: TranslationUnit) -> SourceLocation {
        return SourceLocation(clang_getTokenLocation(tu.context, self.context))
    }
    
    public func extent(tu: TranslationUnit) -> SourceRange {
        return SourceRange(clang_getTokenExtent(tu.context, self.context))
    }
    
    internal let context: CXToken
}