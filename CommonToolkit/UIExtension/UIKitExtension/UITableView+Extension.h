//
//  UITableView+Extension.h
//  CommonToolkit
//
//  Created by Ares on 12-6-13.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (AddRemoveRow)

// insert row at indexPath
- (void)insertRowAtIndexPath:(NSIndexPath *)pIndexPath withRowAnimation:(UITableViewRowAnimation)pAnimation;

// reload row at indexPath
- (void)reloadRowAtIndexPath:(NSIndexPath *)pIndexPath withRowAnimation:(UITableViewRowAnimation)pAnimation;

// delete row at indexPath
- (void)deleteRowAtIndexPath:(NSIndexPath *)pIndexPath withRowAnimation:(UITableViewRowAnimation)pAnimation;

@end
