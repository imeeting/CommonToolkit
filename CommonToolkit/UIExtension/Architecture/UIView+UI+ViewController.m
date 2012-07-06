//
//  UIView+UI+ViewController.m
//  CommonToolkit
//
//  Created by  on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIView+UI+ViewController.h"

#import "UIViewExtensionManager.h"

#import "CommonUtils.h"

// one hand five fingers
#define MAXFINGERS_COUNT    5
// at most triple taps
#define MAXTAPS_COUNT   3
// four swipe direction
#define SWIPEDIRECTION_COUNT    4

// UIView extension
@interface UIView (Private)

// handel gesture recognizer
- (void) handleGestureRecognizer:(UIGestureRecognizer*) pGestureRecognizer;

// validate view gesture recognizer delegate reference and check selector
- (BOOL)validateViewGestureRecognizerDelegate:(id<UIViewGestureRecognizerDelegate>)pGestureRecognizerDelegate andSelector:(SEL) pSelector;

@end




@implementation UIView (UI)

- (void)setTitle:(NSString *)title{
    // set view title
    self.viewControllerRef.title = title;
    
    // save title
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:title withType:titleExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (NSString *)title{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].title;
}

- (void)setTitleView:(UIView *)titleView{
    // set view title view
    self.viewControllerRef.navigationItem.titleView = titleView;
    
    // save title view
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:titleView withType:titleViewExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (UIView *)titleView{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].titleView;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem{
    // set view left bar button item
    self.viewControllerRef.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    // save left bar button item
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:leftBarButtonItem withType:leftBarButtonItemExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (UIBarButtonItem *)leftBarButtonItem{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].leftBarButtonItem;
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    // set view right bar button item
    self.viewControllerRef.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // save right bar button item
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:rightBarButtonItem withType:rightBarButtonItemExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (UIBarButtonItem *)rightBarButtonItem{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].rightBarButtonItem;
}

- (void)setBackgroundImg:(UIImage *)backgroundImg{
    // set view background image
    self.backgroundColor = [UIColor colorWithPatternImage:backgroundImg];
    
    // save background image
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:backgroundImg withType:backgroundImgExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (UIImage *)backgroundImg{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].backgroundImg;
}

@end




@implementation UIView (ViewController)

- (void)setViewControllerRef:(UIViewController *)viewControllerRef{
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:viewControllerRef withType:viewControllerRefExt forKey:[NSNumber numberWithInteger:self.hash]];
    
    // update UIView UI
    self.viewControllerRef.title = self.title;
    self.viewControllerRef.navigationItem.titleView = self.titleView;
    self.viewControllerRef.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    self.viewControllerRef.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
}

- (UIViewController *)viewControllerRef{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].viewControllerRef;
}

- (BOOL)validateViewControllerRef:(UIViewController *)pViewControllerRef andSelector:(SEL)pSelector{
    BOOL _ret = NO;

    // validate view controller reference and check selector implemetation
    if ([CommonUtils validateProcessor:pViewControllerRef andSelector:pSelector]) {
        _ret = YES;
    }
    else {
        NSLog(@"Error : %@", pViewControllerRef ? [NSString stringWithFormat:@"%@ view controller %@ can't implement method %@", NSStringFromClass(self.class), NSStringFromClass(pViewControllerRef.class), NSStringFromSelector(pSelector)] : [NSString stringWithFormat:@"%@ view controller is nil", NSStringFromClass(self.class)]);
    }
    
    return _ret;
}

@end




@implementation UIView (GestureRecognizer)

- (void)setViewGestureRecognizerDelegate:(id<UIViewGestureRecognizerDelegate>)viewGestureRecognizerDelegate{
    // check view view gesture recognizer delegate implement methods
    // long press
    if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(view:longPressAtPoint:andFingerMode:)]) {
        // create and init long press finger mode
        LongPressFingerMode _longPressFingerMode = /*default finger mode*/single;
        // check long press finger mode
        if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(longPressFingerModeInView:)]) {
            _longPressFingerMode = [viewGestureRecognizerDelegate longPressFingerModeInView:self];
        }
        
        // get long press finger mode integer binary array
        NSArray *_longPressFingerModeIBA = [[CommonUtils convertIntegerToBinaryArray:_longPressFingerMode] subarrayWithRange:NSMakeRange(sizeof(int) * CHAR_BIT - MAXFINGERS_COUNT, MAXFINGERS_COUNT)];
        
        // process long press finger mode integer binary array
        for (NSInteger _index = 0; _index < [_longPressFingerModeIBA count]; _index++) {
            // check finger count
            if (1 == ((NSNumber *)[_longPressFingerModeIBA objectAtIndex:_index]).intValue) {
                // create and init long press gesture recognizer
                UILongPressGestureRecognizer *_lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
                // set number of fingers
                _lpgr.numberOfTouchesRequired = 1 << MAXFINGERS_COUNT - (_index + 1);
                // set delegate
                _lpgr.delegate = self;
                // add long press gesture recognizer
                [self addGestureRecognizer:_lpgr];
            }
        }
    }
    // swipe
    if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(view:swipeAtPoint:andDirection:)]) {
        // create and init swipe direction
        UISwipeGestureRecognizerDirection _swipeDirection = /*default direction*/UISwipeGestureRecognizerDirectionRight;
        // check swipe direction
        if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(swipeDirectionInView:)]) {
            _swipeDirection = [viewGestureRecognizerDelegate swipeDirectionInView:self];
        }
        
        // get swipe direction integer binary array
        NSArray *_swipeDirectionIBA = [[CommonUtils convertIntegerToBinaryArray:_swipeDirection] subarrayWithRange:NSMakeRange(sizeof(int) * CHAR_BIT - SWIPEDIRECTION_COUNT, SWIPEDIRECTION_COUNT)];
        
        // process swipe direction integer binary array
        for (NSInteger _index = 0; _index < [_swipeDirectionIBA count]; _index++) {
            // check swipe direction
            if (1 == ((NSNumber *)[_swipeDirectionIBA objectAtIndex:_index]).intValue) {
                // create and init swipe gesture recognizer
                UISwipeGestureRecognizer *_swipegr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
                // set supply derection
                _swipegr.direction = 1 << SWIPEDIRECTION_COUNT - (_index + 1);
                // set delegate
                _swipegr.delegate = self;
                // add long press gesture recognizer
                [self addGestureRecognizer:_swipegr];
            }
        }
    }
    // tap
    if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(view:tapAtPoint:andFingerMode:andCountMode:)]) {
        // create and init tap finger mode and count mode
        TapFingerMode _tapFingerMode = /*default finger mode*/single;
        // check tap finger mode
        if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(tapFingerModeInView:)]) {
            _tapFingerMode = [viewGestureRecognizerDelegate tapFingerModeInView:self];
        }
        TapCountMode _tapCountMode = /*default count mode*/once;
        // check tap count mode
        if ([self validateViewGestureRecognizerDelegate:viewGestureRecognizerDelegate andSelector:@selector(tapCountModeInView:)]) {
            _tapCountMode = [viewGestureRecognizerDelegate tapCountModeInView:self];
        }
        
        // get tap finger mode integer binary array and count mode integer binary array
        NSArray *_tapFingerModeIBA = [[CommonUtils convertIntegerToBinaryArray:_tapFingerMode] subarrayWithRange:NSMakeRange(sizeof(int) * CHAR_BIT - MAXFINGERS_COUNT, MAXFINGERS_COUNT)];
        NSArray *_tapCountModeIBA = [[CommonUtils convertIntegerToBinaryArray:_tapCountMode] subarrayWithRange:NSMakeRange(sizeof(int) * CHAR_BIT - MAXTAPS_COUNT, MAXTAPS_COUNT)];
        
        // process tap finger mode integer binary array and count mode integer binary array
        for (NSInteger _index = 0; _index < [_tapCountModeIBA count]; _index++) {
            // check tap count
            if (1 == ((NSNumber *)[_tapCountModeIBA objectAtIndex:_index]).intValue) {
                for (NSInteger __index = 0; __index < [_tapFingerModeIBA count]; __index++) {
                    // check finger count
                    if (1 == ((NSNumber *)[_tapFingerModeIBA objectAtIndex:__index]).intValue) {
                        // create and init tap gesture recognizer
                        UITapGestureRecognizer *_tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
                        // set number of fingers
                        _tapgr.numberOfTouchesRequired = 1 << MAXFINGERS_COUNT - (__index + 1);
                        // set number of tap count
                        _tapgr.numberOfTapsRequired = 1 << MAXTAPS_COUNT - (_index + 1);
                        // set delegate
                        _tapgr.delegate = self;
                        // add tap gesture recognizer
                        [self addGestureRecognizer:_tapgr];
                    }
                }
            }
        }
    }
    
    // save view gesture recognizer delegate
    [[UIViewExtensionManager shareUIViewExtensionManager] setUIViewExtension:viewGestureRecognizerDelegate withType:viewGestureRecognizerDelegateExt forKey:[NSNumber numberWithInteger:self.hash]];
}

- (id<UIViewGestureRecognizerDelegate>)viewGestureRecognizerDelegate{
    return [[UIViewExtensionManager shareUIViewExtensionManager] uiViewExtensionForKey:[NSNumber numberWithInteger:self.hash]].viewGestureRecognizerDelegate;
}

@end




@implementation UIView (Private)

- (void)handleGestureRecognizer:(UIGestureRecognizer *)pGestureRecognizer{
    // check gesture recognizer type
    // long press
    if ([pGestureRecognizer isMemberOfClass:[UILongPressGestureRecognizer class]]) {
        // just process began state
        if(pGestureRecognizer.state == UIGestureRecognizerStateBegan){
            // validate view gesture recognizer delegate and call its method:(void)view:longPressAtPoint:andFingerMode:
            if ([self validateViewGestureRecognizerDelegate:self.viewGestureRecognizerDelegate andSelector:@selector(view:longPressAtPoint:andFingerMode:)]) {
                [self.viewGestureRecognizerDelegate view:self longPressAtPoint:[pGestureRecognizer locationInView:self] andFingerMode:((UILongPressGestureRecognizer *)pGestureRecognizer).numberOfTouchesRequired];
            }
        }
    }
    // swipe
    else if([pGestureRecognizer isMemberOfClass:[UISwipeGestureRecognizer class]]){
        // validate view gesture recognizer delegate and call its method:(void)view:swipeAtPoint:andDirection:
        if ([self validateViewGestureRecognizerDelegate:self.viewGestureRecognizerDelegate andSelector:@selector(view:swipeAtPoint:andDirection:)]) {
            [self.viewGestureRecognizerDelegate view:self swipeAtPoint:[pGestureRecognizer locationInView:self] andDirection:((UISwipeGestureRecognizer *)pGestureRecognizer).direction];
        }
    }
    // tap
    else if ([pGestureRecognizer isMemberOfClass:[UITapGestureRecognizer class]]) {
        // validate view gesture recognizer delegate and call its method:(void)view:tapAtPoint:andFingerMode:andCountMode:
        if ([self validateViewGestureRecognizerDelegate:self.viewGestureRecognizerDelegate andSelector:@selector(view:tapAtPoint:andFingerMode:andCountMode:)]) {
            [self.viewGestureRecognizerDelegate view:self tapAtPoint:[pGestureRecognizer locationInView:self] andFingerMode:((UITapGestureRecognizer *)pGestureRecognizer).numberOfTouchesRequired andCountMode:((UITapGestureRecognizer *)pGestureRecognizer).numberOfTapsRequired];
        }
    }
}

- (BOOL)validateViewGestureRecognizerDelegate:(id<UIViewGestureRecognizerDelegate>)pGestureRecognizerDelegate andSelector:(SEL)pSelector{
    BOOL _ret = NO;
    
    // validate view gesture recognizer delegate reference and check selector implemetation
    if ([CommonUtils validateProcessor:pGestureRecognizerDelegate andSelector:pSelector]) {
        _ret = YES;
    }
    else {
        NSLog(@"%@ : %@", pGestureRecognizerDelegate ? @"Warning" : @"Error", pGestureRecognizerDelegate ? [NSString stringWithFormat:@"%@ view gesture recognizer delegate %@ can't implement method %@", NSStringFromClass(self.class), NSStringFromClass(pGestureRecognizerDelegate.class), NSStringFromSelector(pSelector)] : [NSString stringWithFormat:@"%@ view gesture recognizer delegate controller is nil", NSStringFromClass(self.class)]);
    }
    
    return _ret;
}

@end
