//
//  NSBundle+Extension.m
//  CommonToolkit
//
//  Created by  on 12-6-18.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "NSBundle+Extension.h"

// bundle name suffix
#define BUNDLENAME_SUFFIX    @".bundle"

@implementation NSBundle (ResourcesFromBundle)

- (NSString *)localizedStringFromBundle:(NSString *)pBundleName forKey:(NSString *)pKey value:(NSString *)pValue table:(NSString *)pTableName{    
    // check bundle name
    if (![pBundleName hasSuffix:BUNDLENAME_SUFFIX]) {
        pBundleName = [NSString stringWithFormat:@"%@%@", pBundleName, BUNDLENAME_SUFFIX];
    }
    
    // create and init bundle path
    NSString *_bundlePath = [[self resourcePath] stringByAppendingPathComponent:pBundleName];
    
    // get bundle
    NSBundle *_bundle = [NSBundle bundleWithPath:_bundlePath];
    
    // return localized string
    return [_bundle localizedStringForKey:pKey value:pValue table:pTableName];
}

@end
