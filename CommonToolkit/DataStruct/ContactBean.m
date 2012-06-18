//
//  ContactBean.m
//  CommonToolkit
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ContactBean.h"

#import "ContactBean_Extension.h"

@implementation ContactBean

@synthesize id = _id;
@synthesize group = _group;
@synthesize fullName = _fullName;
@synthesize phoneNumbers = _phoneNumbers;
@synthesize photo = _photo;

@synthesize extensionDic = _extensionDic;

- (id)init{
    self = [super init];
    if (self) {
        // init ContactBean extension dictionary
        _extensionDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"ContactBean description: id = %d, group name = %@, full name = %@, phone numbers array = %@ an photo = %@, extension dictionary = %@", _id, _group, _fullName, _phoneNumbers, _photo, _extensionDic];
}

@end
