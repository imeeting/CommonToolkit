//
//  UIColor+Extension.h
//  CommonToolkit
//
//  Created by Ares on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGBInteger)

// init with integer RGB value and float alpha
+ (UIColor *)colorWithIntegerRed:(NSInteger)intRed integerGreen:(NSInteger)intGreen integerBlue:(NSInteger)intBlue alpha:(CGFloat)alpha;

@end
