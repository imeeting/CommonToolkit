//
//  UINavigationController+Extension.h
//  CommonToolkit
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extension)

// init with root view controller and bar style
- (id)initWithRootViewController:(UIViewController *)rootViewController andBarStyle:(UIBarStyle)barStyle;

// init with root view controller and bar tint color
- (id)initWithRootViewController:(UIViewController *)rootViewController andBarTintColor:(UIColor *)barTintColor;

// init with root view controller and bar background image
- (id)initWithRootViewController:(UIViewController *)rootViewController andBarBackgroundImage:(UIImage *)barBackgroundImage;

@end
