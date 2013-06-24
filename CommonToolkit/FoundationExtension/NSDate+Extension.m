//
//  NSDate+Extension.m
//  CommonToolkit
//
//  Created by Ares on 12-6-18.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString *)stringWithFormat:(NSString *)pFormat{
    // create and init dataFormatter
    NSDateFormatter *_dateFormatter = [[NSDateFormatter alloc] init];
    
    // set data format
    [_dateFormatter setDateFormat:pFormat];
    
    // return data string
    return [_dateFormatter stringFromDate:self];
}

@end
