//
//  VirtualFileOverlay.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public final class VirtualFileOverlay {
    init(context: CXVirtualFileOverlay) {
        self.context = context
    }
    
    convenience init() {
        self.init(context: clang_VirtualFileOverlay_create(0))
    }
    
    deinit {
        clang_VirtualFileOverlay_dispose(self.context)
    }
    
    func addFileMapping(virtualPath: String, realPath: String) {
        clang_VirtualFileOverlay_addFileMapping(self.context, virtualPath, realPath)
    }
    
    private var _caseSensitive: Bool = false
    var caseSensitive: Bool {
        get {
            return _caseSensitive
        }
        set {
            if clang_VirtualFileOverlay_setCaseSensitivity(self.context, newValue ? 1 : 0) == CXError_Success {
                _caseSensitive = newValue
            }
        }
    }
    
    func writeToBuffer(inout buffer: UnsafeMutablePointer<Int8>) -> (Bool, UInt32) {
        var length: UInt32 = 0
        if clang_VirtualFileOverlay_writeToBuffer(self.context, 0, &buffer, &length) == CXError_Success {
            return (true, length)
        } else {
            return (false, 0)
        }
    }
    
    internal let context: CXVirtualFileOverlay
}