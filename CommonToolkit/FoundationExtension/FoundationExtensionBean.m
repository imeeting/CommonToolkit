//
//  FoundationExtensionBean.m
//  CommonToolkit
//
//  Created by Ares on 12-6-25.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "FoundationExtensionBean.h"

@implementation FoundationExtensionBean

@synthesize extensionDic = _extensionDic;

- (id)init{
    self = [super init];
    if (self) {
        // init FoundationExtensionBean extension info dictionary
        _extensionDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"FoundationExtensionBean description: extension info dictionary = %@", _extensionDic];
}

@end
