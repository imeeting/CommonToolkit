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
