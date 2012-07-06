//
//  AddressBookManager.m
//  CommonToolkit
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "AddressBookManager.h"

#import "NSString+Extension.h"
#import "NSBundle+Extension.h"
#import "CommonUtils.h"

#import "ContactBean_Extension.h"

// static singleton AddressBookManager reference
static AddressBookManager *singletonAddressBookManagerRef;

// AddressBookManager extension
@interface AddressBookManager ()

// get contact's name, phone numbers info by record
- (ContactBean *)getContactNamePhoneNumsInfoByRecord:(ABRecordRef)pRecord;

// get contact information array by particular phone number
- (NSArray *)getContactInfoByPhoneNumber:(NSString *)pPhoneNumber;

// init all contacts contact id - groups dictionary
- (void)initContactIdGroupsDictionary;

// get all contacts info array from address book
- (NSMutableArray *)getAllContactsInfoFromAB;

// print contact search result dictionary
- (void)printContactSearchResultDictionary;

@end




@implementation AddressBookManager

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

- (NSMutableArray *)allContactsInfoArray{
    // remove each contact extension dictionary
    for (ContactBean *_contact in _mAllContactsInfoArray) {
        [_contact.extensionDic removeAllObjects];
    }
    
    return _mAllContactsInfoArray;
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
    [self initContactIdGroupsDictionary];
    _mAllContactsInfoArray = [self getAllContactsInfoFromAB];
}

- (NSArray *)getContactByPhoneNumber:(NSString *)pPhoneNumber{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // check contact search result dictionary and all contacts info array
    _mContactSearchResultDic = _mContactSearchResultDic ? _mContactSearchResultDic : [[NSMutableDictionary alloc] init];
    _mAllContactsInfoArray = _mAllContactsInfoArray ? _mAllContactsInfoArray : [self getAllContactsInfoFromAB];
    
    // check search contact phone number
    if ([[_mContactSearchResultDic allKeys] containsObject:pPhoneNumber]) {
        // existed in search result dictionary
        _ret = [_mContactSearchResultDic objectForKey:pPhoneNumber];
    }
    else {
        // define contact search scope
        NSArray *_contactSearchScope = _mAllContactsInfoArray;
        
        // check search contact phone number sub phone number
        if (pPhoneNumber.length >= 2 && [[_mContactSearchResultDic allKeys] containsObject:[pPhoneNumber substringToIndex:pPhoneNumber.length - 2]]) {
            _contactSearchScope = [_mContactSearchResultDic objectForKey:[pPhoneNumber substringToIndex:pPhoneNumber.length - 2]];
        }
        
        // search each contact in contact search scope
        for (ContactBean *_contact in _contactSearchScope) {
            // search contact each phone number
            for (NSString *_phoneNumber in _contact.phoneNumbers) {
                // check phone number is sub matched
                if ([_phoneNumber containsSubString:pPhoneNumber]) {
                    // add contact to result
                    [_ret addObject:_contact];
                    break;
                }
            }
        }
        
        // add to contact search result dictionary
        [_mContactSearchResultDic setObject:_ret forKey:pPhoneNumber];
    }
    
    return _ret;
}

- (NSArray *)getContactByName:(NSString *)pName{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // convert search contact name to lowercase string
    pName = [pName lowercaseString];
    
    // check contact search result dictionary and all contacts info array
    _mContactSearchResultDic = _mContactSearchResultDic ? _mContactSearchResultDic : [[NSMutableDictionary alloc] init];
    _mAllContactsInfoArray = _mAllContactsInfoArray ? _mAllContactsInfoArray : [self getAllContactsInfoFromAB];
    
    // check search contact name
    if ([[_mContactSearchResultDic allKeys] containsObject:pName]) {
        // existed in search result dictionary
        _ret = [_mContactSearchResultDic objectForKey:pName];
    }
    else {
        // define contact search scope
        NSArray *_contactSearchScope = _mAllContactsInfoArray;
        
        // check search contact name sub phone name
        if (pName.length >= 2 && [[_mContactSearchResultDic allKeys] containsObject:[pName substringToIndex:pName.length - 2]]) {
            _contactSearchScope = [_mContactSearchResultDic objectForKey:[pName substringToIndex:pName.length - 2]];
        }
        
        // split search contact name
        NSArray *_searchContactNameSplitArray = nil;
        if (_contactSearchScope && [_contactSearchScope count] > 0) {
            _searchContactNameSplitArray = [pName splitToFirstAndOthers];
        }
        
        // search each contact in contact search scope
        for (ContactBean *_contact in _contactSearchScope) {
            // traversal all split name array
            for (NSString *_splitName in _searchContactNameSplitArray) {
                // split name unmatch flag
                BOOL unmatch = NO;
                
                // get split name array
                NSArray *_splitNameArray = [_splitName toArrayWithSeparator:SPLIT_SEPARATOR];
                
                // compare split name array count with contact name phonetic array count
                if ([_splitNameArray count] > [_contact.namePhonetics count]) {
                    continue;
                }
                
                // slide split name array on contact name phonetic array
                for (NSInteger _index = 0; _index < [_contact.namePhonetics count] - [_splitNameArray count] + 1; _index++) {
                    // split name array match flag in particular contact name phonetic array
                    BOOL _matched = NO;
                    
                    // match each split name 
                    for (NSInteger __index = 0; __index < [_splitNameArray count]; __index++) {
                        // one split name unmatch flag
                        BOOL __unmatched = NO;
                        
                        // traversal multi phonetic
                        for (NSInteger ___index = 0; ___index < [[_contact.namePhonetics objectAtIndex:_index + __index] count]; ___index++) {
                            // matched, contact phonetic has prefix with split name
                            if ([[[_contact.namePhonetics objectAtIndex:_index + __index] objectAtIndex:___index] hasPrefix:[_splitNameArray objectAtIndex:__index]]) {
                                break;
                            }
                            else if (___index == [[_contact.namePhonetics objectAtIndex:_index + __index] count] - 1) {
                                __unmatched = YES;
                            }
                        }
                        
                        // one split name unmatch, break, slide split name array
                        if (__unmatched) {
                            break;
                        }
                        
                        // all split name matched, break
                        if (!__unmatched && __index == [_splitNameArray count] - 1) {
                            _matched = YES;
                            break;
                        }
                    }
                    
                    // one particular split name array metched, break
                    if (_matched) {
                        break;
                    }
                    
                    // all split name array unmatch, break, search next contact
                    if (!_matched && _index == [_contact.namePhonetics count] - [_splitNameArray count]) {
                        unmatch = YES;
                        break;
                    }
                }
                
                // one contact match, add in search result array
                if (!unmatch) {
                    [_ret addObject:_contact];
                    break;
                }
            }
        }
        
        // add to contact search result dictionary
        [_mContactSearchResultDic setObject:_ret forKey:pName];
    }
    
    return _ret;
}

- (void)getContactEnd{
    // check contact search result dictionary
    if (_mContactSearchResultDic) {
        [_mContactSearchResultDic removeAllObjects];
    }
}

- (NSArray *)contactsDisplayNameArrayWithPhoneNumber:(NSString *)pPhoneNumber{
    // get contact information array by particular phone number
    NSArray *_contactInfoArray = [self getContactInfoByPhoneNumber:pPhoneNumber];
    
    // define return result
    NSMutableArray *_ret = [[NSMutableArray alloc] initWithCapacity:[_contactInfoArray count]];
    
    // check contact info array
    if (0 == [_contactInfoArray count]) {
        // set default return result
        [_ret addObject:pPhoneNumber];
    }
    else {
        // set each contact display name
        for (ContactBean *_contact in _contactInfoArray) {
            [_ret addObject:_contact.displayName];
        }
    }
    
    return _ret;
}

- (ContactBean *)getContactNamePhoneNumsInfoByRecord:(ABRecordRef)pRecord{
    ContactBean *_contact = [[ContactBean alloc] init];
    
    // set contact id
    _contact.id = ABRecordGetRecordID(pRecord);
    
    // name info
    // get person first name, middle name and last name
    NSString *_firstName = (__bridge_transfer NSString *)ABRecordCopyValue(pRecord, kABPersonFirstNameProperty);
    NSString *_middleName = (__bridge_transfer NSString *)ABRecordCopyValue(pRecord, kABPersonMiddleNameProperty);
    NSString *_lastName = (__bridge_transfer NSString *)ABRecordCopyValue(pRecord, kABPersonLastNameProperty);
    
    // check first, middle and last name
    _firstName = (!_firstName) ? @"" : _firstName;
    _middleName = (!_middleName) ? @"" : _middleName;
    _lastName = (!_lastName) ? @"" : _lastName;
    
    // donn't need to use MiddleName usually
    // check system current setting language
    switch ([CommonUtils systemCurrentSettingLanguage]) {
        case zh_Hans:
        case zh_Hant:
            {
                // set display name
                _contact.displayName = [[NSString stringWithFormat:@"%@ %@", _lastName, _firstName] isNil] ? (zh_Hans == [CommonUtils systemCurrentSettingLanguage]) ? @"无名字" : @"無名字" : [NSString stringWithFormat:@"%@ %@", _lastName, _firstName];
                
                // set full name array
                NSMutableArray *_tmpNameArray = [[NSMutableArray alloc] init];
                [_tmpNameArray addObjectsFromArray:[_lastName toArraySeparatedByCharacter]];
                [_tmpNameArray addObjectsFromArray:[_firstName toArraySeparatedByCharacter]];
                _contact.fullNames = _tmpNameArray;
                
                // set name phonetics
                NSMutableArray *_tmpNamePhoneticArray = [[NSMutableArray alloc] init];
                for (NSString *_name in _contact.fullNames) {
                    // get each name unicode
                    unichar _unicode = [_name characterAtIndex:0];
                    // check name unicode
                    if (_unicode >= 19968 && _unicode <= 40869) {
                        // chinese character
                        NSString *_nameUnicodeString = [NSString stringWithFormat:@"%0X", _unicode];
                        [_tmpNamePhoneticArray addObject:[NSLocalizedStringFromPinyin4jBundle(_nameUnicodeString, nil) toArrayWithSeparator:@","]];
                    }
                    else {
                        // others, character
                        [_tmpNamePhoneticArray addObject:[NSArray arrayWithObject:_name]];
                    }
                }
                _contact.namePhonetics = _tmpNamePhoneticArray;
            }
            break;
            
        case en:
        default:
            {
                // set display name
                _contact.displayName = [[NSString stringWithFormat:@"%@ %@", _firstName, _lastName] isNil] ? @"No Name" : [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
                
                // set full name array
                _contact.fullNames = [NSArray arrayWithObjects:_firstName, _lastName, nil];
                
                // set name phonetics
                _contact.namePhonetics = [NSArray arrayWithObjects:[_firstName lowercaseString], [_lastName lowercaseString], nil];
            }
            break;
    }
    
    // phone numbers info
    // get contact's phone numbers array in addressBook
    ABMultiValueRef _contactPhoneNumberArrayInAB = (ABMultiValueRef)ABRecordCopyValue(pRecord, kABPersonPhoneProperty);
    
    // check contact's phone numbers array in addressBook
    if(_contactPhoneNumberArrayInAB){
        NSMutableArray *_contactPNArr = [[NSMutableArray alloc] init];
        
        // process temp phone number array
        for(int _index = 0; _index < ABMultiValueGetCount(_contactPhoneNumberArrayInAB); _index++){
            NSString *_phoneNumber = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(_contactPhoneNumberArrayInAB, _index); 
            
            // add each phone number to contact phone number array
            [_contactPNArr addObject:[_phoneNumber stringByTrimmingCharactersInString:@"()- "]];
        }
        
        // set contact phone number array
        _contact.phoneNumbers = _contactPNArr;
    }
    
    CFRelease(_contactPhoneNumberArrayInAB);
    
    return _contact;
}

- (NSArray *)getContactInfoByPhoneNumber:(NSString *)pPhoneNumber{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // check all contacts info array
    _mAllContactsInfoArray = _mAllContactsInfoArray ? _mAllContactsInfoArray : [self getAllContactsInfoFromAB];
    
    // search each contact in all contacts info array
    for (ContactBean *_contact in _mAllContactsInfoArray) {
        // search contact each phone number
        for (NSString *_phoneNumber in _contact.phoneNumbers) {
            // check phone number is matched
            if ([_phoneNumber isEqualToString:pPhoneNumber]) {
                // add contact to result
                [_ret addObject:_contact];
                break;
            }
        }
    }
    
    return _ret;
}

- (void)initContactIdGroupsDictionary{
    // check contact id - groups dictionary
    if (!_mContactIdGroupsDic) {
        _mContactIdGroupsDic = [[NSMutableDictionary alloc] init];
    }
    else {
        // return immediately
        return;
    }
    
    // fetch the address book, addressBook manager object 
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    // get all group array
    CFArrayRef _groups = ABAddressBookCopyArrayOfAllGroups(addressBook);
    
    // process all group array
    for(int _index = 0; _index < CFArrayGetCount(_groups); _index++){
        // get group object
        ABRecordRef _group = CFArrayGetValueAtIndex(_groups, _index);
        
        // get group name, part of contact id - groups dictionary, group array value
        NSString *_groupName = (__bridge NSString*)ABRecordCopyValue(_group, kABGroupNameProperty);
        
        // get all group members
        CFArrayRef _groupMembers = ABGroupCopyArrayOfAllMembers(_group);
        
        // process the group members array 
        for (int __index = 0; __index < CFArrayGetCount(_groupMembers); __index++) {
            // get group member id
            ABRecordID _memberID = ABRecordGetRecordID(CFArrayGetValueAtIndex(_groupMembers, __index));
            
            // judge group member id
            if ([[_mContactIdGroupsDic allKeys] containsObject:[NSNumber numberWithInt:_memberID]]) {
                // get existed value
                NSMutableArray *_value = [NSMutableArray arrayWithArray:[_mContactIdGroupsDic objectForKey:[NSNumber numberWithInt:_memberID]]];
                
                // append the group name
                [_value addObject:_groupName];
                // set dictionary
                [_mContactIdGroupsDic setObject:_value forKey:[NSNumber numberWithInt:_memberID]];
            }
            else{
                // set dictionary
                [_mContactIdGroupsDic setObject:[NSArray arrayWithObject:_groupName] forKey:[NSNumber numberWithInt:_memberID]];
            }
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
        // group array
        if (!_mContactIdGroupsDic) {
            [self initContactIdGroupsDictionary];
        }
        NSArray* _groupArray = [_mContactIdGroupsDic objectForKey:[NSNumber numberWithInt:_recordID]];
        
        // get contact name and phone number info
        ContactBean *_contactBean = [self getContactNamePhoneNumsInfoByRecord:_person];
        
        // photo
        NSData* _photo = (__bridge NSData*)ABPersonCopyImageData(_person);
        
        // perfect contact
        _contactBean.groups = _groupArray;
        _contactBean.photo = _photo;
        
        // add contactBean in all contacts array
        [_ret addObject:_contactBean];
    }
    
    // release
    CFRelease(addressBook);
    
    return _ret;
}

- (void)printContactSearchResultDictionary{
    NSLog(@"Important Info: %@, contact search result dictionary = %@", NSStringFromClass(self.class), _mContactSearchResultDic);
}

@end
