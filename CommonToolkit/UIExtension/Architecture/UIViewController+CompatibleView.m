//
//  UIViewController+CompatibleView.m
//  CommonToolkit
//
//  Created by Ares on 12-6-6.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIViewController+CompatibleView.h"

#import "UIView+UI+ViewController.h"

@implementation UIViewController (CompatibleView)

- (UIViewController *)initWithCompatibleView:(UIView *)pView{
    self = [super init];
    if (self) {
        // save self view controller reference
        pView.viewControllerRef = self;
        
        // set self(view controller) view
        self.view = pView;
    }
    return self;
}

@end
