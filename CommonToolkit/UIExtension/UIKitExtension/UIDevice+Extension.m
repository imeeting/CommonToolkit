//
//  UIDevice+Extension.m
//  CommonToolkit
//
//  Created by Ares on 12-8-9.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIDevice+Extension.h"

@implementation UIDevice (Extension)

- (CGFloat)systemVersionNum{
    return self.systemVersion.floatValue;
}

- (SystemCurrentSettingLanguage)systemCurrentSettingLanguage{
    SystemCurrentSettingLanguage _ret;
    
    // get system preferred language
    NSString *_preferredLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // english
    if ([_preferredLanguage isEqualToString:@"en"]) {
        _ret = en;
    }
    // simplified chinese
    else if ([_preferredLanguage isEqualToString:@"zh-Hans"]) {
        _ret = zh_Hans;
    }
    // traditional chinese
    else if ([_preferredLanguage isEqualToString:@"zh-Hant"]) {
        _ret = zh_Hant;
    }
    // others
    else {
        _ret = en;
    }
    
    return _ret;
}

- (CGFloat)statusBarHeight{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (CGFloat)navigationBarHeight{
    // navigation bar default height
    return 44.0;
}

@end
