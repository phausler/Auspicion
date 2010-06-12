// ARXOptimizer.m
// Created by Rob Rix on 2009-12-30
// Copyright 2009 Monochrome Industries

#import "ARXCompiler+Protected.h"
#import "ARXModule+Protected.h"
#import "ARXOptimizer+Protected.h"

@implementation ARXOptimizer

+(id)optimizerWithCompiler:(ARXCompiler *)compiler {
	return [[[self alloc] initWithCompiler: compiler] autorelease];
}

-(id)initWithCompiler:(ARXCompiler *)_compiler {
	if(self = [super init]) {
		compiler = [_compiler retain];
		NSParameterAssert(compiler != nil);
		optimizerRef = LLVMCreatePassManager();
		LLVMAddTargetData(LLVMGetExecutionEngineTargetData(compiler.compilerRef), optimizerRef);
	}
	return self;
}

-(void)dealloc {
	[compiler release];
	LLVMDisposePassManager(optimizerRef);
	[super dealloc];
}


@synthesize compiler, optimizerRef;


-(void)addConstantPropagationPass {
	LLVMAddConstantPropagationPass(self.optimizerRef);
}

-(void)addInstructionCombiningPass {
	LLVMAddInstructionCombiningPass(self.optimizerRef);
}

-(void)addPromoteMemoryToRegisterPass {
	LLVMAddPromoteMemoryToRegisterPass(self.optimizerRef);
}

-(void)addGVNPass {
	LLVMAddGVNPass(self.optimizerRef);
}

-(void)addCFGSimplificationPass {
	LLVMAddCFGSimplificationPass(self.optimizerRef);
}


-(BOOL)optimizeModule:(ARXModule *)module {
	return LLVMRunPassManager(self.optimizerRef, module.moduleRef);
}

@end