//
//  UIDevice+Extension.m
//  CommonToolkit
//
//  Created by Ares on 12-8-9.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIDevice+Extension.h"

#import <sys/utsname.h>

// UIDevice extension
@interface UIDevice (Private)

// UIDevice hardware platform
@property (nonatomic, readonly) NSString *platform;

@end




@implementation UIDevice (Extension)

- (CGFloat)systemVersionNum{
    return self.systemVersion.floatValue;
}

- (NSString *)uniqueId{
    NSString *_ret = nil;
    
    // generate unique identifier with system
    if ([self respondsToSelector:@selector(identifierForVendor)]) {
        _ret = self.identifierForVendor.UUIDString;
    }
    else {
        _ret = [self performSelector:@selector(uniqueIdentifier)];
    }
    
    return _ret;
}

- (NSString *)hardwareModel{
    NSString *_ret;
    
    // get and hardware platform
    NSString *_platform = [self platform];
    if ([@"iPhone1,1" isEqualToString:_platform]) {
        _ret = @"iPhone 1G";
    }
    else if ([@"iPhone1,2" isEqualToString:_platform]) {
        _ret = @"iPhone 3G";
    }
    else if ([@"iPhone2,1" isEqualToString:_platform]) {
        _ret = @"iPhone 3GS";
    }
    else if ([@"iPhone3,1" isEqualToString:_platform]) {
        _ret = @"iPhone 4";
    }
    else if ([@"iPhone3,2" isEqualToString:_platform]) {
        _ret = @"iPhone 4S";
    }
    else if ([@"iPhone4,1" isEqualToString:_platform]) {
        _ret = @"iPhone 5";
    }
    else if ([@"iPod1,1" isEqualToString:_platform]) {
        _ret = @"iPod Touch 1G";
    }
    else if ([@"iPod2,1" isEqualToString:_platform]) {
        _ret = @"iPod Touch 2G";
    }
    else if ([@"iPod3,1" isEqualToString:_platform]) {
        _ret = @"iPod Touch 3G";
    }
    else if ([@"iPod4,1" isEqualToString:_platform]) {
        _ret = @"iPod Touch 4G";
    }
    else if ([@"x86_64" isEqualToString:_platform] || [@"i386" isEqualToString:_platform]) {
        _ret = [self model];
    }
    else {
        NSLog(@"Unknown plateform = %@", _platform);
    }
    
    return _ret;
}

- (SystemCurrentSettingLanguage)systemCurrentSettingLanguage{
    SystemCurrentSettingLanguage _ret;
    
    // get system preferred language
    NSString *_preferredLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // english
    if ([_preferredLanguage isEqualToString:@"en"]) {
        _ret = en;
    }
    // simplified chinese
    else if ([_preferredLanguage isEqualToString:@"zh-Hans"]) {
        _ret = zh_Hans;
    }
    // traditional chinese
    else if ([_preferredLanguage isEqualToString:@"zh-Hant"]) {
        _ret = zh_Hant;
    }
    // others
    else {
        _ret = en;
    }
    
    return _ret;
}

@end




@implementation UIDevice (Private)

- (NSString *)platform{
    // define and init utsname
    struct utsname _utsname;
    uname(&_utsname);
    
    // return machine platform
    return [NSString stringWithCString:_utsname.machine encoding:NSUTF8StringEncoding];
}

@end
