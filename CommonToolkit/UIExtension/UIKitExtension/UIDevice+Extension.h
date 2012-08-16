//
//  UIDevice+Extension.h
//  CommonToolkit
//
//  Created by Ares on 12-8-9.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

// system current setting language
typedef enum {
    // English
    en,
    // Simplified Chinese
    zh_Hans,
    // Traditional Chinese
    zh_Hant
} SystemCurrentSettingLanguage;


@interface UIDevice (Extension)

// system version number
@property (nonatomic, readonly) CGFloat systemVersionNum;

// system current seeting language
@property (nonatomic, readonly) SystemCurrentSettingLanguage systemCurrentSettingLanguage;

// UIApplication status bar height
@property (nonatomic, readonly) CGFloat statusBarHeight;

// UIApplication navigation bar default height
@property (nonatomic, readonly) CGFloat navigationBarHeight;

@end
