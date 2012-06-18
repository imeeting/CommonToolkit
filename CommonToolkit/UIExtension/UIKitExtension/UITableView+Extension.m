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
    [self insertRowsAtIndexPaths:[[NSArray alloc] initWithObjects:pIndexPath, nil] withRowAnimation:pAnimation];
    
    // end update
    [self endUpdates];
}

- (void)deleteRowAtIndexPath:(NSIndexPath *)pIndexPath withRowAnimation:(UITableViewRowAnimation)pAnimation{
    // begin update
    [self beginUpdates];
    
    // delete with animation
    [self deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:pIndexPath, nil] withRowAnimation:pAnimation];
    
    // end update
    [self endUpdates];
}

@end
