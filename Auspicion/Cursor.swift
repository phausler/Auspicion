//
//  Cursor.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Rob Rix. All rights reserved.
//

import clang

public final class Cursor {
    init(_ context: CXCursor) {
        self.context = context
    }
    
    var kind: CXCursorKind {
        get {
            return clang_getCursorKind(self.context)
        }
    }
    
    var declaration: Bool {
        get {
            return clang_isDeclaration(self.kind) != 0
        }
    }
    
    var reference: Bool {
        get {
            return clang_isReference(self.kind) != 0
        }
    }
    
    var expression: Bool {
        get {
            return clang_isExpression(self.kind) != 0
        }
    }
    
    var statement: Bool {
        get {
            return clang_isStatement(self.kind) != 0
        }
    }
    
    var attribute: Bool {
        get {
            return clang_isAttribute(self.kind) != 0
        }
    }
    
    var invalid: Bool {
        get {
            return clang_isInvalid(self.kind) != 0
        }
    }
    
    var translationUnit: Bool {
        get {
            return clang_isTranslationUnit(self.kind) != 0
        }
    }
    
    var preprocessing: Bool {
        get {
            return clang_isPreprocessing(self.kind) != 0
        }
    }
    
    var unexposed: Bool {
        get {
            return clang_isUnexposed(self.kind) != 0
        }
    }

    var linkage: CXLinkageKind {
        get {
            return clang_getCursorLinkage(self.context)
        }
    }
    
    var availability: CXAvailabilityKind {
        get {
            return clang_getCursorAvailability(self.context);
        }
    }
    
    var language: CXLanguageKind {
        get {
            return clang_getCursorLanguage(self.context)
        }
    }
    
    var semanticParent: Cursor {
        get {
            return Cursor(clang_getCursorSemanticParent(self.context))
        }
    }
    
    var lexicalParent: Cursor {
        get {
            return Cursor(clang_getCursorLexicalParent(self.context))
        }
    }
    
    var location: SourceLocation {
        get {
            return SourceLocation(clang_getCursorLocation(self.context))
        }
    }
    
    var range: SourceRange {
        get {
            return SourceRange(clang_getCursorExtent(self.context))
        }
    }
    
    var includedFile: File {
        return File(clang_getIncludedFile(self.context))
    }
    
    var type: Type {
        get {
            return Type(clang_getCursorType(self.context))
        }
    }
    
    func visit(visitor: (Cursor, Cursor) -> CXChildVisitResult) -> Bool {
        return clang_visitChildrenWithBlock(self.context, { (node, parent) -> CXChildVisitResult in
            return visitor(Cursor(node), Cursor(parent))
        }) == 0
    }
    
    internal let context: CXCursor
}

public func ==(lhs: Cursor, rhs: Cursor) -> Bool {
    return clang_equalCursors(lhs.context, rhs.context) != 0
}

extension Cursor : Equatable {
    
}

extension Cursor : Hashable {
    public var hashValue: Int {
        get {
            return Int(clang_hashCursor(self.context))
        }
    }
}