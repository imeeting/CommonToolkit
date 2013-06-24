//
//  UserBean.m
//  CommonToolkit
//
//  Created by Ares on 12-6-11.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UserBean.h"

#import "UserBean_Extension.h"

@implementation UserBean

@synthesize name = _name;
@synthesize password = _password;
@synthesize userKey = _userKey;

@synthesize extensionDic = _extensionDic;

- (id)init{
    self = [super init];
    if (self) {
        // init UserBean extension dictionary
        _extensionDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"UserBean description: user name = %@, password = %@ and user key = %@, extension dictionary = %@", _name, _password, _userKey, _extensionDic];
}

@end
