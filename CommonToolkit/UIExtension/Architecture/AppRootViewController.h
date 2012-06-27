//
//  AppRootViewController.h
//  CommonToolkit
//
//  Created by  on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

// application root view controller mode type
typedef enum {
    normalController,
    navigationController
} AppRootViewControllerMode;


@interface AppRootViewController : UIViewController

// UI interface orientation
@property (nonatomic, readwrite) UIInterfaceOrientation interfaceOrientation;

// init with present view controller and applicate root view controller mode
- (id)initWithPresentViewController:(UIViewController *)pViewController andMode:(AppRootViewControllerMode)pMode;

@end
