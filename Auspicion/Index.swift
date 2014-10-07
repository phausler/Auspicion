//
//  Index.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public final class Index {
    init(_ context: CXIndex) {
        self.context = context
    }
    
    public convenience init(excludeDeclarationsFromPCH: Bool, displayDiagnostics: Bool) {
        self.init(clang_createIndex(excludeDeclarationsFromPCH ? 1 : 0, displayDiagnostics ? 1 : 0))
    }
    
    deinit {
        clang_disposeIndex(self.context)
    }
    
    public var globalOptions: CXGlobalOptFlags {
        get {
            return CXGlobalOptFlags(clang_CXIndex_getGlobalOptions(self.context))
        }
        set {
            clang_CXIndex_setGlobalOptions(self.context, newValue.value)
        }
    }
    
    internal let context: CXIndex
}
