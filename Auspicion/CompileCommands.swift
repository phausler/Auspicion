//
//  CompileCommands.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public final class CompileCommand {
    init(_ context: CXCompileCommand) {
        self.context = context
    }
    
    private var _directory: String? = nil
    var directory: String {
        get {
            if _directory == nil {
                let dir = clang_CompileCommand_getDirectory(self.context)
                _directory = String.fromCXString(dir)
                clang_disposeString(dir)
            }
            return _directory!
        }
    }
    
    private var _arguments: Array<String>? = nil
    var arguments: Array<String> {
        get {
            if _arguments == nil {
                _arguments = Array<String>()
                for var i: UInt32 = 0; i < clang_CompileCommand_getNumArgs(self.context); i++ {
                    let val = clang_CompileCommand_getArg(self.context, i)
                    let argument: String = String.fromCXString(val)
                    clang_disposeString(val)
                    _arguments!.append(argument)
                }
            }
            return _arguments!
        }
    }
    
    private var _mappedSources: Array<String>? = nil
    var mappedSources: Array<String> {
        get {
            if _mappedSources == nil {
                _mappedSources = Array<String>()
                for var i: UInt32 = 0; i < clang_CompileCommand_getNumMappedSources(self.context); i++ {
                    let val = clang_CompileCommand_getMappedSourcePath(self.context, i)
                    let path: String = String.fromCXString(val)
                    clang_disposeString(val)
                    _mappedSources!.append(path)
                }
            }
            
            return _mappedSources!
        }
    }
    
    internal let context: CXCompileCommand;
}

public final class CompileCommands {
    init(_ context: CXCompileCommands) {
        self.context = context
    }
    
    deinit {
        clang_CompileCommands_dispose(self.context)
    }
    
    private var _commands: Array<CompileCommand>? = nil
    var commands: Array<CompileCommand> {
        get {
            if _commands == nil {
                _commands = Array<CompileCommand>()
                for var i: UInt32 = 0; i < clang_CompileCommands_getSize(self.context); i++ {
                    _commands?.append(CompileCommand(clang_CompileCommands_getCommand(self.context, i)))
                }
            }
            return _commands!
        }
    }
    
    internal let context: CXCompileCommands;
}
