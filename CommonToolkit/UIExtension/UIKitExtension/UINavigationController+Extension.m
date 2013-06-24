//
//  UINavigationController+Extension.m
//  CommonToolkit
//
//  Created by Ares on 13-5-24.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "UINavigationController+Extension.h"

// UINavigationBar background image view tag
#define UINAVIGATIONBAR_BACKGROUNDIMGVIEW_TAG   333

@interface UINavigationBar (BackgroundImage)

// set background image
- (void)setBackgroundImage:(UIImage *)backgroundImage;

@end




@implementation UINavigationController (Extension)

- (id)initWithRootViewController:(UIViewController *)rootViewController andBarStyle:(UIBarStyle)barStyle{
    self = [self initWithRootViewController:rootViewController];
    if (self) {
        // set navigation bar style
        self.navigationBar.barStyle = barStyle;
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController andBarTintColor:(UIColor *)barTintColor{
    self = [self initWithRootViewController:rootViewController];
    if (self) {
        // set navigation bar tint color
        self.navigationBar.tintColor = barTintColor;
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController andBarBackgroundImage:(UIImage *)barBackgroundImage{
    self = [self initWithRootViewController:rootViewController];
    if (self) {
        // set navigation bar background image
        [self.navigationBar setBackgroundImage:barBackgroundImage];
    }
    return self;
}

@end




@implementation UINavigationBar (BackgroundImage)

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    // check ios version
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        // ios 5 later
        [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    else {
        // get background image view
        UIImageView *_backgroundImgView = (UIImageView *)[self viewWithTag:UINAVIGATIONBAR_BACKGROUNDIMGVIEW_TAG];
        
        // check background image
        if (nil == backgroundImage) {
            // check background image view and remove from UINavigationBar
            if (nil != _backgroundImgView) {
                [_backgroundImgView removeFromSuperview];
            }
        }
        else {
            // check background image view
            if (nil != _backgroundImgView) {
                // set image
                _backgroundImgView.image = backgroundImage;
            }
            else {
                // create and init background image view
                _backgroundImgView = [[UIImageView alloc] initWithImage:backgroundImage];
                
                // set background image view tag and auto resizing mask
                [_backgroundImgView setTag:UINAVIGATIONBAR_BACKGROUNDIMGVIEW_TAG];
                _backgroundImgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                
                // add background image view and send to back
                [self addSubview:_backgroundImgView];
                [self sendSubviewToBack:_backgroundImgView];
            }
        }
    }
}

@end
