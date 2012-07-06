//
//  UIView+UI+ViewController.h
//  CommonToolkit
//
//  Created by  on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewGestureRecognizerDelegate.h"

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
