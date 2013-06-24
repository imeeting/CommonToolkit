//
//  UIActionSheet+Extension.h
//  CommonToolkit
//
//  Created by Ares on 12-6-13.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

// UIActionSheet processor category
@interface UIActionSheet (Processor) <UIActionSheetDelegate>

// actionSheet processor
@property (nonatomic, retain) id processor;
// actionSheet button clicked event selector
@property (nonatomic, readwrite) SEL buttonClickedEventSelector;

// init with actionSheet contents and title format
- (id)initWithContent:(NSArray *)pContents andTitleFormat:(NSString *)pTitleFormat, ...;

@end
