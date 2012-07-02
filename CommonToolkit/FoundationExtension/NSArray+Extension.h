//
//  NSArray+Extension.h
//  CommonToolkit
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

// phone numbers display style
typedef enum {
    vertical,
    horizontal
} PhoneNumbersDisplayStyle;


@interface NSArray (AddressBook)

// get contact's phone numbers display text with style
- (NSString *)getContactPhoneNumbersDisplayTextWithStyle:(PhoneNumbersDisplayStyle)pStyle;

@end




@interface NSArray (Common)

// convert to string with separator
- (NSString *)toStringWithSeparator:(NSString *)pSeparator;

// multiplied by array
- (NSArray *)multipliedByArray:(NSArray *)pArray;

@end
