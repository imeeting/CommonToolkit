//
//  NSNumber+Extension.h
//  CommonToolkit
//
//  Created by Ares on 12-7-9.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Common)

// number with c string with encoding UTF-8
+ (NSNumber *)numberWithCString:(char *)pCString;

// number with string
+ (NSNumber *)numberWithString:(NSString *)pString;

@end
