//
//  NSValue+Extension.m
//  CommonToolkit
//
//  Created by Ares on 13-6-1.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "NSValue+Extension.h"

@implementation NSValue (Extension)

- (NSString *)stringValue{
    NSString *_ret = nil;
    
    // get pointer value
    char *_cStringValue = self.pointerValue;
    if (NULL != _cStringValue) {
        _ret = [NSString stringWithCString:_cStringValue encoding:NSUTF8StringEncoding];
    }
    
    return _ret;
}

- (unsigned int)unsignedIntValue{
    return (arc4random() % USHRT_MAX) + 1 + USHRT_MAX;
}

+ (NSValue *)valueWithCString:(const char *)pCString{
    return [self valueWithPointer:pCString];
}

@end
