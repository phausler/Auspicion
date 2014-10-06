//
//  CompilationDatabase.swift
//  Auspicion
//
//  Created by Philippe Hausler on 10/6/14.
//  Copyright (c) 2014 Philippe Hausler. All rights reserved.
//

import clang

public final class CompilationDatabase {
    init(_ context: CXCompilationDatabase) {
        self.context = context
    }
    
    class func database(buildDir: String) -> CompilationDatabase? {
        var err: CXCompilationDatabase_Error = CXCompilationDatabase_NoError
        var db: CXCompilationDatabase = clang_CompilationDatabase_fromDirectory(buildDir, &err)
        if err == CXCompilationDatabase_NoError {
            return CompilationDatabase(db)
        } else {
            return nil
        }
    }
    
    deinit {
        clang_CompilationDatabase_dispose(self.context)
    }
    
    var compileCommands: CompileCommands {
        get {
            let commands = CompileCommands(clang_CompilationDatabase_getAllCompileCommands(self.context))
            
            for command in commands.commands {
                
            }
            
            return commands
        }
    }
    
    private var _commands: Dictionary<String, CompileCommand> = Dictionary<String, CompileCommand>()
    
    internal let context: CXCompilationDatabase
}
