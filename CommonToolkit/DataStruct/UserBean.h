//
//  UserBean.h
//  CommonToolkit
//
//  Created by Ares on 12-6-11.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBean : NSObject

// user name
@property (nonatomic, retain) NSString *name;
// user password
@property (nonatomic, retain) NSString *password;
// user userKey
@property (nonatomic, retain) NSString *userKey;

@end
