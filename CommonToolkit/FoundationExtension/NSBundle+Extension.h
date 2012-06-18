//
//  NSBundle+Extension.h
//  CommonToolkit
//
//  Created by  on 12-6-18.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

// localized string from other bundle with name
#define NSLocalizedStringFromBundle(bundle, key, comment)   \
    [[NSBundle mainBundle] localizedStringFromBundle:(bundle) forKey:(key) value:@"" table:nil]

// localized string from commonToolkit bundle
#define NSLocalizedStringFromCommonToolkitBundle(key, comment)  \
    [[NSBundle mainBundle] localizedStringFromBundle:@"CommonToolkitBundle" forKey:(key) value:@"" table:nil]

@interface NSBundle (ResourcesFromBundle)

/* Method for retrieving localized strings from other bundle with name. */
- (NSString *)localizedStringFromBundle:(NSString *)pBundleName forKey:(NSString *)pKey value:(NSString *)pValue table:(NSString *)pTableName;

@end
