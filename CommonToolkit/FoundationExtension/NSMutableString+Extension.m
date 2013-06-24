//
//  NSMutableString+Extension.m
//  CommonToolkit
//
//  Created by Ares on 13-6-4.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "NSMutableString+Extension.h"

@implementation NSMutableString (Extension)

- (NSMutableString *)clear{
    // check self and delete all characters
    if (nil != self && self.length > 0) {
        [self deleteCharactersInRange:NSMakeRange(0, self.length)];
    }
    
    return self;
}

- (NSMutableString *)appendFormatAndReturn:(NSString *)format, ...{
    // define argument list
    va_list _argList;
    
    va_start(_argList, format);
    
    // append format string
    [self appendString:[[NSString alloc] initWithFormat:format arguments:_argList]];
    
    va_end(_argList);
    
    return self;
}

@end
