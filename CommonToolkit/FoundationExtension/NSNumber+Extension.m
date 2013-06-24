//
//  NSNumber+Extension.m
//  CommonToolkit
//
//  Created by Ares on 12-7-9.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "NSNumber+Extension.h"

@implementation NSNumber (Common)

+ (NSNumber *)numberWithCString:(char *)pCString{
    NSNumber *_ret = nil;
    
    // check c string and update return result
    if (NULL != pCString) {
        _ret = [self numberWithString:[NSString stringWithUTF8String:pCString]];
    }
    
    return _ret;
}

+ (NSNumber *)numberWithString:(NSString *)pString{
    // create and init number formatter
    NSNumberFormatter *_formatter = [[NSNumberFormatter alloc] init];
    
    // set number style: NSNumberFormatterDecimalStyle
    [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [_formatter numberFromString:pString];
}

@end
