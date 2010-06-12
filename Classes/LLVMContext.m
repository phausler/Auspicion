// LLVMContext.m
// Created by Rob Rix on 2009-12-29
// Copyright 2009 Monochrome Industries

#import "LLVMContext+Protected.h"
#import "LLVMType+Protected.h"
#import "LLVMValue+Protected.h"

@implementation LLVMContext

-(id)initWithContextRef:(LLVMContextRef)_contextRef {
	if(self = [super init]) {
		contextRef = _contextRef;
	}
	return self;
}

-(void)dealloc {
	LLVMContextDispose(contextRef);
	[super dealloc];
}

+(LLVMContext *)contextWithContextRef:(LLVMContextRef)_contextRef {
	static NSMutableDictionary *contextsByRef = nil;
	if(!contextsByRef) {
		contextsByRef = [[NSMutableDictionary alloc] init];
	}
	LLVMContext *context = [contextsByRef objectForKey: [NSValue valueWithPointer: _contextRef]];
	if(!context) {
		context = [[[self alloc] initWithContextRef: _contextRef] autorelease];
		[contextsByRef setObject: context forKey: [NSValue valueWithPointer: _contextRef]];
	}
	return context;
}

+(LLVMContext *)context {
	return [self contextWithContextRef: LLVMContextCreate()];
}


@synthesize contextRef;


// types
-(LLVMType *)integerType {
	return [LLVMType integerTypeInContext: self];
}

-(LLVMType *)int1Type {
	return [LLVMType int1TypeInContext: self];
}

-(LLVMType *)int8Type {
	return [LLVMType int8TypeInContext: self];
}

-(LLVMType *)int16Type {
	return [LLVMType int16TypeInContext: self];
}

-(LLVMType *)int32Type {
	return [LLVMType int32TypeInContext: self];
}

-(LLVMType *)int64Type {
	return [LLVMType int64TypeInContext: self];
}


-(LLVMType *)untypedPointerType {
	return [LLVMType untypedPointerTypeInContext: self];
}


-(LLVMType *)voidType {
	return [LLVMType voidTypeInContext: self];
}

-(LLVMStructureType *)structTypeWithTypes:(LLVMType *)type, ... {
	NSMutableArray *types = [NSMutableArray arrayWithObject: type];
	va_list list;
	va_start(list, type);
	while(type = va_arg(list, LLVMType *)) {
		[types addObject: type];
	}
	va_end(list);
	return [LLVMType structTypeInContext: self withTypes: types];
}


// constants
-(LLVMValue *)constantInteger:(NSInteger)integer {
	return [LLVMValue valueWithValueRef: LLVMConstInt(self.integerType.typeRef, integer, 1)];
}

-(LLVMValue *)constantUnsignedInteger:(NSUInteger)integer {
	return [LLVMValue valueWithValueRef: LLVMConstInt(self.integerType.typeRef, integer, 0)];
}

-(LLVMValue *)constantInt64:(int64_t)integer {
	return [LLVMValue valueWithValueRef: LLVMConstInt(self.int64Type.typeRef, integer, 1)];
}

-(LLVMValue *)constantUnsignedInt64:(uint64_t)integer {
	return [LLVMValue valueWithValueRef: LLVMConstInt(self.int64Type.typeRef, integer, 0)];
}

-(LLVMValue *)constantInt32:(int32_t)integer {
	return [LLVMValue valueWithValueRef: LLVMConstInt(self.int32Type.typeRef, integer, 1)];
}

-(LLVMValue *)constantUnsignedInt32:(uint32_t)integer {
	return [LLVMValue valueWithValueRef: LLVMConstInt(self.int32Type.typeRef, integer, 0)];
}


-(LLVMValue *)constantUntypedPointer:(void *)pointer {
	return [LLVMValue valueWithValueRef: LLVMConstIntToPtr(LLVMConstInt(self.integerType.typeRef, (NSUInteger)pointer, 0), self.untypedPointerType.typeRef)];
}


-(LLVMValue *)constantNullOfType:(LLVMType *)type {
	return [LLVMValue valueWithValueRef: LLVMConstNull(type.typeRef)];
}


-(LLVMValue *)constantStruct:(LLVMValue *)value, ... {
	NSParameterAssert(value != nil);
	NSMutableArray *values = [NSMutableArray arrayWithObject: value];
	va_list list;
	va_start(list, value);
	while(value = va_arg(list, LLVMValue *)) {
		[values addObject: value];
	}
	va_end(list);
	NSParameterAssert(values.count > 1);
	LLVMValueRef valueRefs[values.count];
	NSUInteger i = 0;
	for(LLVMValue *value in values) {
		valueRefs[i++] = value.valueRef;
	}
	return [LLVMValue valueWithValueRef: LLVMConstStructInContext(self.contextRef, valueRefs, values.count, NO)];
}

@end
