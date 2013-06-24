//
//  DataStorageUtils.h
//  CommonToolkit
//
//  Created by Ares on 13-6-14.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

// data storage type
typedef NS_ENUM(NSInteger, StorageType){
    // userDefaults, files and sqlite
    USERDEFAULTS, FILES, SQLITE
};


@interface DataStorageUtils : NSObject

// put object with storage type and file name
+ (void)putObject:(NSString *)fileName storageType:(StorageType)storageType key:(NSString *)key value:(id)value;

@end
