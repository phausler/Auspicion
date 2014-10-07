//
//  CXErrorCode.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

// Sadly most of the error codes are inconsistent and are sometimes 
// signed return values and sometimes unsigned values...

public func ==(lhs: CXErrorCode, rhs: CXErrorCode) -> Bool {
    return lhs.value == rhs.value
}

public func ==(lhs: UInt32, rhs: CXErrorCode) -> Bool {
    return lhs == rhs.value
}

public func ==(lhs: Int32, rhs: CXErrorCode) -> Bool {
    return lhs == Int32(rhs.value)
}

public func ==(lhs: CXErrorCode, rhs: UInt32) -> Bool {
    return lhs.value == rhs
}

public func ==(lhs: CXErrorCode, rhs: Int32) -> Bool {
    return Int32(lhs.value) == rhs
}

public func ==(lhs: CXSaveError, rhs: CXSaveError) -> Bool {
    return lhs.value == rhs.value
}

public func ==(lhs: UInt32, rhs: CXSaveError) -> Bool {
    return lhs == rhs.value
}

public func ==(lhs: Int32, rhs: CXSaveError) -> Bool {
    return lhs == Int32(rhs.value)
}

public func ==(lhs: CXSaveError, rhs: UInt32) -> Bool {
    return lhs.value == rhs
}

public func ==(lhs: CXSaveError, rhs: Int32) -> Bool {
    return Int32(lhs.value) == rhs
}

extension CXErrorCode : Equatable {
    
}

extension CXSaveError : Equatable {
    
}

public func ==(lhs: CXCompilationDatabase_Error, rhs: CXCompilationDatabase_Error) -> Bool {
    return lhs.value == rhs.value
}

extension CXCompilationDatabase_Error : Equatable {
    
}