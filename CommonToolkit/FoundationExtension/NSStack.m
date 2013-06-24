//
//  NSStack.m
//  CommonToolkit
//
//  Created by Ares on 13-6-6.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "NSStack.h"

@implementation NSStack

- (id)init{
    self = [super init];
    if (self) {
        // init storage object
        _mStorageObject = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)push:(id)pElement{
    // add an element to the stack
    [_mStorageObject addObject:pElement];
}

- (id)pop{
    id _topElement = nil;
    
    // check the stack
    if (!self.empty) {
        // get top element
        _topElement = [_mStorageObject lastObject];
        
        // remove the last element from the stack
        [_mStorageObject removeLastObject];
    }
    else {
        NSLog(@"the stack is empty, needn't pop");
    }
    
    return _topElement;
}

- (void)clear{
    // remove all elements from stack
    [_mStorageObject removeAllObjects];
}

- (id)top{
    id _topElement = nil;
    
    // check the stack
    if (!self.empty) {
        // get top element
        _topElement = [_mStorageObject lastObject];
    }
    else {
        NSLog(@"the stack is empty, can't get the top element");
    }
    
    return _topElement;
}

- (BOOL)empty{
    return 0 == _mStorageObject.count ? TRUE : FALSE;
}

- (NSUInteger)count{
    return _mStorageObject.count;
}

- (NSString *)stackDescription{
    NSMutableString *_description = [[NSMutableString alloc] initWithString:@"NSStack all elements = "];
    
    for (int i = 0; i < _mStorageObject.count; i++) {
        id _element = [_mStorageObject objectAtIndex:i];
        
        [_description appendFormat:@"%@", _element];
        
        if (_mStorageObject.count - 1 != i) {
            [_description appendString:@","];
        }
    }
    
    return _description;
}

@end
