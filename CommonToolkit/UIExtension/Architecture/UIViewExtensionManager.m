//
//  UIViewExtensionManager.m
//  CommonToolkit
//
//  Created by Ares on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIViewExtensionManager.h"

#import "NSString+Extension.h"

#import "UIViewExtensionBean_Extension.h"

// static singleton UIViewExtensionManager reference
static UIViewExtensionManager *singletonUIViewExtensionManagerRef;

@implementation UIViewExtensionManager

- (id)init{
    self = [super init];
    if (self) {
        // init UIView extension bean dictionary
        _mUIViewExtensionBeanDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (UIViewExtensionManager *)shareUIViewExtensionManager{
    @synchronized(self){
        if (nil == singletonUIViewExtensionManagerRef) {
            singletonUIViewExtensionManagerRef = [[self alloc] init];
        }
    }
    
    return singletonUIViewExtensionManagerRef;
}

- (void)setUIViewExtension:(id)pExtension withType:(UIViewExtensionType)pType forKey:(NSNumber *)pKey{
    // get UIViewExtensionBean object from UIView extension bean dictionary
    UIViewExtensionBean *_uiViewExtensionBean = [self uiViewExtensionForKey:pKey];
    
    // check UIViewExtensionBean object
    _uiViewExtensionBean = _uiViewExtensionBean ? _uiViewExtensionBean : [[UIViewExtensionBean alloc] init];
    
    // update UIViewExtensionBean member and add in UIView extension bean dictionary
    switch (pType) {
        case titleExt:
            _uiViewExtensionBean.title = pExtension;
            break;
            
        case titleViewExt:
            _uiViewExtensionBean.titleView = pExtension;
            break;
            
        case leftBarButtonItemExt:
            _uiViewExtensionBean.leftBarButtonItem = pExtension;
            break;
            
        case rightBarButtonItemExt:
            _uiViewExtensionBean.rightBarButtonItem = pExtension;
            break;
            
        case backgroundImgExt:
            _uiViewExtensionBean.backgroundImg = pExtension;
            break;
            
        case tabBarItemExt:
            _uiViewExtensionBean.tabBarItem = pExtension;
            break;
            
        case viewControllerRefExt:
            _uiViewExtensionBean.viewControllerRef = pExtension;
            break;
            
        case viewGestureRecognizerDelegateExt:
            _uiViewExtensionBean.viewGestureRecognizerDelegate = pExtension;
            break;
            
        case extensionExt:
            _uiViewExtensionBean.extensionDic = pExtension;
            break;
    }
    [_mUIViewExtensionBeanDic setObject:_uiViewExtensionBean forKey:pKey];
}

- (void)removeUIViewExtensionForKey:(NSNumber *)pKey{
    [_mUIViewExtensionBeanDic removeObjectForKey:pKey];
}

- (UIViewExtensionBean *)uiViewExtensionForKey:(NSNumber *)pKey{
    return [_mUIViewExtensionBeanDic objectForKey:pKey] ? [_mUIViewExtensionBeanDic objectForKey:pKey] : [[UIViewExtensionBean alloc] init];
}

- (void)setUIViewExtensionExtInfoDicValue:(id)pExtInfoDicValue withExtInfoDicKey:(NSString *)pExtInfoDicKey forKey:(NSNumber *)pKey{
    // get UIViewExtensionBean
    UIViewExtensionBean *_uiViewExtensionBean = [singletonUIViewExtensionManagerRef uiViewExtensionForKey:pKey];
    
    // add extInfoDic value object to UIViewExtensionBean extension dictionary
    [_uiViewExtensionBean.extensionDic setObject:pExtInfoDicValue forKey:pExtInfoDicKey];
    
    // set UIViewExtensionBean to UIViewExtensionBeanDictionary
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:_uiViewExtensionBean.extensionDic withType:extensionExt forKey:pKey];
}

- (void)printUIViewExtensionBeanDictionary{
    NSLog(@"Important Info: %@, UIView extension bean dictionary = %@", NSStringFromClass(self.class), _mUIViewExtensionBeanDic);
}

@end
