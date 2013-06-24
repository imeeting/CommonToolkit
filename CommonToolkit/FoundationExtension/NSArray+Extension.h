//
//  NSArray+Extension.h
//  CommonToolkit
//
//  Created by Ares on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

// phone numbers display style
typedef enum {
    vertical,
    horizontal
} PhoneNumbersDisplayStyle;


@interface NSArray (Contact)

// get contact's phone numbers display text with style
- (NSString *)getContactPhoneNumbersDisplayTextWithStyle:(PhoneNumbersDisplayStyle)pStyle;

@end




@interface NSArray (Common)

// array with NSRange, object is NSNumber
+ (id)arrayWithRange:(NSRange)pRange;

// convert to string with separator
- (NSString *)toStringWithSeparator:(NSString *)pSeparator;

@end
