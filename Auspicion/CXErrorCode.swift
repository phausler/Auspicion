//
//  CXErrorCode.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public func ==(lhs: CXErrorCode, rhs: CXErrorCode) -> Bool {
    return lhs.value == rhs.value
}

extension CXErrorCode : Equatable {
    
}

public func ==(lhs: CXCompilationDatabase_Error, rhs: CXCompilationDatabase_Error) -> Bool {
    return lhs.value == rhs.value
}

extension CXCompilationDatabase_Error : Equatable {
    
}