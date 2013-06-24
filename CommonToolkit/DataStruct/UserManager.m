//
//  UserManager.m
//  CommonToolkit
//
//  Created by Ares on 12-6-11.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UserManager.h"

#import "NSString+Extension.h"

// static singleton UserManager reference
static UserManager *singletonUserManagerRef;

@implementation UserManager

@synthesize userBean = _userBean;

- (id)init{
    self = [super init];
    if (self) {
        // init user bean object
        _userBean = [[UserBean alloc] init];
    }
    
    return self;
}

+ (UserManager *)shareUserManager{
    @synchronized(self){
        if (nil == singletonUserManagerRef) {
            singletonUserManagerRef = [[self alloc] init];
        }
    }
    
    return singletonUserManagerRef;
}

- (UserBean*)setUser:(NSString *)pName andPassword:(NSString *)pPassword{
    if(nil == _userBean){
        _userBean = [[UserBean alloc] init];
    }

    // set user bean
    _userBean.name = pName;
    _userBean.password = [pPassword md5];
    
    return _userBean;
}

-(UserBean*) setUserkey:(NSString *)pUserkey {
    if (nil == _userBean) {
        _userBean = [[UserBean alloc] init];
    }
    
    // set user key
    _userBean.userKey = pUserkey;
    return _userBean;
}


- (void)removeUser{
    _userBean = nil;
}

@end
