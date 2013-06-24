//
//  FoundationExtensionManager.m
//  CommonToolkit
//
//  Created by Ares on 12-6-25.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "FoundationExtensionManager.h"

// static singleton FoundationExtensionManager reference
static FoundationExtensionManager *singletonFoundationExtensionManagerRef;

@implementation FoundationExtensionManager

- (id)init{
    self = [super init];
    if (self) {
        // init Foundation extension bean dictionary
        _mFoundationExtensionBeanDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (FoundationExtensionManager *)shareFoundationExtensionManager{
    @synchronized(self){
        if (nil == singletonFoundationExtensionManagerRef) {
            singletonFoundationExtensionManagerRef = [[self alloc] init];
        }
    }
    
    return singletonFoundationExtensionManagerRef;
}

- (void)setFoundationExtensionBeanExtInfoDicValue:(id)pExtInfoDicValue withExtInfoDicKey:(NSString *)pExtInfoDicKey forKey:(NSNumber *)pKey{
    // get FoundationExtensionBean
    FoundationExtensionBean *_foundationExtensionBean = [singletonFoundationExtensionManagerRef foundationExtensionForKey:pKey];
    
    // add extInfoDic value object to FoundationExtensionBean extension dictionary
    [_foundationExtensionBean.extensionDic setObject:pExtInfoDicValue forKey:pExtInfoDicKey];
    
    // set FoundationExtensionBean to FoundationExtensionBeanDictionary
    [_mFoundationExtensionBeanDic setObject:_foundationExtensionBean forKey:pKey];
}

- (FoundationExtensionBean *)foundationExtensionForKey:(NSNumber *)pKey{
    return [_mFoundationExtensionBeanDic objectForKey:pKey] ? [_mFoundationExtensionBeanDic objectForKey:pKey] : [[FoundationExtensionBean alloc] init];
}

- (void)removeFoundationExtensionForKey:(NSNumber *)pKey{
    [_mFoundationExtensionBeanDic removeObjectForKey:pKey];
}

- (void)printFoundationExtensionBeanDictionary{
    NSLog(@"Important Info: %@, Foundation extension bean dictionary = %@", NSStringFromClass(self.class), _mFoundationExtensionBeanDic);
}

@end
