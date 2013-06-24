//
//  AddressBookUIUtils.m
//  CommonToolkit
//
//  Created by Ares on 13-6-8.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "AddressBookUIUtils.h"

// static singleton instance, address book UI utils object
static AddressBookUIUtils *singletonAddressBookUIUtils;

@implementation AddressBookUIUtils

+ (AddressBookUIUtils *)shareAddressBookUIUtils{
    @synchronized(self){
        if (nil == singletonAddressBookUIUtils) {
            singletonAddressBookUIUtils = [[self alloc] init];
        }
    }
    
    return singletonAddressBookUIUtils;
}

- (void)initAddressBookUI:(AddressBookUIInitMode)pAddressBookUIInitMode{
    // check address book UI init mode and init address book UI if needed
    if (ABNewPersonView == (ABNewPersonView & pAddressBookUIInitMode)) {
        _mABNewPersonViewController = [[ABNewPersonViewController alloc] init];
    }
    if (ABPeoplePickerView == (ABPeoplePickerView & pAddressBookUIInitMode)) {
        _mABPeoplePickerNavigationViewController = [[ABPeoplePickerNavigationController alloc] init];
    }
    if (ABUnknownPersonView == (ABUnknownPersonView & pAddressBookUIInitMode)) {
        _mABUnknownPersonViewController = [[ABUnknownPersonViewController alloc] init];
    }
    if (ABPersonView == (ABPersonView & pAddressBookUIInitMode)) {
        _mABPersonViewController = [[ABPersonViewController alloc] init];
    }
}

- (ABNewPersonViewController *)addressBookNewPersonViewController{
    // check and get address book new person view controller
    if (nil == _mABNewPersonViewController) {
        // init address book new person view controller
        _mABNewPersonViewController = [[ABNewPersonViewController alloc] init];
    }
    
    return _mABNewPersonViewController;
}

- (ABPeoplePickerNavigationController *)addressBookPeoplePickerNavigationViewController{
    // check and get address book people picker navigation view controller
    if (nil == _mABPeoplePickerNavigationViewController) {
        // init address book people picker navigation view controller
        _mABPeoplePickerNavigationViewController = [[ABPeoplePickerNavigationController alloc] init];
    }
    
    return _mABPeoplePickerNavigationViewController;
}

- (ABUnknownPersonViewController *)addressBookUnknownPersonViewController{
    // check and get address book unknown person view controller
    if (nil == _mABUnknownPersonViewController) {
        // init address book unknown person view controller
        _mABUnknownPersonViewController = [[ABUnknownPersonViewController alloc] init];
    }
    
    return _mABUnknownPersonViewController;
}

- (ABPersonViewController *)addressBookPersonViewController{
    // check and get address book person view controller
    if (nil == _mABPersonViewController) {
        // init address book person view controller
        _mABPersonViewController = [[ABPersonViewController alloc] init];
    }
    
    return _mABPersonViewController;
}

- (void)clearABNewPersonViewController{
    // re-init address book new person view controller
    _mABNewPersonViewController = [[ABNewPersonViewController alloc] init];
}

@end
