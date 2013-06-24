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

// unique identifier
@property (nonatomic, readonly) NSString *uniqueId;

// hardware model
@property (nonatomic, readonly) NSString *hardwareModel;

// system current seeting language
@property (nonatomic, readonly) SystemCurrentSettingLanguage systemCurrentSettingLanguage;

@end
