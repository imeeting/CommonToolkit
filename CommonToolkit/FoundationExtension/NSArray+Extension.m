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

- (BOOL)isMatchedNamePhonetics:(NSArray *)pMatchesNamePhonetics{
    BOOL _ret = NO;
    
    if (nil != self && nil != pMatchesNamePhonetics && 0 != [self count] && [self count] <= [pMatchesNamePhonetics count]) {
        // split array has more elements
        if ([self count] > 1) {
            // slide split array in matches name phonetics
            for (NSInteger _index = 0; _index < [pMatchesNamePhonetics count] - [self count] + 1; _index++) {
                // check first element in aplit array and matches name phonetics
                BOOL _headerMatched = NO;
                
                for (NSInteger __index = 0; __index < [[pMatchesNamePhonetics objectAtIndex:_index] count]; __index++) {
                    if ([[[pMatchesNamePhonetics objectAtIndex:_index] objectAtIndex:__index] hasPrefix:[self objectAtIndex:0]]) {
                        _headerMatched = YES;
                        
                        break;
                    }
                }
                
                // if header not matched, slide split array
                if (!_headerMatched) {
                    continue;
                }
                
                // remove header, matches others left
                NSArray *_subSplitArray = [self subarrayWithRange:NSMakeRange(1, [self count] - 1)];
                NSArray *_subNamePhonetics = [pMatchesNamePhonetics subarrayWithRange:NSMakeRange(_index + 1, [pMatchesNamePhonetics count] - (_index + 1))];
                
                // left matches
                if ([_subSplitArray isMatchedNamePhonetics:_subNamePhonetics]) {
                    _ret = YES;
                    
                    break;
                }
            }
        }
        // split array just has one element
        else if(1 == [self count]) {
            BOOL _matched = NO;
            
            for (NSInteger _index = 0; _index < [pMatchesNamePhonetics count]; _index++) {
                for (NSInteger __index = 0; __index < [[pMatchesNamePhonetics objectAtIndex:_index] count]; __index++) {
                    if ([[[pMatchesNamePhonetics objectAtIndex:_index] objectAtIndex:__index] hasPrefix:[self objectAtIndex:0]]) {
                        _matched = YES;
                        _ret = YES;
                        
                        break;
                    }
                }
                
                // if matches, break immediately
                if (_matched) {
                    break;
                }
            }
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
