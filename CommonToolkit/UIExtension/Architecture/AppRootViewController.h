//
//  AppRootViewController.h
//  CommonToolkit
//
//  Created by  on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NavigationViewController;
@class NormalViewController;

// application root view controller mode type
typedef enum {
    normalController,
    navigationController
} AppRootViewControllerMode;


@interface AppRootViewController : UIViewController

// supported interface orientation
@property (nonatomic, readwrite) UIInterfaceOrientation supportedInterfaceOrientation;

// init with present view controller and applicate root view controller mode, return NavigationViewController or NormalViewController
- (id)initWithPresentViewController:(UIViewController *)pViewController andMode:(AppRootViewControllerMode)pMode;

@end
