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
    var kind: CXTokenKind {
        get {
            if _kind == nil {
                _kind = clang_getTokenKind(self.context)
            }
            return _kind!
        }
    }
    
    func spelling(tu: TranslationUnit) -> String {
        return String.fromCXString(clang_getTokenSpelling(tu.context, self.context))
    }
    
    func location(tu: TranslationUnit) -> SourceLocation {
        return SourceLocation(clang_getTokenLocation(tu.context, self.context))
    }
    
    func extent(tu: TranslationUnit) -> SourceRange {
        return SourceRange(clang_getTokenExtent(tu.context, self.context))
    }
    
    internal let context: CXToken
}