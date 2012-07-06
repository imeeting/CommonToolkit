//
//  CommonUtils.h
//  CommonToolkit
//
//  Created by  on 12-6-9.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

// ios system currently setting language
typedef enum {
    // English
    en,
    // Simplified Chinese
    zh_Hans,
    // Traditional Chinese
    zh_Hant
} SystemLanguage;


@interface CommonUtils : NSObject

// get system current setting language
+ (SystemLanguage)systemCurrentSettingLanguage;

// validate processor and its implemetation method
+ (BOOL)validateProcessor:(id)pProcessor andSelector:(SEL)pSelector;

// get application status bar default height
+ (CGFloat)appStatusBarHeight;

// get application navigation bar default height
+ (CGFloat)appNavigationBarHeight;

// convert NSInteger to binary array(NSNumber *)
+ (NSArray *)convertIntegerToBinaryArray:(NSInteger)pInteger;

@end




// CommonUtils extension
@interface CommonUtils ()

// print http request bean dictionary
+ (void)printHttpRequestBeanDictionary;

// print UIView extension bean dictionary
+ (void)printUIViewExtensionBeanDictionary;

// print contact search result dictionary
+ (void)printContactSearchResultDictionary;

// print Foundation extension bean dictionary
+ (void)printFoundationExtensionBeanDictionary;

@end
