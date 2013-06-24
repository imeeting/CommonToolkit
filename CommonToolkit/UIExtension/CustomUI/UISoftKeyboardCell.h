//
//  UISoftKeyboardCell.h
//  CommonToolkit
//
//  Created by Ares on 12-6-25.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISoftKeyboardCell : UIView {
    // front present view
    UIView *_mFrontView;
    
    // core data for save cell value
    NSNumber *_mCoreData;
    
    // normal background color
    UIColor *_mNormalBackgroundColor;
    // normal background image
    UIImage *_mNormalBackgroundImg;
    
    // pressed background color
    UIColor *_mPressedBackgroundColor;
    // pressed background image
    UIImage *_mPressedBackgroundImg;
    
    // long press timer
    NSTimer *_mLongPressTimer;
    // long pressed flag
    BOOL _mLongPressed;
}

@property (nonatomic, retain) UIView *frontView;

@property (nonatomic, retain) NSNumber *coreData;

@property (nonatomic, retain) UIColor *pressedBackgroundColor;
@property (nonatomic, retain) UIImage *pressedBackgroundImg;

@end
