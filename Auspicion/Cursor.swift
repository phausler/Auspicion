//
//  Cursor.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public final class Availability {
    init(_ introduced: CXVersion, _ deprecated: CXVersion, _ obsoleted: CXVersion, _ unavailable: Bool, _ message: String) {
        self._introduced = introduced
        self._deprecated = deprecated
        self._obsoleted = obsoleted
        self._unavailable = unavailable
        self._message = message
    }
    
    private var _introduced: CXVersion
    var introduced: CXVersion {
        get {
            return _introduced
        }
    }
    
    private var _deprecated: CXVersion
    var deprecated: CXVersion {
        get {
            return _deprecated
        }
    }
    
    private var _obsoleted: CXVersion
    var obsoleted: CXVersion {
        get {
            return _obsoleted
        }
    }
    
    private var _unavailable: Bool
    var unavailable: Bool {
        get {
            return _unavailable
        }
    }
    
    private var _message: String
    var message: String {
        get {
            return _message
        }
    }
}

public final class PlatformAvailability {
    init(_ info: UnsafeMutablePointer<CXPlatformAvailability>, _ count: Int, _ always_deprecated: Bool, _ deprecated_message: String, _ always_unavailable: Bool, _ unavailable_message: String) {
        self.info = info
        self.count = count
        self._alwaysDeprecated = always_deprecated
        self._deprecatedMessage = deprecated_message
        self._alwaysUnavailable = always_unavailable
        self._unavailableMessage = unavailable_message
    }
    
    deinit {
        clang_disposeCXPlatformAvailability(info)
        info.dealloc(count)
    }
    
    private var _alwaysDeprecated: Bool
    var alwaysDeprecated: Bool {
        get {
            return _alwaysDeprecated
        }
    }
    
    private var _deprecatedMessage: String
    var deprecatedMessage: String {
        get {
            return _deprecatedMessage
        }
    }
    
    private var _alwaysUnavailable: Bool
    var alwaysUnavailable: Bool {
        get {
            return _alwaysUnavailable
        }
    }
    
    private var _unavailableMessage: String
    var unavailableMessage: String {
        get {
            return _unavailableMessage
        }
    }
    
    private var _availability: Dictionary<String, Availability>? = nil
    var availability: Dictionary<String, Availability> {
        get {
            if _availability == nil {
                _availability = Dictionary<String, Availability>()
                for var i = 0; i < count; i++ {
                    let platform = String.fromCXString(info[i].Platform)
                    let message = String.fromCXString(info[i].Message)
                    _availability![platform] = Availability(info[i].Introduced, info[i].Deprecated, info[i].Obsoleted, info[i].Unavailable != Int32(0), message)
                }
            }
            return _availability!
        }
    }
    
    func availability(platform: String) -> Availability? {
        return self.availability[platform]
    }
    
    internal var count: Int
    internal var info: UnsafeMutablePointer<CXPlatformAvailability>
    
}

extension CXVersion : NilLiteralConvertible {
    public init(nilLiteral: ()) {
        self.Major = 0
        self.Minor = 0
        self.Subminor = 0
    }
}

extension CXPlatformAvailability : NilLiteralConvertible {
    public init(nilLiteral: ()) {
        self.Platform = nil
        self.Introduced = nil
        self.Deprecated = nil
        self.Obsoleted = nil
        self.Unavailable = 0
        self.Message = nil
    }
}

public final class Cursor {
    
    class func null() -> Cursor {
        return Cursor(clang_getNullCursor())
    }
    
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
    
    var isNull: Bool {
        get {
            return clang_Cursor_isNull(self.context) != 0
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
    
    var platformAvailability: PlatformAvailability {
        get {
            var always_deprecated: Int32 = 0
            var deprecated_message: CXString = nil
            var always_unavailable: Int32 = 0
            var unavailable_message: CXString = nil
            
            let count = clang_getCursorPlatformAvailability(self.context, &always_deprecated, &deprecated_message, &always_unavailable, &unavailable_message, nil, 0)
            var info = UnsafeMutablePointer<CXPlatformAvailability>.alloc(Int(count))
            clang_getCursorPlatformAvailability(self.context, nil, nil, nil, nil, info, count)
            let availability = PlatformAvailability(info, Int(count), always_deprecated != Int32(0), String.fromCXString(deprecated_message), always_unavailable != Int32(0), String.fromCXString(unavailable_message))
            clang_disposeString(deprecated_message)
            clang_disposeString(unavailable_message)
            return availability
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