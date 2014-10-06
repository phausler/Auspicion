//
//  ModuleMapDescriptor.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public final class ModuleMapDescriptor {
    init(context: CXModuleMapDescriptor) {
        self.context = context
    }
    
    convenience init() {
        self.init(context: clang_ModuleMapDescriptor_create(0))
    }
    
    deinit {
        clang_ModuleMapDescriptor_dispose(self.context)
    }

    private var _frameworkModuleName: String? = nil
    var frameworkModuleName: String? {
        get {
            return _frameworkModuleName
        }
        set {
            if clang_ModuleMapDescriptor_setFrameworkModuleName(self.context, newValue!) == CXError_Success {
                _frameworkModuleName = newValue
            }
        }
    }
    
    private var _umbrellaHeader: String? = nil
    var umbrellaHeader: String? {
        get {
            return _umbrellaHeader
        }
        set {
            if clang_ModuleMapDescriptor_setUmbrellaHeader(self.context, newValue!) == CXError_Success {
                _umbrellaHeader = newValue
            }
        }
    }
    
    internal let context: CXModuleMapDescriptor
}
