//
//  AddressBookUIUtils.h
//  CommonToolkit
//
//  Created by Ares on 13-6-8.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AddressBookUI/AddressBookUI.h>

// address book ui initialize mode
typedef NS_ENUM(NSInteger, AddressBookUIInitMode){
    ABNewPersonView = 1 << 0,
    ABPeoplePickerView = 1 << 1,
    ABUnknownPersonView = 1 << 2,
    ABPersonView = 1 << 3
};


@interface AddressBookUIUtils : NSObject {
    // address book new person view controller
    ABNewPersonViewController *_mABNewPersonViewController;
    // address book people picker navigation view controller
    ABPeoplePickerNavigationController *_mABPeoplePickerNavigationViewController;
    // address book unknown person view controller
    ABUnknownPersonViewController *_mABUnknownPersonViewController;
    // address book person view controller
    ABPersonViewController *_mABPersonViewController;
}

@property (nonatomic, readonly) ABNewPersonViewController *addressBookNewPersonViewController;
@property (nonatomic, readonly) ABPeoplePickerNavigationController *addressBookPeoplePickerNavigationViewController;
@property (nonatomic, readonly) ABUnknownPersonViewController *addressBookUnknownPersonViewController;
@property (nonatomic, readonly) ABPersonViewController *addressBookPersonViewController;

// share singleton AddressBookUIUtils
+ (AddressBookUIUtils *)shareAddressBookUIUtils;

// init address book ui view controller
- (void)initAddressBookUI:(AddressBookUIInitMode)pAddressBookUIInitMode;

// clear address book new person view controller
- (void)clearABNewPersonViewController;

@end
