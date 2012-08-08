//
//  AddressBookManager.m
//  CommonToolkit
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "AddressBookManager.h"

#import "NSString+Extension.h"
#import "NSArray+Extension.h"
#import "NSBundle+Extension.h"
#import "CommonUtils.h"

#import "ContactBean_Extension.h"

#import <objc/message.h>

// matching result contact bean and index array key
#define MATCHING_RESULT_CONTACT @"matchingResultContact"
#define MATCHING_RESULT_INDEXS  @"matchingResultIndexs"
#define PHONE_NUMBER_FILTER_PREFIX           [NSArray arrayWithObjects:@"17909", @"11808", @"12593", @"17951", @"17911", @"086", @"86", nil]


// static singleton AddressBookManager reference
static AddressBookManager *singletonAddressBookManagerRef;

// AddressBookManager extension
@interface AddressBookManager ()

// generate contact with contact's name, phone numbers info by record
- (ContactBean *)generateContactNamePhoneNumsInfoByRecord:(ABRecordRef)pRecord;

// get contact information array by particular phone number
- (NSArray *)getContactInfoByPhoneNumber:(NSString *)pPhoneNumber;

// init all contacts contact id - groups dictionary
- (void)initContactIdGroupsDictionary;

// get all contacts info array from addressBook
- (NSMutableArray *)getAllContactsInfoFromAB;

// print contact search result dictionary
- (void)printContactSearchResultDictionary;

// refresh addressBook and return contact id dirty dictionary
// key: contact id(NSInteger), value: action dictionary(NSDictionary *)
- (NSDictionary *)refreshAddressBook;

// private method: addressBook changed callback function
void addressBookChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void *context);

@end




@implementation AddressBookManager

- (id)init{
    self = [super init];
    if (self) {
        // Initialization code
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

- (ContactBean *)getContactInfoById:(NSInteger)pId{
    ContactBean *_ret = nil;
    
    // check all contacts info array
    _mAllContactsInfoArray = _mAllContactsInfoArray ? _mAllContactsInfoArray : [self getAllContactsInfoFromAB];
    
    for (ContactBean *_contact in _mAllContactsInfoArray) {
        // check contact id
        if (_contact.id == pId) {
            _ret = _contact;
            
            break;
        }
    }
    
    return _ret;
}

- (NSArray *)getContactByPhoneNumber:(NSString *)pPhoneNumber{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // check contact search result dictionary and all contacts info array
    _mContactSearchResultDic = _mContactSearchResultDic ? _mContactSearchResultDic : [[NSMutableDictionary alloc] init];
    _mAllContactsInfoArray = _mAllContactsInfoArray ? _mAllContactsInfoArray : [self getAllContactsInfoFromAB];
    
    // check search contact phone number
    if ([[_mContactSearchResultDic allKeys] containsObject:pPhoneNumber]) {
        // existed in search result dictionary
        for (NSDictionary *_matchingContactDic in [_mContactSearchResultDic objectForKey:pPhoneNumber]) {
            [_ret addObject:[_matchingContactDic objectForKey:MATCHING_RESULT_CONTACT]];
            
            // append contact matching index array
            [((ContactBean *)[_matchingContactDic objectForKey:MATCHING_RESULT_CONTACT]).extensionDic setObject:[_matchingContactDic objectForKey:MATCHING_RESULT_INDEXS] forKey:PHONENUMBER_MATCHING_INDEXS];
        }
    }
    else {
        // define contact search scope
        NSArray *_contactSearchScope = _mAllContactsInfoArray;
        
        // check search contact phone number sub phone number
        if (pPhoneNumber.length >= 2 && [[_mContactSearchResultDic allKeys] containsObject:[pPhoneNumber substringToIndex:pPhoneNumber.length - 2]]) {
            // get sub matched contact array
            NSMutableArray *_subMatchedContactArr = [[NSMutableArray alloc] init];
            
            // reset contact search scope
            for (NSDictionary *_matchingContactDic in [_mContactSearchResultDic objectForKey:[pPhoneNumber substringToIndex:pPhoneNumber.length - 2]]) {
                [_subMatchedContactArr addObject:[_matchingContactDic objectForKey:MATCHING_RESULT_CONTACT]];
            }
            
            _contactSearchScope = _subMatchedContactArr;
        }
        
        // define searched contact array
        NSMutableArray *_searchedContactArray = [[NSMutableArray alloc] init];
        
        // search each contact in contact search scope
        for (ContactBean *_contact in _contactSearchScope) {
            // phone number matching index array's array
            NSMutableArray *_phoneNumberMatchingIndexsArr = [[NSMutableArray alloc] init];
            
            // has phone number matched flag
            BOOL _hasOnePhoneNumberMatched = NO;
            
            // search contact each phone number
            for (NSString *_phoneNumber in _contact.phoneNumbers) {
                // check phone number is sub matched
                if ([_phoneNumber containsSubString:pPhoneNumber]) {
                    _hasOnePhoneNumberMatched = YES;
                    
                    // add phone number matching index array to phone number matching index array's array
                    [_phoneNumberMatchingIndexsArr addObject:[NSArray arrayWithRange:[[_phoneNumber lowercaseString] rangeOfString:[pPhoneNumber lowercaseString]]]];
                }
                else {
                    // add empty matching index array to phone number matching index array's array
                    [_phoneNumberMatchingIndexsArr addObject:[[NSArray alloc] init]];
                }
            }
            
            // has one phone number in contact phone numbers matched
            if (_hasOnePhoneNumberMatched) {
                // add contact to result
                [_ret addObject:_contact];
                
                // append contact matching index array
                [_contact.extensionDic setObject:_phoneNumberMatchingIndexsArr forKey:PHONENUMBER_MATCHING_INDEXS];
                
                // add matching contact to searched contact array
                [_searchedContactArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_contact, MATCHING_RESULT_CONTACT, [_contact.extensionDic objectForKey:PHONENUMBER_MATCHING_INDEXS], MATCHING_RESULT_INDEXS, nil]];
            }
        }
        
        // add to contact search result dictionary
        [_mContactSearchResultDic setObject:_searchedContactArray forKey:pPhoneNumber];
    }
    
    return _ret;
}

- (NSArray *)getContactByName:(NSString *)pName{
    return [self getContactByName:pName andMatchingType:full];
}

- (NSArray *)getContactByName:(NSString *)pName andMatchingType:(ContactMatchingType)pType{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // convert search contact name to lowercase string
    pName = [pName lowercaseString];
    
    // check contact search result dictionary and all contacts info array
    _mContactSearchResultDic = _mContactSearchResultDic ? _mContactSearchResultDic : [[NSMutableDictionary alloc] init];
    _mAllContactsInfoArray = _mAllContactsInfoArray ? _mAllContactsInfoArray : [self getAllContactsInfoFromAB];
    
    // check search contact name
    if ([[_mContactSearchResultDic allKeys] containsObject:pName]) {
        // existed in search result dictionary
        for (NSDictionary *_matchingContactDic in [_mContactSearchResultDic objectForKey:pName]) {
            [_ret addObject:[_matchingContactDic objectForKey:MATCHING_RESULT_CONTACT]];
            
            // append contact matching index array
            [((ContactBean *)[_matchingContactDic objectForKey:MATCHING_RESULT_CONTACT]).extensionDic setObject:[_matchingContactDic objectForKey:MATCHING_RESULT_INDEXS] forKey:NAME_MATCHING_INDEXS];
        }
    }
    else {
        // define contact search scope
        NSArray *_contactSearchScope = _mAllContactsInfoArray;
        
        // check search contact name sub name
        if (pName.length >= 2 && [[_mContactSearchResultDic allKeys] containsObject:[pName substringToIndex:pName.length - 2]]) {
            // get sub matched contact array
            NSMutableArray *_subMatchedContactArr = [[NSMutableArray alloc] init];
            
            // reset contact search scope
            for (NSDictionary *_matchingContactDic in [_mContactSearchResultDic objectForKey:[pName substringToIndex:pName.length - 2]]) {
                [_subMatchedContactArr addObject:[_matchingContactDic objectForKey:MATCHING_RESULT_CONTACT]];
            }
            
            _contactSearchScope = _subMatchedContactArr;
        }
        
        // split search contact name
        NSArray *_searchContactNameSplitArray = nil;
        if (_contactSearchScope && [_contactSearchScope count] > 0) {
            _searchContactNameSplitArray = [pName splitToFirstAndOthers];
        }
        
        // define searched contact array
        NSMutableArray *_searchedContactArray = [[NSMutableArray alloc] init];
        
        // search each contact in contact search scope
        for (ContactBean *_contact in _contactSearchScope) {
            // traversal all split name array
            for (NSString *_splitName in _searchContactNameSplitArray) {
                // split name unmatch flag
                BOOL unmatch = NO;
                
                // matching index array
                NSMutableArray *_nameMatchingIndexArr = [[NSMutableArray alloc] init];
                
                // get split name array
                NSArray *_splitNameArray = [_splitName toArrayWithSeparator:SPLIT_SEPARATOR];
                
                // compare split name array count with contact name phonetic array count
                if ([_splitNameArray count] > [_contact.namePhonetics count]) {
                    continue;
                }
                
                // need all matching
                if (full == pType) {
                    if (![_splitNameArray isMatchedNamePhonetics:_contact.namePhonetics]) {
                        unmatch = YES;
                    }
                    else {
                        // last split name element matching index
                        NSInteger _lastElementMatchingIndex = 0;
                        
                        // set name matching index array
                        for (NSInteger _index = 0; _index < [_splitNameArray count]; _index++) {
                            for (NSInteger __index = _lastElementMatchingIndex; __index < [_contact.namePhonetics count]; __index++) {
                                // split name element matching flag
                                BOOL _elementMatching = NO;
                                
                                for (NSInteger ___index = 0; ___index < [[_contact.namePhonetics objectAtIndex:__index] count]; ___index++) {
                                    // check split name array each element matching index
                                    if ([[[_contact.namePhonetics objectAtIndex:__index] objectAtIndex:___index] hasPrefix:[_splitNameArray objectAtIndex:_index]]) {
                                        // set split name element matching flag
                                        _elementMatching = YES;
                                        
                                        // save split name element matching index
                                        _lastElementMatchingIndex = __index + 1;
                                        
                                        // set name matching index array
                                        [_nameMatchingIndexArr addObject:[NSNumber numberWithInteger:__index]];
                                        
                                        break;
                                    }
                                }
                                
                                // find element matching index
                                if (_elementMatching) {
                                    break;
                                }
                            }
                        }
                    }
                }
                else {
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
                            // set name matching index array
                            _nameMatchingIndexArr = [NSArray arrayWithRange:NSMakeRange(_index, [_splitNameArray count])];
                            
                            break;
                        }
                        
                        // all split name array unmatch, break, search next contact
                        if (!_matched && _index == [_contact.namePhonetics count] - [_splitNameArray count]) {
                            unmatch = YES;
                            break;
                        }
                    }
                }
                
                // one contact match, add in search result array
                if (!unmatch) {
                    // add contact to result
                    [_ret addObject:_contact];
                    
                    // append contact matching index array
                    [_contact.extensionDic setObject:_nameMatchingIndexArr forKey:NAME_MATCHING_INDEXS];
                    
                    // add matching contact to searched contact array
                    [_searchedContactArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_contact, MATCHING_RESULT_CONTACT, [_contact.extensionDic objectForKey:NAME_MATCHING_INDEXS], MATCHING_RESULT_INDEXS, nil]];
                    
                    break;
                }
            }
        }
        
        // add to contact search result dictionary
        [_mContactSearchResultDic setObject:_searchedContactArray forKey:pName];
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

- (void)addABChangedObserver:(NSObject *)pObserver{
    // validate addressBookChanged implemetation
    if ([CommonUtils validateProcessor:pObserver andSelector:@selector(addressBookChanged:info:context:)]) {
        // register external change callback function
        ABAddressBookRegisterExternalChangeCallback(ABAddressBookCreate(), addressBookChanged, (__bridge void *)pObserver);
    }
    else if (nil != pObserver) {
        NSLog(@"Warning: %@ can't implement addressBook changed callback function %@", NSStringFromClass(pObserver.class), NSStringFromSelector(@selector(addressBookChanged:info:context:)));
        
        // register external change callback function
        ABAddressBookRegisterExternalChangeCallback(ABAddressBookCreate(), addressBookChanged, NULL);
    }
}

- (void)removeABChangedObserver:(NSObject *)pObserver{
    // unregister external change callback function
    ABAddressBookUnregisterExternalChangeCallback(ABAddressBookCreate(), addressBookChanged, (__bridge void *)pObserver);
}

- (ContactBean *)generateContactNamePhoneNumsInfoByRecord:(ABRecordRef)pRecord{
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
            _phoneNumber = [_phoneNumber stringByTrimmingCharactersInString:@"()- "];
            // remove the specified prefix
            for (NSString *prefix in PHONE_NUMBER_FILTER_PREFIX) {
                NSRange range = [_phoneNumber rangeOfString:prefix];
                if (range.location == 0) {
                    if (range.length < _phoneNumber.length) {
                        _phoneNumber = [_phoneNumber substringFromIndex:range.length];
                    }
                }
            }
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
    
    // fetch the addressBook 
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
    
    // fetch the addressBook 
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
        
        // generate contact name and phone number info
        ContactBean *_contactBean = [self generateContactNamePhoneNumsInfoByRecord:_person];
        
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

- (ContactBean *)defaultContactByPhoneNumber:(NSString *)pPhoneNumber {
    NSArray *contacts = [self getContactByPhoneNumber:pPhoneNumber];
    ContactBean *defaultContact = nil;
    if (contacts.count > 0) {
        defaultContact = [contacts objectAtIndex:0];
    }
    return defaultContact;
}

- (NSDictionary *)refreshAddressBook{
    NSMutableDictionary *_ret = [[NSMutableDictionary alloc] init];
    
    // re-init contactsId group dictionary
    _mContactIdGroupsDic = nil;
    [self initContactIdGroupsDictionary];
    
    @autoreleasepool {
        // get new contacts info array from addressBook
        NSArray *_newContactsInfoArray = [self getAllContactsInfoFromAB];
        
        // remove contact from all contacts info array if not existed in new contacts info array
        // define contact existed in new all contacts info array flag
        BOOL _existedInNew;
        for (NSInteger _index = 0; _index < [_mAllContactsInfoArray count]; _index++) {
            // get contact in all contacts info array
            ContactBean *_contact = [_mAllContactsInfoArray objectAtIndex:_index];
            
            // set/re-set existed flag
            _existedInNew = NO;
            
            for (ContactBean *__contact in _newContactsInfoArray) {
                // check new contacts info array existed the contact which in all contacts info array
                if (_contact.id == __contact.id) {
                    _existedInNew = YES;
                    
                    break;
                }
            }
            
            // if existed, check next else remove the contact in all contacts info array
            if (!_existedInNew) {
                // delete
                [_mAllContactsInfoArray removeObjectAtIndex:_index];
                
                // add to dirty contact id dictionary
                [_ret setObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:contactDelete] forKey:CONTACT_ACTION] forKey:[NSNumber numberWithInteger:_contact.id]];
            }
        }
        
        // compare and merge contact
        for (ContactBean *_contact in _newContactsInfoArray) {
            // get contact in all contacts info array
            ContactBean *_oldContact = [self getContactInfoById:_contact.id];
            
            if (nil == _oldContact || NSOrderedSame != [_contact compare:_oldContact]) {
                // reset all contacts info array, if existed, replace else add new contact
                if (_oldContact) {
                    // replace
                    _oldContact = [_oldContact copyBaseProp:_contact];
                    
                    // create and init contact action dictionary
                    NSMutableDictionary *_contactActionDic = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInteger:contactModify] forKey:CONTACT_ACTION];
                    // else action property can't implemetation???
                    
                    // add to dirty contact id dictionary
                    [_ret setObject:_contactActionDic forKey:[NSNumber numberWithInteger:_contact.id]];
                }
                else {
                    // add new
                    [_mAllContactsInfoArray addObject:_contact];
                    
                    // add to dirty contact id dictionary
                    [_ret setObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:contactAdd] forKey:CONTACT_ACTION] forKey:[NSNumber numberWithInteger:_contact.id]];
                }
            }
        }
    }
    
    return _ret;
}

void addressBookChanged(ABAddressBookRef addressBook, CFDictionaryRef info, void *context){
    // refresh addressBook and get dirty contact id dictionary
    info = (__bridge CFDictionaryRef)[[AddressBookManager shareAddressBookManager] refreshAddressBook];
    
    // clear contact search result dictionary
    [[AddressBookManager shareAddressBookManager] getContactEnd];
    
    // send message to addressBook changed observer
    if (NULL != context) {
        objc_msgSend((__bridge id)context, @selector(addressBookChanged:info:context:), addressBook, info, context);
    }
}

@end

