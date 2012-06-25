//
//  UISoftKeyboard.h
//  CommonToolkit
//
//  Created by  on 12-6-25.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UISoftKeyboardCell.h"

@class UISoftKeyboard;

// softKeyboard dataSource
@protocol UISoftKeyboardDataSource <NSObject>

@required

// number of rows in softKeyboard
- (NSInteger)numberOfRowsInSoftKeyboard:(UISoftKeyboard *)pSoftKeyboard;

// number of cells in row
- (NSInteger)softKeyboard:(UISoftKeyboard *)pSoftKeyboard numberOfCellsInRow:(NSInteger)pRow;

// softKeyboard cell for row at indexPath
- (UISoftKeyboardCell *)softKeyboard:(UISoftKeyboard *)pSoftKeyboard cellForRowAtIndexPath:(NSIndexPath *)pIndexPath;

@optional

// width for cell at indexPath
- (CGFloat)softKeyboard:(UISoftKeyboard *)pSoftKeyboard widthForCellAtIndexPath:(NSIndexPath *)pIndexPath;

@end




// softKeyboard delegate
@protocol UISoftKeyboardDelegate <NSObject>

//

@end




// softKeyboard view
@interface UISoftKeyboard : UIView {
    // row number
    NSInteger _mRow;
    // cell number array
    NSMutableArray *_mCellArray;
    
    // softKeyboard cell margin and padding
    NSInteger _mMargin;
    NSInteger _mPadding;
    
    // softKeyboard dataSource
    id<UISoftKeyboardDataSource> _mDataSource;
    // softkeyboard delegate
    id<UISoftKeyboardDelegate> _mDelegate;
}

@property (nonatomic, readwrite) NSInteger margin;
@property (nonatomic, readwrite) NSInteger padding;

@property (nonatomic, retain) id<UISoftKeyboardDataSource> dataSource;
@property (nonatomic, retain) id<UISoftKeyboardDelegate> delegate;

@end




// This category provides convenience methods to make it easier to use an NSIndexPath to represent a row and cell
@interface NSIndexPath (UISoftKeyboard)

// softKeyboard row index
@property (nonatomic, readonly) NSInteger skb_row;
// softKeyboard cell index
@property (nonatomic, readonly) NSInteger skb_cell;

// generate indexPath for softKeyboard
+ (NSIndexPath *)indexPathForCell:(NSInteger)pSoftKeyboardCell inRow:(NSInteger)pSoftKeyboardRow;

@end
