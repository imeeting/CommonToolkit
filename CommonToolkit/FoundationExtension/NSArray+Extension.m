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
    
    // append each phone number
    for (int _index = 0; _index < [self count]; _index++) {
        [_ret appendString:[self objectAtIndex:_index]];
        
        if (_index != [self count]-1) {
            switch (pStyle) {
                case vertical:
                    [_ret appendString:@"\n"];
                    break;
                    
                case horizontal:
                default:
                    [_ret appendString:@" "];
                    break;
            }
        }
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

@end
