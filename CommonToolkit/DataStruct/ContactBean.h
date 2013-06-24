//
//  ContactBean.h
//  CommonToolkit
//
//  Created by Ares on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactBean : NSObject

// contact id
@property (nonatomic, readwrite) NSInteger id;
// contact group array
@property (nonatomic, retain) NSArray *groups;
// contact display name
@property (nonatomic, retain) NSString *displayName;
// contact full name array
@property (nonatomic, retain) NSArray *fullNames;
// contact name phonetic array
@property (nonatomic, retain) NSArray *namePhonetics;
// contact phone number array
@property (nonatomic, retain) NSArray *phoneNumbers;
// contact photo
@property (nonatomic, retain) NSData *photo;

// compare with another contact
- (NSComparisonResult)compare:(ContactBean *)pContactBean;

// copy contact bean base property
- (ContactBean *)copyBaseProp:(ContactBean *)pContactBean;

@end
