//
//  NSNumber+Extension.m
//  CommonToolkit
//
//  Created by  on 12-7-9.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "NSNumber+Extension.h"

@implementation NSNumber (Common)

+ (NSNumber *)numberWithString:(NSString *)pString{
    // create and init number formatter
    NSNumberFormatter *_formatter = [[NSNumberFormatter alloc] init];
    
    // set number style: NSNumberFormatterDecimalStyle
    [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    return [_formatter numberFromString:pString];
}

@end
