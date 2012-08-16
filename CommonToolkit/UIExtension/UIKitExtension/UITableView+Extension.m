//
//  UITableView+Extension.m
//  CommonToolkit
//
//  Created by  on 12-6-13.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (AddRemoveRow)

- (void)insertRowAtIndexPath:(NSIndexPath *)pIndexPath withRowAnimation:(UITableViewRowAnimation)pAnimation{
    // begin update
    [self beginUpdates];
    
    // insert with animation
    [self insertRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:pAnimation];
    
    // end update
    [self endUpdates];
}

- (void)reloadRowAtIndexPath:(NSIndexPath *)pIndexPath withRowAnimation:(UITableViewRowAnimation)pAnimation{
    // reload with animation
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:pAnimation];
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)pIndexPath withRowAnimation:(UITableViewRowAnimation)pAnimation{
    // begin update
    [self beginUpdates];
    
    // delete with animation
    [self deleteRowsAtIndexPaths:[NSArray arrayWithObject:pIndexPath] withRowAnimation:pAnimation];
    
    // end update
    [self endUpdates];
}

@end
