//
//  UserManager.h
//  CommonToolkit
//
//  Created by Ares on 12-6-11.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserBean.h"

@interface UserManager : NSObject

// user bean: user infomation
@property (nonatomic, retain) UserBean *userBean;

// share singleton UserManager
+ (UserManager *)shareUserManager;

// set user with user name and password
- (UserBean*)setUser:(NSString *)pName andPassword:(NSString *)pPassword;
-(UserBean*) setUserkey:(NSString *)pUserkey;

// remove an user
- (void)removeUser;

@end
