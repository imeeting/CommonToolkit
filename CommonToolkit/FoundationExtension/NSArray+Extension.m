//
//  NSArray+Extension.m
//  CommonToolkit
//
//  Created by Ares on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "NSArray+Extension.h"
#import "NSString+Extension.h"

#import "UIDevice+Extension.h"

@implementation NSArray (Contact)

- (NSString *)getContactPhoneNumbersDisplayTextWithStyle:(PhoneNumbersDisplayStyle)pStyle{
    NSMutableString *_ret = [[NSMutableString alloc] init];
    
    // check display stype
    switch (pStyle) {
        case vertical:
            [_ret appendString:[self toStringWithSeparator:@"\n"]];
            break;
        
        case horizontal:
        default:
            [_ret appendString:[self toStringWithSeparator:@" "]];
            break;
    }
    
    // judge phoneNumsLabel text
    if ([_ret isNil]) {
        // check system current setting language 
        switch ([UIDevice currentDevice].systemCurrentSettingLanguage) {
            case zh_Hans:
                [_ret appendString:@"无号码"];
                break;
                
            case zh_Hant:
                [_ret appendString:@"無號碼"];
                break;
                
            case en:
            default:
                [_ret appendString:@"No Phone Number"];
                break;
        }
    }
    
    return _ret;
}

@end




@implementation NSArray (Common)

+ (id)arrayWithRange:(NSRange)pRange{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    for (NSInteger _index = 0; _index < pRange.length; _index++) {
        [_ret addObject:[NSNumber numberWithInteger:_index + pRange.location]];
    }
    
    return _ret;
}

- (NSString *)toStringWithSeparator:(NSString *)pSeparator{
    NSMutableString *_ret = [[NSMutableString alloc] init];
    
    if (self) {
        for (NSInteger _index = 0; _index < [self count]; _index++) {
            id _object = [self objectAtIndex:_index];
            
            // append string
            [_ret appendString:_object];
            
            if (_index != [self count] - 1) {
                // append separator
                [_ret appendFormat:@"%@", pSeparator ? pSeparator : @""];
            }
        }
    }
    
    return _ret;
}

@end
