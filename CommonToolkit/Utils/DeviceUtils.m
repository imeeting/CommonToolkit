//
//  DeviceUtils.m
//  CommonToolkit
//
//  Created by Ares on 13-6-6.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "DeviceUtils.h"

@implementation DeviceUtils

+ (NSString *)systemSettingLanguage{
    // get apple languages
    NSArray *_appleLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    
    // return system current setting language
    return [_appleLanguages objectAtIndex:0];
}

@end
