//
//  AppRootViewController.h
//  CommonToolkit
//
//  Created by Ares on 12-6-7.
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

// init with navigation view controller and navigation bar style, return NavigationViewController
- (id)initWithNavigationViewController:(UIViewController *)pViewController andBarStyle:(UIBarStyle)barStyle;

// init with navigation view controller and navigation bar tint color, return NavigationViewController
- (id)initWithNavigationViewController:(UIViewController *)pViewController andBarTintColor:(UIColor *)barTintColor;

// init with navigation view controller and navigation bar background image, return NavigationViewController
- (id)initWithNavigationViewController:(UIViewController *)pViewController andBarBackgroundImage:(UIImage *)barBackgroundImage;

@end
