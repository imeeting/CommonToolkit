//
//  DisplayScreenUtils.h
//  CommonToolkit
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayScreenUtils : NSObject

// UIApplication status bar height
+ (CGFloat)statusBarHeight;

// UIApplication navigation bar with interface orientation
+ (CGFloat)navigationBarHeightWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

// UIApplication navigation bar default height
+ (CGFloat)navigationBarHeight;

// UIApplication tab bar default height
+ (CGFloat)tabBarHeight;

// UIScreen width
+ (CGFloat)screenWidth;

// UIScreen height
+ (CGFloat)screenHeight;

@end
