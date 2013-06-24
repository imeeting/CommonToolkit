//
//  UIBarButtonItem+Extension.m
//  CommonToolkit
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

#import "NSString+Extension.h"

// height
#define CUSTOM_UIBARBUTTONITEM_HEIGHT   30.0

// font size
#define CUSTOM_UIBARBUTTONITEM_FONTSIZE 13.0

// title and image padding
#define TITLEPADDING_LEFT7RIGHT 13.0
#define IMAGEPADDING_LEFT7RIGHT 6.0

@implementation UIBarButtonItem (Extension)

- (id)initWithTitle:(NSString *)title bgImage:(UIImage *)bgImage target:(id)target action:(SEL)action{
    return [self initWithTitle:title bgImage:bgImage highlightedBgImage:nil target:target action:action];
}

- (id)initWithTitle:(NSString *)title bgImage:(UIImage *)bgImage highlightedBgImage:(UIImage *)highlightedBgImage target:(id)target action:(SEL)action{
    id _ret;
    
    // check image
    if (nil == bgImage) {
        // create and init UIBarButtonItem with style
        _ret = [self initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    }
    else {
        // create and init custom button
        UIButton *_customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        _customButton.frame = CGRectMake(0.0, 0.0, nil == title ? 0.0 : ([title stringPixelLengthByFontSize:CUSTOM_UIBARBUTTONITEM_FONTSIZE andIsBold:YES] + 2 * TITLEPADDING_LEFT7RIGHT), CUSTOM_UIBARBUTTONITEM_HEIGHT);
        
        // set its both normal and highlighted background image
        [_customButton setBackgroundImage:bgImage forState:UIControlStateNormal];
        if (nil != highlightedBgImage) {
            [_customButton setBackgroundImage:highlightedBgImage forState:UIControlStateHighlighted];
        }
        
        // set title, title text color and its font
        [_customButton setTitle:title forState:UIControlStateNormal];
        _customButton.titleLabel.textColor = [UIColor whiteColor];
        _customButton.titleLabel.font = [UIFont boldSystemFontOfSize:CUSTOM_UIBARBUTTONITEM_FONTSIZE];
        
        // set action selector and its response target
        [_customButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        // create and init UIBarButtonItem with custom view
        _ret = [self initWithCustomView:_customButton];
    }
    
    return _ret;
}

- (id)initWithImage:(UIImage *)image bgImage:(UIImage *)bgImage target:(id)target action:(SEL)action{
    return [self initWithImage:image bgImage:bgImage highlightedBgImage:nil target:target action:action];
}

- (id)initWithImage:(UIImage *)image bgImage:(UIImage *)bgImage highlightedBgImage:(UIImage *)highlightedBgImage target:(id)target action:(SEL)action{
    id _ret;
    
    // check image
    if (nil == bgImage) {
        // create and init UIBarButtonItem with style
        _ret = [self initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
    }
    else {
        // create and init custom button
        UIButton *_customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // set its frame
        _customButton.frame = CGRectMake(0.0, 0.0, image.size.width + 2 * IMAGEPADDING_LEFT7RIGHT, CUSTOM_UIBARBUTTONITEM_HEIGHT);
        
        // set its both normal and highlighted background image
        [_customButton setBackgroundImage:bgImage forState:UIControlStateNormal];
        if (nil != highlightedBgImage) {
            [_customButton setBackgroundImage:highlightedBgImage forState:UIControlStateHighlighted];
        }
        
        // set its both normal and highlighted image 
        [_customButton setImage:image forState:UIControlStateNormal];
        [_customButton setImage:image forState:UIControlStateHighlighted];
        
        // set action selector and its response target
        [_customButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        // create and init UIBarButtonItem with custom view
        _ret = [self initWithCustomView:_customButton];
    }
    
    return _ret;
}

@end
