//
//  CXString.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

extension String {
    static func fromCXString(str: CXString) -> String {
        return String.fromCString(clang_getCString(str))!
    }
}