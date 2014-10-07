//
//  CXTUResourceUsageKind.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public func ==(lhs: CXTUResourceUsageKind, rhs: CXTUResourceUsageKind) -> Bool {
    return lhs.value == rhs.value
}

extension CXTUResourceUsageKind : Equatable {
    
}
