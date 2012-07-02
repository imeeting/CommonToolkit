//
//  UIImage+Extension.m
//  CommonToolkit
//
//  Created by star king on 12-6-25.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (UIImage *)grayImage {
    int width = self.size.width; 
    int height = self.size.height; 
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray(); 
    CGContextRef context = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, kCGImageAlphaNone); 
    CGColorSpaceRelease(colorSpace); 
    
    if (context == NULL) { 
        return nil; 
    } 
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), self.CGImage); 
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)]; 
    CGContextRelease(context); 
    
    return grayImage; 
}
@end
