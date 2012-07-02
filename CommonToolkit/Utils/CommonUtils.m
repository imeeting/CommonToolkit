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
#import "AddressBookManager.h"
#import "FoundationExtensionManager.h"

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
        NSLog(@"%@ : %@", pProcessor ? @"Warning" : @"Error", pProcessor ? [NSString stringWithFormat:@"processor = %@ can't implement method = %@", pProcessor, NSStringFromSelector(pSelector)] : @"processor is nil");
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

+ (void)printContactSearchResultDictionary{
    [[AddressBookManager shareAddressBookManager] performSelector:@selector(printContactSearchResultDictionary)];
}

+ (void)printFoundationExtensionBeanDictionary{
    [[FoundationExtensionManager shareFoundationExtensionManager] printFoundationExtensionBeanDictionary];
}

@end
