//
//  UIImage+Extension.h
//  CommonToolkit
//
//  Created by Ares on 12-7-3.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

// get gray image
@property (nonatomic, readonly) UIImage *grayImage;

// get compatible image from main bundle with name, 1136 height suffix: -568h
+ (UIImage *)compatibleImageNamed:(NSString *)name;

// get image with system current setting language from main bundle with name, language suffix: -en, -hs or -ht
+ (UIImage *)ImageWithLanguageNamed:(NSString *)name;

// get compatible image with system current setting language from main bundle with name, 1136 height and language suffix: -568h-en, -568h-hs or -568h-ht
+ (UIImage *)compatibleImageWithLanguageNamed:(NSString *)name;

@end
