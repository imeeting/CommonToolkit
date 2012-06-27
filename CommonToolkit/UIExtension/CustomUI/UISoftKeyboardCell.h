//
//  UISoftKeyboardCell.h
//  CommonToolkit
//
//  Created by  on 12-6-25.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UISoftKeyboardCell : UIView {
    // front present view
    UIView *_mFrontView;
    
    // normal background color
    UIColor *_mNormalBackgroundColor;
    // normal background image
    UIImage *_mNormalBackgroundImg;
    
    // pressed background color
    UIColor *_mPressedBackgroundColor;
    // pressed background image
    UIImage *_mPressedBackgroundImg;
}

@property (nonatomic, retain) UIView *frontView;

@property (nonatomic, retain) UIColor *pressedBackgroundColor;
@property (nonatomic, retain) UIImage *pressedBackgroundImg;

@end