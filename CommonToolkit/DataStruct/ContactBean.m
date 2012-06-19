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
@synthesize groups = _groups;
@synthesize displayName = _displayName;
@synthesize fullNames = _fullNames;
@synthesize namePhonetics = _namePhonetics;
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
    return [NSString stringWithFormat:@"ContactBean description: id = %d, group array = %@, display name = %@, full name array = %@, name phonetic array = %@, phone number array = %@ an photo = %@, extension dictionary = %@", _id, _groups, _displayName, _fullNames, _namePhonetics, _phoneNumbers, _photo, _extensionDic];
}

@end
