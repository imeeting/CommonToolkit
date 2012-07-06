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

@interface AddressBookManager : NSObject {
    // all contacts, contact id - groups dictionary
    // key is contact record id (int32_t)
    // value is contact group array (NSArray)
    NSMutableDictionary *_mContactIdGroupsDic;
    
    // all contacts info array, object is contact bean
    NSMutableArray *_mAllContactsInfoArray;
    
    // contact search result dictionary
    // key is search keyword (NSString)
    // value is contact bean (ContactBean)
    NSMutableDictionary *_mContactSearchResultDic;
}

@property (nonatomic, readonly) NSMutableArray *allContactsInfoArray;

// share singleton AddressBookManager
+ (AddressBookManager *)shareAddressBookManager;

// traversal address book, inportant, do it first
- (void)traversalAddressBook;

// get contacts by phone number: sub matching
- (NSArray *)getContactByPhoneNumber:(NSString *)pPhoneNumber;

// get contacts by name(not chinaese character): fuzzy matching
- (NSArray *)getContactByName:(NSString *)pName;

// get contact end
- (void)getContactEnd;

// contacts display name array with user input phone number
- (NSArray *)contactsDisplayNameArrayWithPhoneNumber:(NSString *)pPhoneNumber;

@end
