//
//  UIViewExtensionBean.h
//  CommonToolkit
//
//  Created by Ares on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIViewGestureRecognizerDelegate.h"

// UIView extension type
typedef enum {
    titleExt,
    titleViewExt,
    leftBarButtonItemExt,
    rightBarButtonItemExt,
    backgroundImgExt,
    tabBarItemExt,
    viewControllerRefExt,
    viewGestureRecognizerDelegateExt,
    extensionExt
} UIViewExtensionType;


@interface UIViewExtensionBean : NSObject

// UI extension
// UIView title
@property (nonatomic, retain) NSString *title;
// title view
@property (nonatomic, retain) UIView *titleView;
// UIView navigation bar left button item
@property (nonatomic, retain) UIBarButtonItem *leftBarButtonItem;
// UIView navigation bar right button item
@property (nonatomic, retain) UIBarButtonItem *rightBarButtonItem;
// UIView background image
@property (nonatomic, retain) UIImage *backgroundImg;
// UIView tab bar item
@property (nonatomic, retain) UITabBarItem *tabBarItem;

// view controller reference
@property (nonatomic, retain) UIViewController *viewControllerRef;

// view gesture recognizer delegate
@property (nonatomic, retain) id<UIViewGestureRecognizerDelegate> viewGestureRecognizerDelegate;

@end
