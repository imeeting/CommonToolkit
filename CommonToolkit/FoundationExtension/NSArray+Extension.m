//
//  NSArray+Extension.m
//  CommonToolkit
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "NSArray+Extension.h"

#import "NSString+Extension.h"
#import "CommonUtils.h"

@implementation NSArray (AddressBook)

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
        switch ([CommonUtils systemCurrentSettingLanguage]) {
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

- (NSArray *)multipliedByArray:(NSArray *)pArray{
    NSMutableSet *_ret = [[NSMutableSet alloc] init];
    
    // check parameter array
    if (self && (!pArray || 0 == [pArray count])) {
        [_ret addObjectsFromArray:self];
    }
    
    // check self
    if (pArray && (!self || 0 == [self count])) {
        [_ret addObjectsFromArray:pArray];
    }
    
    // self and parameter array not nil
    if (self && pArray && [self count] > 0 && [pArray count] > 0) {
        // traversal self
        for (NSString *_selfArrayString in self) {
            // traversal parameter
            for (NSString *_parameterArrayString in pArray) {
                [_ret addObject:[NSString stringWithFormat:@"%@%@", _selfArrayString, _parameterArrayString]];
            }
        }
    }
    
    return [_ret allObjects];
}

@end
