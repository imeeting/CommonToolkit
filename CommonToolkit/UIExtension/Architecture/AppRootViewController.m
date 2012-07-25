//
//  AppRootViewController.m
//  CommonToolkit
//
//  Created by  on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "AppRootViewController.h"

// normal view controller
@interface NormalViewController : UIViewController

// supported interface orientation
@property (nonatomic, readwrite) UIInterfaceOrientation supportedInterfaceOrientation;

// init with view controller
- (id)initWithViewController:(UIViewController *)pViewController;

@end




// navigation view controller
@interface NavigationViewController : UINavigationController

// supported interface orientation
@property (nonatomic, readwrite) UIInterfaceOrientation supportedInterfaceOrientation;

@end




@implementation AppRootViewController

@synthesize supportedInterfaceOrientation = _supportedInterfaceOrientation;

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
            _ret = [[NavigationViewController alloc] initWithRootViewController:pViewController];
            break;
            
        case normalController:
        default:
            _ret = [[NormalViewController alloc] initWithViewController:pViewController];
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
    // Return YES for supported orientations
	return YES;
}

@end




@implementation NormalViewController

@synthesize supportedInterfaceOrientation = _supportedInterfaceOrientation;

- (id)initWithViewController:(UIViewController *)pViewController{
    return (NormalViewController *)pViewController;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //NSLog(@"NormalViewController - shouldAutorotateToInterfaceOrientation - interfaceOrientation = %d and supportedInterfaceOrientation = %d", interfaceOrientation, _supportedInterfaceOrientation);
    return (0 == _supportedInterfaceOrientation) ? interfaceOrientation == UIInterfaceOrientationPortrait : interfaceOrientation == _supportedInterfaceOrientation;
}

@end




@implementation NavigationViewController

@synthesize supportedInterfaceOrientation = _supportedInterfaceOrientation;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //NSLog(@"NavigationViewController - shouldAutorotateToInterfaceOrientation - interfaceOrientation = %d and supportedInterfaceOrientation = %d", interfaceOrientation, _supportedInterfaceOrientation);
    return (0 == _supportedInterfaceOrientation) ? interfaceOrientation == UIInterfaceOrientationPortrait : interfaceOrientation == _supportedInterfaceOrientation;
}

@end
