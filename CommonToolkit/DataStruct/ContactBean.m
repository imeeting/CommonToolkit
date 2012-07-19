//
//  ContactBean.m
//  CommonToolkit
//
//  Created by  on 12-6-8.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "ContactBean.h"

#import "ContactBean_Extension.h"

@implementation ContactBean

@synthesize id = _id;
@synthesize groups = _groups;
@synthesize displayName = _displayName;
@synthesize fullNames = _fullNames;
@synthesize namePhonetics = _namePhonetics;
@synthesize phoneNumbers = _phoneNumbers;
@synthesize photo = _photo;

@synthesize extensionDic = _extensionDic;

- (id)init{
    self = [super init];
    if (self) {
        // init ContactBean extension dictionary
        _extensionDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSComparisonResult)compare:(ContactBean *)pContactBean{
    NSComparisonResult _ret = NSOrderedSame;
    
    // check full names
    if ((nil == _fullNames && nil == pContactBean.fullNames)) {
        _ret = NSOrderedSame;
    }
    else if ((nil == _fullNames && nil != pContactBean.fullNames) || (nil != _fullNames && nil == pContactBean.fullNames)) {
        _ret = NSOrderedAscending;
        
        return _ret;
    }
    else {
        if ([_fullNames count] != [pContactBean.fullNames count]) {
            _ret = NSOrderedAscending;
            
            return _ret;
        }
        
        // get fullNames max count
        NSInteger _fullNamesMaxCount = [_fullNames count] > [pContactBean.fullNames count] ? [pContactBean.fullNames count] : [_fullNames count];
        
        for (NSInteger _index = 0; _index < _fullNamesMaxCount; _index++) {
            if (![[_fullNames objectAtIndex:_index] isEqualToString:[pContactBean.fullNames objectAtIndex:_index]]) {
                _ret = NSOrderedAscending;
                
                return _ret;
            }
        }
    }
    
    // check photo
    if ((nil != _photo && nil != pContactBean.photo && [_photo isEqualToData:pContactBean.photo]) || (nil == _photo && nil == pContactBean.photo)) {
        _ret = NSOrderedSame;
    }
    else if ((nil == _photo && nil != pContactBean.photo) || (nil != _photo && nil == pContactBean.photo)) {
        _ret = NSOrderedAscending;
        
        return _ret;
    }
    
    // check groups
    if ((nil == _groups && nil == pContactBean.groups)) {
        _ret = NSOrderedSame;
    }
    else if ((nil == _groups && nil != pContactBean.groups) || (nil != _groups && nil == pContactBean.groups)) {
        _ret = NSOrderedAscending;
        
        return _ret;
    }
    else {
        if ([_groups count] != [pContactBean.groups count]) {
            _ret = NSOrderedAscending;
            
            return _ret;
        }
        
        // get groups max count
        NSInteger _groupsMaxCount = [_groups count] > [pContactBean.groups count] ? [pContactBean.groups count] : [_groups count];
        
        for (NSInteger _index = 0; _index < _groupsMaxCount; _index++) {
            if (![[_groups objectAtIndex:_index] isEqualToString:[pContactBean.groups objectAtIndex:_index]]) {
                _ret = NSOrderedAscending;
                
                return _ret;
            }
        }
    }
    
    // check phone number array
    if ((nil == _phoneNumbers && nil == pContactBean.phoneNumbers)) {
        _ret = NSOrderedSame;
    }
    else if ((nil == _phoneNumbers && nil != pContactBean.phoneNumbers) || (nil != _phoneNumbers && nil == pContactBean.phoneNumbers)) {
        _ret = NSOrderedAscending;
        
        return _ret;
    }
    else {
        if ([_phoneNumbers count] != [pContactBean.phoneNumbers count]) {
            _ret = NSOrderedAscending;
            
            return _ret;
        }
        
        // get phone numbers max count
        NSInteger _phoneNumbersMaxCount = [_phoneNumbers count] > [pContactBean.phoneNumbers count] ? [pContactBean.phoneNumbers count] : [_phoneNumbers count];
        
        for (NSInteger __index = 0; __index < _phoneNumbersMaxCount; __index++) {
            if (![[_phoneNumbers objectAtIndex:__index] isEqualToString:[pContactBean.phoneNumbers objectAtIndex:__index]]) {
                _ret = NSOrderedAscending;
                
                return  _ret;
            }
        }
    }
    
    return _ret;
}

- (ContactBean *)copyBaseProp:(ContactBean *)pContactBean{
    if (nil != self) {
        // base property copy
        _id = pContactBean.id;
        _groups = pContactBean.groups;
        _displayName = pContactBean.displayName;
        _fullNames = pContactBean.fullNames;
        _namePhonetics = pContactBean.namePhonetics;
        _phoneNumbers = pContactBean.phoneNumbers;
        _photo = pContactBean.photo;
    }
    
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"ContactBean description: id = %d, group array = %@, display name = %@, full name array = %@, name phonetic array = %@, phone number array = %@ an photo = %@, extension dictionary = %@", _id, _groups, _displayName, _fullNames, _namePhonetics, _phoneNumbers, _photo, _extensionDic];
}

@end
