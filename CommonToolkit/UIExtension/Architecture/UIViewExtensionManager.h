//
//  UIViewExtensionManager.h
//  CommonToolkit
//
//  Created by Ares on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIViewExtensionBean.h"

@interface UIViewExtensionManager : NSObject {
    /*  UIView extension bean dictionary
     key = UIView object hash code(NSNumber)
     value = UIView extension bean(UIViewExtensionBean)
     */
    NSMutableDictionary *_mUIViewExtensionBeanDic;
}

// share singleton UIViewExtensionManager
+ (UIViewExtensionManager *)shareUIViewExtensionManager;

// set UIView extension with type for key
- (void)setUIViewExtension:(id)pExtension withType:(UIViewExtensionType)pType forKey:(NSNumber *)pKey;

// remove UIView extension for key
- (void)removeUIViewExtensionForKey:(NSNumber *)pKey;

// get UIViewExtensionBean for key
- (UIViewExtensionBean *)uiViewExtensionForKey:(NSNumber *)pKey;

// set UIViewExtensionBean extension info dectionary value with extInfoDic key for key
- (void)setUIViewExtensionExtInfoDicValue:(id)pExtInfoDicValue withExtInfoDicKey:(NSString *)pExtInfoDicKey forKey:(NSNumber *)pKey;

// print UIView extension bean dictionary
- (void)printUIViewExtensionBeanDictionary;

@end
