//
//  AppRootViewController.m
//  CommonToolkit
//
//  Created by  on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "AppRootViewController.h"

@implementation AppRootViewController

@synthesize interfaceOrientation = _interfaceOrientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPresentViewController:(UIViewController *)pViewController andMode:(AppRootViewControllerMode)pMode{
    id _ret;
    
    // check application root view controller mode
    switch (pMode) {
        case navigationController:
            _ret = [[UINavigationController alloc] initWithRootViewController:pViewController];
            break;
            
        case normalController:
        default:
            _ret = pViewController;
            break;
    }
    
    return _ret;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"shouldAutorotateToInterfaceOrientation - interfaceOrientation = %d", interfaceOrientation);
    return (!_interfaceOrientation) ? UIInterfaceOrientationPortrait : (interfaceOrientation == _interfaceOrientation);
}

- (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    NSLog(@"setInterfaceOrientation - interfaceOrientation = %d", interfaceOrientation);
    
    _interfaceOrientation = interfaceOrientation;
}

@end
