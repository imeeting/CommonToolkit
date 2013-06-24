//
//  PinyinUtils.h
//  CommonToolkit
//
//  Created by Ares on 12-8-22.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinyinUtils : NSObject

// pinyins for character
+ (NSArray *)pinyins4Char:(unichar)pChar;

// pinyins for string
+ (NSArray *)pinyins4String:(NSString *)pString;

@end
