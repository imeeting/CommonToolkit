//
//  UserManager.m
//  CommonToolkit
//
//  Created by  on 12-6-11.
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

- (void)setUser:(NSString *)pName andPassword:(NSString *)pPassword{
    // generator user digit key 
    NSMutableString *_digitKeyString = [[NSMutableString alloc] initWithString:pName];
    [_digitKeyString appendString:pPassword];
    NSString *_digitKey = [_digitKeyString md5];
    
    // set user bean
    _userBean.name = pName;
    _userBean.password = [pPassword md5];
    _userBean.userKey = _digitKey;
}

- (void)removeUser{
    _userBean = nil;
}

@end
