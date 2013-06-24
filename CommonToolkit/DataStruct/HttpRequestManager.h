//
//  HttpRequestManager.h
//  CommonToolkit
//
//  Created by Ares on 12-6-16.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HttpRequestBean.h"

@interface HttpRequestManager : NSObject {
    /*  http request bean dictionary
     key = http request hash code(NSNumber)
     value = http request bean(HttpRequestBean)
     */
    NSMutableDictionary *_mHttpRequestBeanDic;
}

// share singleton HttpRequestManager
+ (HttpRequestManager *)shareHttpRequestManager;

// set HttpRequestBean for key
- (void)setHttpRequestBean:(HttpRequestBean *)pHttpRequestBean forKey:(NSNumber *)pKey;

// remove HttpRequestBean for key
- (void)removeHttpRequestBeanForKey:(NSNumber *)pKey;

// get HttpRequestBean for key
- (HttpRequestBean *)httpRequestBeanForKey:(NSNumber *)pKey;

// print http request bean dictionary
- (void)printHttpRequestBeanDictionary;

@end
