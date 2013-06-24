//
//  NSStack.h
//  CommonToolkit
//
//  Created by Ares on 13-6-6.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStack : NSObject {
    // storage with mutable array
    NSMutableArray *_mStorageObject;
}

// push an element to stack
- (void)push:(id)pElement;

// pop the top element
- (id)pop;

// clear the stack
- (void)clear;

// get the top element
- (id)top;

// check the stact is or not empty
- (BOOL)empty;

// element count
- (NSUInteger)count;

// stack description
- (NSString *)stackDescription;

@end
