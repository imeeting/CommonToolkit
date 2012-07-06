//
//  UIViewGestureRecognizerDelegate.h
//  CommonToolkit
//
//  Created by  on 12-7-3.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

// long press finger mode
typedef enum {
    single = 1 << 0,
    doubleFingers = 1 << 1,
    threeFingers = 1 << 2,
    fourFingers = 1 << 3,
    hand = 1 << 4
} LongPressFingerMode;


// tap finger mode
typedef LongPressFingerMode TapFingerMode;


// tap count mode
typedef enum {
    once = 1 << 0,
    twice = 1 << 1,
    triple = 1 << 2
} TapCountMode;


@protocol UIViewGestureRecognizerDelegate <NSObject>

@optional

// set long press finger mode in view
- (LongPressFingerMode)longPressFingerModeInView:(UIView *)pView;

// long press at view point and finger mode
- (void)view:(UIView *)pView longPressAtPoint:(CGPoint)pPoint andFingerMode:(LongPressFingerMode)pFingerMode;

// set swipe direction in view
- (UISwipeGestureRecognizerDirection)swipeDirectionInView:(UIView *)pView;

// swipe at view point and direction
- (void)view:(UIView *)pView swipeAtPoint:(CGPoint)pPoint andDirection:(UISwipeGestureRecognizerDirection)pDirection;

// set tap finger mode in view
- (TapFingerMode)tapFingerModeInView:(UIView *)pView;

// set tap count mode in view
- (TapCountMode)tapCountModeInView:(UIView *)pView;

// tap at view point, finger mode and count mode
- (void)view:(UIView *)pView tapAtPoint:(CGPoint)pPoint andFingerMode:(TapFingerMode)pFingerMode andCountMode:(TapCountMode)pCountMode;

@end
