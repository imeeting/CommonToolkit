//
//  PinyinUtils.m
//  CommonToolkit
//
//  Created by Ares on 12-8-22.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "PinyinUtils.h"

#import "NSString+Extension.h"

#import "NSBundle+Extension.h"

@implementation PinyinUtils

+ (NSArray *)pinyins4Char:(unichar)pChar{
    // generate unichar unicode string
    NSString *_unicharString = [NSString stringWithFormat:@"%0X", pChar];
    
    // get pinyin array with pinyin4j bundle
    NSArray *_pinyins = [NSLocalizedStringFromPinyin4jBundle(_unicharString, nil) toArrayWithSeparator:@","];
    
    return [_unicharString isEqualToString:[_pinyins objectAtIndex:0]] ? nil : _pinyins;
}

+ (NSArray *)pinyins4String:(NSString *)pString{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // define not Chinese character string buffer
    NSMutableString *_notCCSB = [[NSMutableString alloc] init];
    
    // get each character of string parameter
    for (NSInteger _index = 0; _index < pString.length; _index++) {
        // get character converted pinyin array
        NSArray *_charPinyins = [self pinyins4Char:[pString characterAtIndex:_index]];
        
        // not Chinese character, hold the original, else add the converted pinyin array
        if (nil == _charPinyins) {
            // append char to not Chinese character string buffer
            [_notCCSB appendString:[[pString substringWithRange:NSMakeRange(_index, 1)] lowercaseString]];
        }
        else {
            // add not Chinese character string builder to result and clear it
            if (0 != _notCCSB.length) {
                [_ret addObject:[NSArray arrayWithObject:[NSString stringWithString:_notCCSB]]];
                [_notCCSB setString:@""];
            }
            
            // add character pinyin array to result
            [_ret addObject:_charPinyins];
        }
    }
    
    // add not Chinese character string builder to result
    if (0 != _notCCSB.length) {
        [_ret addObject:[NSArray arrayWithObject:[NSString stringWithString:_notCCSB]]];
    }
    
    return _ret;
}

@end
