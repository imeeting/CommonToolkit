//
//  NSMutableString+Extension.h
//  CommonToolkit
//
//  Created by Ares on 13-6-4.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (Extension)

// clear all characters
- (NSMutableString *)clear;

// append format
- (NSMutableString *)appendFormatAndReturn:(NSString *)format, ...;

@end
