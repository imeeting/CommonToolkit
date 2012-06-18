//
//  AddressBookManager.h
//  CommonToolkit
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AddressBook/AddressBook.h>

#import "ContactBean.h"

@interface AddressBookManager : NSObject

// all contact id - group dictionary
@property (nonatomic, readonly) NSMutableDictionary *contactsIdGroupDic;
// all contact phone number - name dictionary
@property (nonatomic, readonly) NSMutableDictionary *contactsPhoneNumberNameDic;
// all contacts info array
@property (nonatomic, readonly) NSMutableArray *allContactsInfoArray;

// share singleton AddressBookManager
+ (AddressBookManager *)shareAddressBookManager;

// traversal address book
- (void)traversalAddressBook;

@end
