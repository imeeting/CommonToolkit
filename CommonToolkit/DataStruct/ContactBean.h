//
//  ContactBean.h
//  CommonToolkit
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactBean : NSObject

// contact id
@property (nonatomic, readwrite) NSInteger id;
// contact group
@property (nonatomic, retain) NSString *group;
// contact full name
@property (nonatomic, retain) NSString *fullName;
// contact phone numbers array
@property (nonatomic, retain) NSArray *phoneNumbers;
// contact photo
@property (nonatomic, retain) NSData *photo;

@end
