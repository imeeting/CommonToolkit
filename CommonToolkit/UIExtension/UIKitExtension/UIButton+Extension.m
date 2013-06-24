//
//  UIButton+Extension.m
//  CommonToolkit
//
//  Created by Ares on 13-5-30.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "UIButton+Extension.h"

@implementation UIButton (Extension)

- (void)setImage:(UIImage *)image{
    // set image for both notmal and highlighted state
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
}

@end
