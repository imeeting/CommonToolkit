//
//  UIView+UI+ViewController.h
//  CommonToolkit
//
//  Created by Ares on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewGestureRecognizerDelegate.h"

// UIView width or height param
#define FILL_PARENT USHRT_MAX

// UIView width or height param string
#define FILL_PARENT_STRING  "FILL_PARENT"

// UIView UI category
@interface UIView (UI)

// title, use title view (UIView) if you want something different
@property (nonatomic, retain) NSString *title;

// title view
@property (nonatomic, retain) UIView *titleView;

// navigation bar left button item
@property (nonatomic, retain) UIBarButtonItem *leftBarButtonItem;

// navigation bar right button item
@property (nonatomic, retain) UIBarButtonItem *rightBarButtonItem;

// background image
@property (nonatomic, retain) UIImage *backgroundImg;

// tab bar item
@property (nonatomic, retain) UITabBarItem *tabBarItem;

@end




// UIView draw category
@interface UIView (Draw)

// set corner radius
- (void)setCornerRadius:(CGFloat)cornerRadius;

// set border with width and color
- (void)setBorderWithWidth:(CGFloat)borderWidth andColor:(UIColor *)borderColor;

// resize all subviews, call when layoutSubviews be called
- (void)resizesSubviews;

@end





// UIView view controller category
@interface UIView (ViewController)

// view controller reference
@property (nonatomic, retain) UIViewController *viewControllerRef;

// validate view controller reference and check selector
- (BOOL)validateViewControllerRef:(UIViewController*)pViewControllerRef andSelector:(SEL) pSelector;

@end




// UIView gesture recognizer category
@interface UIView (GestureRecognizer) <UIGestureRecognizerDelegate>

// view gesture recognizer delegate
@property (nonatomic, retain) id<UIViewGestureRecognizerDelegate> viewGestureRecognizerDelegate;

@end
