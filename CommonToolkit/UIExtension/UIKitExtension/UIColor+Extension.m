//
//  UIColor+Extension.m
//  CommonToolkit
//
//  Created by Ares on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIColor+Extension.h"

#define RGBCHANNEL_MAXVALUE 255.0

@implementation UIColor (RGBInteger)

+ (UIColor *)colorWithIntegerRed:(NSInteger)intRed integerGreen:(NSInteger)intGreen integerBlue:(NSInteger)intBlue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:intRed / RGBCHANNEL_MAXVALUE green:intGreen / RGBCHANNEL_MAXVALUE blue:intBlue / RGBCHANNEL_MAXVALUE alpha:alpha];
}

@end
