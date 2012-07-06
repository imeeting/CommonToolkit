//
//  NSIndexPath+Extension.h
//  CommonToolkit
//
//  Created by  on 12-6-14.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (UITableViewCompare)

// compare with UITableView indexPath
- (BOOL)compareWithUITableViewIndexPath:(NSIndexPath *)pIndexPath;

@end




@interface NSIndexPath (UISoftKeyboardCompare)

// compare with UISoftKeyboard indexPath
- (BOOL)compareWithUISoftKeyboardIndexPath:(NSIndexPath *)pIndexPath;

@end
