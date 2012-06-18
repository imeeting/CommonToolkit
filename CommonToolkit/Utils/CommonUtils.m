//
//  CommonUtils.m
//  CommonToolkit
//
//  Created by  on 12-6-9.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "CommonUtils.h"

#import "HttpRequestManager.h"

#import "UIViewExtensionManager.h"

@implementation CommonUtils

+ (SystemLanguage)systemCurrentSettingLanguage{
    SystemLanguage _ret;
    
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

+ (BOOL)validateProcessor:(id)pProcessor andSelector:(SEL)pSelector{
    BOOL _ret = NO;
    
    if (pProcessor && [pProcessor respondsToSelector:pSelector]) {
        _ret = YES;
    }
    else {
        NSLog(@"%@ : %@", pProcessor ? @"warning" : @"error", pProcessor ? [NSString stringWithFormat:@"processor = %@ cann't implement method = %@", pProcessor, NSStringFromSelector(pSelector)] : @"processor is nil");
    }

    return _ret;
}

+ (CGFloat)appStatusBarHeight{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

+ (CGFloat)appNavigationBarHeight{
    return 44.0;
}

+ (void)printHttpRequestBeanDictionary{
    [[HttpRequestManager shareHttpRequestManager] printHttpRequestBeanDictionary];
}

+ (void)printUIViewExtensionBeanDictionary{
    [[UIViewExtensionManager shareUIViewExtensionManager] printUIViewExtensionBeanDictionary];
}

@end
