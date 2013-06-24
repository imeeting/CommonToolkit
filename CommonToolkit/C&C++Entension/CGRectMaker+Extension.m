//
//  CGRectMaker+Extension.m
//  CommonToolkit
//
//  Created by Ares on 13-6-1.
//  Copyright (c) 2013年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CGRectMaker+Extension.h"

#import "FoundationExtensionManager.h"

#import "NSValue+Extension.h"

CG_EXTERN CGRect CGRectMakeWithFormat(UIView *view, NSValue *xValue, NSValue *yValue, NSValue *widthValue, NSValue *heightValue){
    CGRect rect;
    
    // define origin x, y, size width and height
    CGFloat _originX, _originY, _sizeWidth, _sizeHeight;
    
    // get foundation extension manager
    FoundationExtensionManager *_foundationExtensionManager = [FoundationExtensionManager shareFoundationExtensionManager];
    
    // check x, y, width and height type
    if ([xValue isKindOfClass:[NSNumber class]]) {
        _originX = ((NSNumber *)xValue).floatValue;
    } else {
        // save origin x float value with origin x value unsigned int value
        _originX = xValue.unsignedIntValue;
        
        // save origin x value string value to foundation extension with view's hashcode
        [_foundationExtensionManager setFoundationExtensionBeanExtInfoDicValue:xValue.stringValue withExtInfoDicKey:ORIGIN_X_FEKEY forKey:[NSNumber numberWithUnsignedInteger:view.hash]];
    }
    if ([yValue isKindOfClass:[NSNumber class]]) {
        _originY = ((NSNumber *)yValue).floatValue;
    } else {
        // save origin y float value with origin y value unsigned int value
        _originY = yValue.unsignedIntValue;
        
        // save origin y value string value to foundation extension with origin view's hashcode
        [_foundationExtensionManager setFoundationExtensionBeanExtInfoDicValue:yValue.stringValue withExtInfoDicKey:ORIGIN_Y_FEKEY forKey:[NSNumber numberWithUnsignedInteger:view.hash]];
    }
    if ([widthValue isKindOfClass:[NSNumber class]]) {
        _sizeWidth = ((NSNumber *)widthValue).floatValue;
    } else {
        // save size width float value with size width value unsigned int value
        _sizeWidth = widthValue.unsignedIntValue;
        
        // save size width value string value to foundation extension with size width view's hashcode
        [_foundationExtensionManager setFoundationExtensionBeanExtInfoDicValue:widthValue.stringValue withExtInfoDicKey:SIZE_WIDTH_FEKEY forKey:[NSNumber numberWithUnsignedInteger:view.hash]];
    }
    if ([heightValue isKindOfClass:[NSNumber class]]) {
        _sizeHeight = ((NSNumber *)heightValue).floatValue;
    } else {
        // save size height float value with size height value unsigned int value
        _sizeHeight = heightValue.unsignedIntValue;
        
        // save size height value string value to foundation extension with size height view's hashcode
        [_foundationExtensionManager setFoundationExtensionBeanExtInfoDicValue:heightValue.stringValue withExtInfoDicKey:SIZE_HEIGHT_FEKEY forKey:[NSNumber numberWithUnsignedInteger:view.hash]];
    }
    
    rect.origin.x = _originX; rect.origin.y = _originY;
    rect.size.width = _sizeWidth; rect.size.height = _sizeHeight;
    return rect;
}
