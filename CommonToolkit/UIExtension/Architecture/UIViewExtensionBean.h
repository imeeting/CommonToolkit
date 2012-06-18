//
//  UIViewExtensionBean.h
//  CommonToolkit
//
//  Created by  on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    titleExt,
    titleViewExt,
    leftBarButtonItemExt,
    rightBarButtonItemExt,
    viewControllerRefExt,
    extensionExt
} UIViewExtensionType;


@interface UIViewExtensionBean : NSObject

// UI extension
// UIView title
@property (nonatomic, retain) NSString *title;
// title view
@property (nonatomic, retain) UIView *titleView;
// UIView navigation bar left button item
@property (nonatomic, retain) UIBarButtonItem *leftBarButtonItem;
// UIView navigation bar right button item
@property (nonatomic, retain) UIBarButtonItem *rightBarButtonItem;

// view controller reference
@property (nonatomic, retain) UIViewController *viewControllerRef;

@end
