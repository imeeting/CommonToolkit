//
//  CommonUtils.h
//  CommonToolkit
//
//  Created by Ares on 12-6-9.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject

// validate processor and its implemetation method
+ (BOOL)validateProcessor:(id)pProcessor andSelector:(SEL)pSelector;

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
