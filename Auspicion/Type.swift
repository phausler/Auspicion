//
//  Type.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public final class Type {
    init(_ context: CXType) {
        self.context = context
    }
    
    private var _spelling: String? = nil
    var spelling: String {
        get {
            if _spelling == nil {
                _spelling = String.fromCXString(clang_getTypeSpelling(self.context))
            }
            return _spelling!
        }
    }
    
    private var _canonicalType: Type? = nil
    var canonicalType: Type {
        get {
            if _canonicalType == nil {
                _canonicalType = Type(clang_getCanonicalType(self.context))
            }
            return _canonicalType!
        }
    }
    
    var kind: CXTypeKind {
        get {
            return self.context.kind
        }
    }
    
    private var _isConst: Bool? = nil
    var isConst: Bool {
        get {
            if _isConst == nil {
                _isConst = clang_isConstQualifiedType(self.context) != 0
            }
            return _isConst!
        }
    }
    
    private var _isVolatile: Bool? = nil
    var isVolatile: Bool {
        get {
            if _isVolatile == nil {
                _isVolatile = clang_isVolatileQualifiedType(self.context) != 0
            }
            return _isVolatile!
        }
    }
    
    private var _isRestrict: Bool? = nil
    var isRestrict: Bool {
        get {
            if _isRestrict == nil {
                _isRestrict = clang_isRestrictQualifiedType(self.context) != 0
            }
            return _isRestrict!
        }
    }

    private var _pointeeType: Type? = nil
    var pointeeType: Type {
        get {
            if _pointeeType == nil {
                _pointeeType = Type(clang_getPointeeType(self.context))
            }
            return _pointeeType!
        }
    }
    
    private var _typeDeclaration: Cursor? = nil
    var typeDeclaration: Cursor {
        get {
            if _typeDeclaration == nil {
                _typeDeclaration = Cursor(clang_getTypeDeclaration(self.context))
            }
            return _typeDeclaration!
        }
    }
    
    var functionTypeCallingConvention: CXCallingConv {
        get {
            return clang_getFunctionTypeCallingConv(self.context)
        }
    }
    
    private var _resultType: Type? = nil
    var resultType: Type {
        get {
            if _resultType == nil {
                _resultType = Type(clang_getResultType(self.context))
            }
            return _resultType!
        }
    }
    
    private var _argumentTypes: Array<Type>? = nil
    var argumentTypes: Array<Type>? {
        get {
            let count: Int32 = clang_getNumArgTypes(self.context)
            if count > 0 {
                _argumentTypes = Array<Type>()
                for var i: Int32 = 0; i < count; i++ {
                    _argumentTypes?.append(Type(clang_getArgType(self.context, UInt32(i))))
                }
            }
            return _argumentTypes
        }
    }
    
    private var _isVariadic: Bool? = nil
    var isVariadic: Bool {
        get {
            if _isVariadic == nil {
                _isVariadic = clang_isFunctionTypeVariadic(self.context) != 0
            }
            return _isVariadic!
        }
    }
    
    private var _isPOD: Bool? = nil
    var isPOD: Bool {
        get {
            if _isPOD == nil {
                _isPOD = clang_isPODType(self.context) != 0
            }
            return _isPOD!
        }
    }
    
    private var _elementType: Type? = nil
    var elementType: Type {
        get {
            if _elementType == nil {
                _elementType = Type(clang_getElementType(self.context))
            }
            return _elementType!
        }
    }
    
    
    private var _count: Int64? = nil
    var count: Int64 {
        get {
            if _count == nil {
                _count = clang_getNumElements(self.context)
            }
            return _count!
        }
    }
    
    private var _arraySize: Int64? = nil
    var arraySize: Int64 {
        get {
            if _arraySize == nil {
                _arraySize = clang_getArraySize(self.context)
            }
            return _arraySize!
        }
    }
    
    private var _alignment: Int64? = nil
    var alignment: Int64 {
        get {
            if _alignment == nil {
                _alignment = clang_Type_getAlignOf(self.context)
            }
            return _alignment!
        }
    }
    
    private var _size: Int64? = nil
    var size: Int64 {
        get {
            if _size == nil {
                _size = clang_Type_getSizeOf(self.context)
            }
            return _size!
        }
    }
    
    private var _templateArguments: Array<Type>? = nil
    var templateArguments: Array<Type>? {
        get {
            let count: Int32 = clang_Type_getNumTemplateArguments(self.context)
            if count > 0 {
               _templateArguments = Array<Type>()
                for var i: Int32 = 0; i < count; i++ {
                    _templateArguments?.append(Type(clang_Type_getTemplateArgumentAsType(self.context, UInt32(i))))
                }
            }
            return _templateArguments
        }
    }
    
    private var _cxxRefQualifier: CXRefQualifierKind? = nil
    var cxxRefQualifier: CXRefQualifierKind {
        get {
            if _cxxRefQualifier == nil {
                _cxxRefQualifier = clang_Type_getCXXRefQualifier(self.context)
            }
            return _cxxRefQualifier!
        }
    }
    
    internal let context: CXType
}

public func ==(lhs: Type, rhs: Type) -> Bool {
    return clang_equalTypes(lhs.context, rhs.context) != 0
}

extension Type : Equatable {
    
}

extension CXTypeKind {
    var spelling: String {
        get {
            return String.fromCXString(clang_getTypeKindSpelling(self))
        }
    }
}