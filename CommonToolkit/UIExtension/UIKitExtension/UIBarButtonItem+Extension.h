//
//  UIBarButtonItem+Extension.h
//  CommonToolkit
//
//  Created by Ares on 13-5-28.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

// init with title, background image, action selector and response target
- (id)initWithTitle:(NSString *)title bgImage:(UIImage *)bgImage target:(id)target action:(SEL)action;

// init with title, normal background image, highlighted background image, action selector and response target
- (id)initWithTitle:(NSString *)title bgImage:(UIImage *)bgImage highlightedBgImage:(UIImage *)highlightedBgImage target:(id)target action:(SEL)action;

// init with image, background image, action selector and response target
- (id)initWithImage:(UIImage *)image bgImage:(UIImage *)bgImage target:(id)target action:(SEL)action;

// init with image, normal background image, highlighted background image, action selector and response target
- (id)initWithImage:(UIImage *)image bgImage:(UIImage *)bgImage highlightedBgImage:(UIImage *)highlightedBgImage target:(id)target action:(SEL)action;

@end
