//
//  HttpRequestManager.m
//  CommonToolkit
//
//  Created by Ares on 12-6-16.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "HttpRequestManager.h"

// static singleton HttpRequestManager reference
static HttpRequestManager *singletonHttpRequestManagerRef;

@implementation HttpRequestManager

- (id)init{
    self = [super init];
    if (self) {
        // init http request bean dictionary
        _mHttpRequestBeanDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (HttpRequestManager *)shareHttpRequestManager{
    @synchronized(self){
        if (nil == singletonHttpRequestManagerRef) {
            singletonHttpRequestManagerRef = [[self alloc] init];
        }
    }
    
    return singletonHttpRequestManagerRef;
}

- (void)setHttpRequestBean:(HttpRequestBean *)pHttpRequestBean forKey:(NSNumber *)pKey{
    [_mHttpRequestBeanDic setObject:pHttpRequestBean forKey:pKey];
}

- (void)removeHttpRequestBeanForKey:(NSNumber *)pKey{
    [_mHttpRequestBeanDic removeObjectForKey:pKey];
}

- (HttpRequestBean *)httpRequestBeanForKey:(NSNumber *)pKey{
    return [_mHttpRequestBeanDic objectForKey:pKey] ? [_mHttpRequestBeanDic objectForKey:pKey] : [[HttpRequestBean alloc] init];
}

- (void)printHttpRequestBeanDictionary{
    NSLog(@"Important Info: %@, http request bean dictionary = %@", NSStringFromClass(self.class), _mHttpRequestBeanDic);
}

@end
