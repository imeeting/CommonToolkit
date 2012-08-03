//
//  NSBundle+Extension.m
//  CommonToolkit
//
//  Created by  on 12-6-18.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "NSBundle+Extension.h"
#import "NSString+Extension.h"

// bundle name suffix
#define BUNDLENAME_SUFFIX    @".bundle"

// resource type suffix
#define RESOURCETYPE_SUFFIX @"."

@implementation NSBundle (ResourcesFromBundle)

- (NSString *)localizedStringFromBundle:(NSString *)pBundleName forKey:(NSString *)pKey value:(NSString *)pValue inTable:(NSString *)pTableName{    
    // check bundle name
    if (![pBundleName hasSuffix:BUNDLENAME_SUFFIX]) {
        pBundleName = [NSString stringWithFormat:@"%@%@", pBundleName, BUNDLENAME_SUFFIX];
    }
    
    // get bundle
    NSBundle *_bundle = [NSBundle bundleWithPath:[[self resourcePath] stringByAppendingPathComponent:pBundleName]];
    
    // return localized string
    return [_bundle localizedStringForKey:pKey value:pValue table:pTableName];
}

- (NSString *)resourcePathFromBundle:(NSString *)pBundleName name:(NSString *)pName{
    // define resource default type
    NSString *_resDefType = @"png";
    
    // reset resource name and type
    if ([pName containsSubString:RESOURCETYPE_SUFFIX]) {
        _resDefType = [pName substringFromIndex:[pName rangeOfString:RESOURCETYPE_SUFFIX].location + 1];
        pName = [pName substringToIndex:[pName rangeOfString:RESOURCETYPE_SUFFIX].location];
    }
    
    // check bundle name
    if (![pBundleName hasSuffix:BUNDLENAME_SUFFIX]) {
        pBundleName = [NSString stringWithFormat:@"%@%@", pBundleName, BUNDLENAME_SUFFIX];
    }
    
    // get bundle
    NSBundle *_bundle = [NSBundle bundleWithPath:[[self resourcePath] stringByAppendingPathComponent:pBundleName]];
    
    // return resource path
    return [_bundle pathForResource:pName ofType:_resDefType];
}

@end
