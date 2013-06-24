//
//  UISoftKeyboard.h
//  CommonToolkit
//
//  Created by Ares on 12-6-25.
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

// height for row
- (CGFloat)softKeyboard:(UISoftKeyboard *)pSoftKeyboard heightForRow:(NSInteger)pRow;

@end




// softKeyboard delegate
@protocol UISoftKeyboardDelegate <NSObject>

@optional

// softKeyboard taped response selector
- (void)softKeyboard:(UISoftKeyboard *)pSoftKeyboard didSelectCellAtIndexPath:(NSIndexPath *)indexPath;

// need long press cell indexPaths
- (NSArray *)longPressCellIndexPathsInSoftKeyboard:(UISoftKeyboard *)pSoftKeyboard;

// softKeyboard long press response selector
- (void)softKeyboard:(UISoftKeyboard *)pSoftKeyboard longPressCellAtIndexPath:(NSIndexPath *)indexPath;

@end




// softKeyboard view
@interface UISoftKeyboard : UIView {
    // row number
    NSInteger _mRow;
    // cell number array
    NSMutableArray *_mCellNumberArr;
    
    // softKeyboard cell margin and padding, must set before dataSource
    CGFloat _mMargin;
    CGFloat _mPadding;
    
    // row height array
    NSArray *_mRowHeightArr;
    // cell width dictionary
    // key is row index (NSNumber)
    // value is cell width array (NSArray)
    NSMutableDictionary *_mCellWidthDic;
    
    // softKeyboard dataSource
    id<UISoftKeyboardDataSource> _mDataSource;
    // softkeyboard delegate
    id<UISoftKeyboardDelegate> _mDelegate;
    
    // cell dictionary
    // key is row index (NSNumber)
    // value is cell array (NSArray)
    NSMutableDictionary *_mCellDic;
}

@property (nonatomic, readwrite) CGFloat margin;
@property (nonatomic, readwrite) CGFloat padding;

@property (nonatomic, retain) id<UISoftKeyboardDataSource> dataSource;
@property (nonatomic, retain) id<UISoftKeyboardDelegate> delegate;

// indexPath for cell
- (NSIndexPath *)indexPathForCell:(UISoftKeyboardCell *)pCell;

// cell for roww at indexPath
- (UISoftKeyboardCell *)cellForRowAtIndexPath:(NSIndexPath *)pIndexPath;

// merge softKeyboard cell in range
- (BOOL)mergeCellInRange:(NSRange)pRange andCellIndexArray:(NSArray *)pCellIndexs;

@end




// This category provides convenience methods to make it easier to use an NSIndexPath to represent a row and cell
@interface NSIndexPath (UISoftKeyboard)

// softKeyboard row index
@property (nonatomic, readonly) NSInteger skb_row;
// softKeyboard cell index
@property (nonatomic, readonly) NSInteger skb_cell;

// generate indexPath for softKeyboard
+ (NSIndexPath *)indexPathForCell:(NSInteger)pSoftKeyboardCell inRow:(NSInteger)pSoftKeyboardRow;

// compare with UISoftKeyboard indexPath
- (BOOL)compareWithUISoftKeyboardIndexPath:(NSIndexPath *)pIndexPath;

@end
