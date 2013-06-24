//
//  FoundationExtensionManager.h
//  CommonToolkit
//
//  Created by Ares on 12-6-25.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FoundationExtensionBean.h"

@interface FoundationExtensionManager : NSObject {
    /*  Foundation extension bean dictionary
     key = Foundation object hash code(NSNumber)
     value = Foundation extension bean(FoundationExtensionBean)
     */
    NSMutableDictionary *_mFoundationExtensionBeanDic;
}

// share singleton FoundationExtensionManager
+ (FoundationExtensionManager *)shareFoundationExtensionManager;

// set FoundationExtensionBean extension info dectionary value with extInfoDic key for key
- (void)setFoundationExtensionBeanExtInfoDicValue:(id)pExtInfoDicValue withExtInfoDicKey:(NSString *)pExtInfoDicKey forKey:(NSNumber *)pKey;

// get FoundationExtensionBean for key
- (FoundationExtensionBean *)foundationExtensionForKey:(NSNumber *)pKey;

// remove foundation extension for key
- (void)removeFoundationExtensionForKey:(NSNumber *)pKey;

// print foundation extension bean dictionary
- (void)printFoundationExtensionBeanDictionary;

@end
