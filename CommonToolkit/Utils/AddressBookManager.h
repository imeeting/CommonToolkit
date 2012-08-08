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

// contact action key
#define CONTACT_ACTION  @"action"

// contact phone number matching index array key
#define PHONENUMBER_MATCHING_INDEXS @"phoneNumberMatchingIndexs"
// contact name matching index array key
#define NAME_MATCHING_INDEXS    @"nameMatchingIndexs"

// contact dirty type
typedef enum {
    contactAdd,
    contactModify,
    contactDelete
} ContactDirtyType;


// contact searched matching type
typedef enum {
    full,
    order
} ContactMatchingType;


// addressBook changed delegate
@protocol AddressBookChangedDelegate <NSObject>

@required

// addressBook changed callback function
- (void)addressBookChanged:(ABAddressBookRef)pAddressBook info:(NSDictionary *)pInfo observer:(id)pObserver;

@end




@interface AddressBookManager : NSObject {
    // all contacts, contact id - groups dictionary
    // key is contact record id (int32_t)
    // value is contact group array (NSArray)
    NSMutableDictionary *_mContactIdGroupsDic;
    
    // all contacts info array, object is contact bean
    NSMutableArray *_mAllContactsInfoArray;
    
    // contact search result dictionary
    // key is search keyword (NSString)
    // value is array of contact bean (ContactBean) and contact matching index array dictionary
    NSMutableDictionary *_mContactSearchResultDic;
    
    // addressBook changed observer
    id _mAddressBookChangedObserver;
}

@property (nonatomic, readonly) NSMutableArray *allContactsInfoArray;

// share singleton AddressBookManager
+ (AddressBookManager *)shareAddressBookManager;

// traversal addressBook, important, do it first
- (void)traversalAddressBook;

// get contact info by particular contact id
- (ContactBean *)getContactInfoById:(NSInteger)pId;

// get contacts by phone number: sub matching
- (NSArray *)getContactByPhoneNumber:(NSString *)pPhoneNumber;

// get contacts by name(not chinaese character): fuzzy matching
- (NSArray *)getContactByName:(NSString *)pName;

// get contacts by name with matching type
- (NSArray *)getContactByName:(NSString *)pName andMatchingType:(ContactMatchingType)pType;

// get contact end
- (void)getContactEnd;

// contacts display name array with user input phone number
- (NSArray *)contactsDisplayNameArrayWithPhoneNumber:(NSString *)pPhoneNumber;

// get the default contact by phone number
- (ContactBean*)defaultContactByPhoneNumber:(NSString*)pPhoneNumber;

// add addressBook changed callback observer
- (void)addABChangedObserver:(id)pObserver;

// remove addressBook changed callback observer
- (void)removeABChangedObserver:(id)pObserver;

@end
