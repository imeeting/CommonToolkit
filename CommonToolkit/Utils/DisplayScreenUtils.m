//
//  DisplayScreenUtils.m
//  CommonToolkit
//
//  Created by Ares on 13-5-27.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import "DisplayScreenUtils.h"

@implementation DisplayScreenUtils

+ (CGFloat)statusBarHeight{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

+ (CGFloat)navigationBarHeightWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    CGFloat _ret;
    
    // check interface orientation
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            // landscape is 32 px
            _ret = 32.0;
            break;
        
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        default:
            // portrait is 44 px
            _ret = 44.0;
            break;
    }
    
    return _ret;
}

+ (CGFloat)navigationBarHeight{
    return [self navigationBarHeightWithInterfaceOrientation:UIInterfaceOrientationPortrait];
}

+ (CGFloat)tabBarHeight{
    // tab bar default height
    return 49.0;
}

+ (CGFloat)screenWidth{
    // get display screen
    UIScreen *_screen = [UIScreen mainScreen];
    
    // return display screen width
    return [_screen bounds].size.width * _screen.scale;
}

+ (CGFloat)screenHeight{
    // get display screen
    UIScreen *_screen = [UIScreen mainScreen];
    
    // return display screen width
    return [_screen bounds].size.height * _screen.scale;
}

@end
