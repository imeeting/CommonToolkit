//
//  AddressBookManager.m
//  CommonToolkit
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "AddressBookManager.h"

#import "NSString+Extension.h"
#import "CommonUtils.h"

// static singleton AddressBookManager reference
static AddressBookManager *singletonAddressBookManagerRef;

// AddressBookManager extension
@interface AddressBookManager ()

// get contact's full name
- (NSString *)getContactFullNameByRecord:(ABRecordRef)record;

// get contact's phone numbers array
- (NSMutableArray *)getContactPhoneNumbersByRecord:(ABRecordRef)record;

// init all contacts id - group dictionary
- (void)initContactsIdGroupDictionary;

// init all contacts phone number - name dictionary
- (void)initContactsPhoneNumberNameDictionary;

// get all contacts info array from address book
/*
 * contact info is a NSDictionary. It's keys: id, group, name, phoneNums and photo, values: <int>
 * <id>(id), <NSString*>(group), <NSString*>(name), <NSArray*>(phoneNums) and  <NSDate*>(photo) 
 */
- (NSMutableArray *)getAllContactsInfoFromAB;

@end




@implementation AddressBookManager

@synthesize contactsIdGroupDic = _contactsIdGroupDic;
@synthesize contactsPhoneNumberNameDic = _contactsPhoneNumberNameDic;
@synthesize allContactsInfoArray = _allContactsInfoArray;

- (id)init{
    self = [super init];
    if (self) {
        /*
        // fetch the address book, addressBook manager object 
        ABAddressBookRef addressBook = ABAddressBookCreate();
        
        // register external change callback function
        ABAddressBookRegisterExternalChangeCallback(addressBook, pSelector, nil);
        
        // release
        CFRelease(addressBook);
         */
    }
    return self;
}

+ (AddressBookManager *)shareAddressBookManager{
    @synchronized(self){
        if (nil == singletonAddressBookManagerRef) {
            singletonAddressBookManagerRef = [[self alloc] init];
        }
    }
    
    return singletonAddressBookManagerRef;
}

- (void)traversalAddressBook{
    // traversal addressBook
    [self initContactsIdGroupDictionary];
    [self initContactsPhoneNumberNameDictionary];
    _allContactsInfoArray = [self getAllContactsInfoFromAB];
}

- (NSString *)getContactFullNameByRecord:(ABRecordRef)record{
    NSString *_ret = nil;
    
    // get person first name, middle name and last name
    NSString *_firstName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
    NSString *_middleName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonMiddleNameProperty);
    NSString *_lastName = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonLastNameProperty);
    
    // check first, middle and last name
    _firstName = (!_firstName) ? @"" : _firstName;
    _middleName = (!_middleName) ? @"" : _middleName;
    _lastName = (!_lastName) ? @"" : _lastName;
    
    // donn't need to use MiddleName usually
    // check system current setting language
    switch ([CommonUtils systemCurrentSettingLanguage]) {
        case zh_Hans:
            _ret = [[NSString stringWithFormat:@"%@ %@", _lastName, _firstName] isNil] ? @"无名字" : [NSString stringWithFormat:@"%@ %@", _lastName, _firstName];
            break;
            
        case zh_Hant:
            _ret = [[NSString stringWithFormat:@"%@ %@", _lastName, _firstName] isNil] ? @"無名字" : [NSString stringWithFormat:@"%@ %@", _lastName, _firstName];
            break;
            
        case en:
        default:
            _ret = [[NSString stringWithFormat:@"%@ %@", _firstName, _lastName] isNil] ? @"No Name" : [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
            break;
    }
    
    return _ret;
}

- (NSMutableArray *)getContactPhoneNumbersByRecord:(ABRecordRef)record{
    NSMutableArray *_ret = nil;
    
    // get contact's phone numbers temp array
    ABMultiValueRef _tempPNArray = (ABMultiValueRef)ABRecordCopyValue(record, kABPersonPhoneProperty);
    
    // check temp phone numbers array
    if(_tempPNArray){
        _ret = [[NSMutableArray alloc] init];
        
        // process temp phone number array
        for(int _index = 0; _index < ABMultiValueGetCount(_tempPNArray); _index++){
            NSString *phoneNumber = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(_tempPNArray, _index); 
            
            // add each phone to phone number array
            [_ret addObject:[phoneNumber trimPhoneNumberSeparator]];
        }
    }
    
    CFRelease(_tempPNArray);
    
    return _ret;
}

- (void)initContactsIdGroupDictionary{
    if (!_contactsIdGroupDic) {
        _contactsIdGroupDic = [[NSMutableDictionary alloc] init];
    }
    else {
        // return immediately
        return;
    }
    
    // fetch the address book, addressBook manager object 
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // get all groups
    CFArrayRef _groups = ABAddressBookCopyArrayOfAllGroups(addressBook);
    
    // process groups array
    for(int _index = 0; _index < CFArrayGetCount(_groups); _index++){
        // get group object
        ABRecordRef _group = CFArrayGetValueAtIndex(_groups, _index);
        
        // get group name, part of contacts id - group dictionary value
        NSString *_groupName = (__bridge NSString*)ABRecordCopyValue(_group, kABGroupNameProperty);
        
        // get all group members
        CFArrayRef _groupMembers = ABGroupCopyArrayOfAllMembers(_group);
        
        // process the group members array 
        for (int __index = 0; __index < CFArrayGetCount(_groupMembers); __index++) {
            // get group member id
            ABRecordID _memberID = ABRecordGetRecordID(CFArrayGetValueAtIndex(_groupMembers, __index));
            
            // judge group member id
            if ([[_contactsIdGroupDic allKeys] containsObject:[NSNumber numberWithInt:_memberID]]) {
                // get value
                NSMutableString *_value = [[NSMutableString alloc] initWithString:[_contactsIdGroupDic objectForKey:[NSNumber numberWithInt:_memberID]]];
                
                // append the group name
                [_value appendFormat:@", %@", _groupName];
                // set dictionary
                [_contactsIdGroupDic setObject:_value forKey:[NSNumber numberWithInt:_memberID]];
            }
            else{
                // set dictionary
                [_contactsIdGroupDic setObject:_groupName forKey:[NSNumber numberWithInt:_memberID]];
            }
        }
    }
    
    // release
    CFRelease(addressBook);
}

- (void)initContactsPhoneNumberNameDictionary{
    if (!_contactsPhoneNumberNameDic) {
        _contactsPhoneNumberNameDic = [[NSMutableDictionary alloc] init];
    }
    else {
        // return immediately
        return;
    }
    
    // fetch the address book, addressBook manager object 
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // get all contacts
    CFArrayRef _contacts = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    // process contacts array
    for(int _index = 0; _index < CFArrayGetCount(_contacts); _index++){
        // get person object
        ABRecordRef _person = CFArrayGetValueAtIndex(_contacts, _index);
        
        // get person info
        // full name
        NSString *_fullName = [self getContactFullNameByRecord:_person];
        // phone number array
        NSArray *_phoneNumbers = [self getContactPhoneNumbersByRecord:_person];
        
        // set dictionary
        for(NSString *_string in _phoneNumbers){
            [_contactsPhoneNumberNameDic setObject:_fullName forKey:_string];
        }
    }
    
    // release
    CFRelease(addressBook);
}

- (NSMutableArray *)getAllContactsInfoFromAB{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // fetch the address book, addressBook manager object 
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // get all contacts
    CFArrayRef _contacts = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    // process contacts array
    for(int _index = 0; _index < CFArrayGetCount(_contacts); _index++){
        // get contact record reference
        ABRecordRef _person = CFArrayGetValueAtIndex(_contacts, _index);
        
        // get contact info
        // id
        ABRecordID _recordID = ABRecordGetRecordID(_person);
        // group
        if (!_contactsIdGroupDic) {
            [self initContactsIdGroupDictionary];
        }
        NSString* _groupName = [_contactsIdGroupDic objectForKey:[NSNumber numberWithInt:_recordID]];
        // full name
        NSString *_fullName = [self getContactFullNameByRecord:_person];
        // phone number array
        NSArray *_phoneNumbers = [self getContactPhoneNumbersByRecord:_person];
        // photo
        NSData* _photo = (__bridge NSData*)ABPersonCopyImageData(_person);
        
        // create and init ContactBean object and set its attributes
        ContactBean *_contactBean = [[ContactBean alloc] init];
        _contactBean.id = _recordID;    // id
        _contactBean.group = _groupName;    // group
        _contactBean.fullName = _fullName;  // full name
        _contactBean.phoneNumbers = _phoneNumbers;  // phone numbers
        _contactBean.photo = _photo;    // photo
        
        // add contactBean in all contacts array
        [_ret addObject:_contactBean];
    }
    
    // release
    CFRelease(addressBook);
    
    return _ret;
}

@end
