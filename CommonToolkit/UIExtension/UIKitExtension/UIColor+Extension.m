//
//  UIColor+Extension.m
//  CommonToolkit
//
//  Created by  on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIColor+Extension.h"

#define RGBCHANNELMAXFLOATVALUE 255.0

@implementation UIColor (RGBInteger)

+ (UIColor *)colorWithIntegerRed:(NSInteger)intRed integerGreen:(NSInteger)intGreen integerBlue:(NSInteger)intBlue alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:intRed / RGBCHANNELMAXFLOATVALUE green:intGreen / RGBCHANNELMAXFLOATVALUE blue:intBlue / RGBCHANNELMAXFLOATVALUE alpha:alpha];
}

@end
