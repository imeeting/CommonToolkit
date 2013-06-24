//
//  UISoftKeyboard.m
//  CommonToolkit
//
//  Created by Ares on 12-6-25.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UISoftKeyboard.h"

#import "FoundationExtensionManager.h"

// softKeyboard row key
#define SOFTKEYBOARD_ROW @"softKeyboardRow"
// softKeyboard cell key
#define SOFTKEYBOARD_CELL @"softKeyboardCell"

// row or cell default number
#define ROW_CELL_DEFAULTNUMBER  1

// softkeyboard cell margin and padding default value
#define MARGIN_PADDING_DEFAULTVALUE   1.0

// UISoftKeyboard extension
@interface UISoftKeyboard ()

// generate cell width array in particular row
- (NSArray *)generateCellWidthArrayInRow:(NSInteger)pRow;

// generate row height array
- (NSArray *)generateRowHeightArray;

// get cell total width to index in row
- (CGFloat)cellTotalWidthToIndex:(NSInteger)pIndex inRow:(NSInteger)pRow;

// get row total height to index
- (CGFloat)rowTotalHeightToIndex:(NSInteger)pIndex;

@end




@implementation UISoftKeyboard

@synthesize margin = _mMargin;
@synthesize padding = _mPadding;

@synthesize dataSource = _mDataSource;
@synthesize delegate = _mDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // alloc cell number array
        _mCellNumberArr = [[NSMutableArray alloc] init];
        // alloc cell width dictionary
        _mCellWidthDic = [[NSMutableDictionary alloc] init];
        // alloc cell dictionary
        _mCellDic = [[NSMutableDictionary alloc] init];
        
        // set margin and padding default value
        _mMargin = _mPadding = MARGIN_PADDING_DEFAULTVALUE;
    }
    return self;
}

- (void)setDataSource:(id<UISoftKeyboardDataSource>)dataSource{
    // save softKeyboard dataSource
    _mDataSource = dataSource;
    
    // init softkeyboard row number, cell number array and softKeyboard cell view
    // get rows and checked
    _mRow = [dataSource numberOfRowsInSoftKeyboard:self] <= 0 ? ROW_CELL_DEFAULTNUMBER : [dataSource numberOfRowsInSoftKeyboard:self];
    
    // set softKeyboard cell height array
    _mRowHeightArr = [self generateRowHeightArray];
    
    // traversal rows
    for (NSInteger _index = 0; _index < _mRow; _index++) {
        // get cell number in row
        NSInteger _cellNumberInRow = [dataSource softKeyboard:self numberOfCellsInRow:_index] <= 0 ? ROW_CELL_DEFAULTNUMBER : [dataSource softKeyboard:self numberOfCellsInRow:_index];
        
        // add cell number in row to cell number array
        [_mCellNumberArr addObject:[NSNumber numberWithInteger:_cellNumberInRow]];
        
        // create and init cell width array in row and add to cell width dictionary
        NSArray *_cellWidthArrayInRow = [self generateCellWidthArrayInRow:_index];
        [_mCellWidthDic setObject:_cellWidthArrayInRow forKey:[NSNumber numberWithInteger:_index]];
        
        // get row height
        CGFloat _rowHeight = ((NSNumber *)[_mRowHeightArr objectAtIndex:_index]).floatValue;
        
        // create and init cell array in row
        NSMutableArray *_cellArray = [[NSMutableArray alloc] init];
        
        // create and int softkeyboard cell view and add to softKeyboard
        for (NSInteger __index = 0; __index < _cellNumberInRow; __index++) {
            @autoreleasepool {
                // get cell and init
                UISoftKeyboardCell *_cell = [dataSource softKeyboard:self cellForRowAtIndexPath:[NSIndexPath indexPathForCell:__index inRow:_index]];
                
                // add cell to cell array in row
                [_cellArray addObject:_cell];
                
                // check cell width and height, both greater than 0.0
                if (_rowHeight >= 0.0 && ((NSNumber *)[_cellWidthArrayInRow objectAtIndex:__index]).floatValue >= 0.0) {
                    // update cell frame
                    _cell.frame = CGRectMake([self cellTotalWidthToIndex:__index inRow:_index], [self rowTotalHeightToIndex:_index], ((NSNumber *)[_cellWidthArrayInRow objectAtIndex:__index]).floatValue, _rowHeight);
                    
                    // add to softKeyboard view
                    [self addSubview:_cell];
                }
            }
        }
        
        // add cell array in row to cell dictionary
        [_mCellDic setObject:_cellArray forKey:[NSNumber numberWithInteger:_index]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSIndexPath *)indexPathForCell:(UISoftKeyboardCell *)pCell{
    NSIndexPath *_ret = nil;
    
    for (NSInteger _index = 0; _index < [_mCellDic count]; _index++) {
        // traversal cell dictionary
        if ([[_mCellDic objectForKey:[NSNumber numberWithInteger:_index]] containsObject:pCell]) {
            // init return indexPath
            _ret = [NSIndexPath indexPathForCell:[[_mCellDic objectForKey:[NSNumber numberWithInteger:_index]] indexOfObject:pCell] inRow:_index];
            
            break;
        }
    }
    
    return _ret;
}

- (UISoftKeyboardCell *)cellForRowAtIndexPath:(NSIndexPath *)pIndexPath{
    return [[_mCellDic objectForKey:[NSNumber numberWithInteger:pIndexPath.skb_row]] objectAtIndex:pIndexPath.skb_cell];
}

- (BOOL)mergeCellInRange:(NSRange)pRange andCellIndexArray:(NSArray *)pCellIndexs{
    BOOL _ret = NO;
    
    // check range index and length
    if (pRange.location + pRange.length <= _mRow && pRange.length == [pCellIndexs count]) {
        // check cell index validity
        BOOL _cellIndexValidity = YES;
        
        for (NSInteger _index = 0; _index < pRange.length; _index++) {
            if (((NSNumber *)[pCellIndexs objectAtIndex:_index]).integerValue >= ((NSNumber *)[_mCellNumberArr objectAtIndex:pRange.location + _index]).integerValue) {
                // cell index is invalidity
                _cellIndexValidity = NO;
                
                break;
            }
        }
        
        // cell index is validity
        if (_cellIndexValidity) {
            // create and init cell width and origin x default value
            CGFloat _cellWidth = - 2.0/* customize */;
            CGFloat _cellOriginX = - 2.0/* customize */;
            
            // create and init merge cell height
            CGFloat _mergeCellHeight = - _mPadding;
            
            // check cell width
            BOOL _cellWidthEqual = YES;
            
            for (NSInteger __index = 0; __index < pRange.length; __index++) {
                UISoftKeyboardCell *_cell = [[_mCellDic objectForKey:[NSNumber numberWithInteger:pRange.location + __index]] objectAtIndex:((NSNumber *)[pCellIndexs objectAtIndex:__index]).integerValue];
                
                // set cell width and origin x
                _cellWidth = (- 2.0 == _cellWidth) ? _cell.frame.size.width : _cellWidth;
                _cellOriginX = (- 2.0 == _cellOriginX) ? _cell.frame.origin.x : _cellOriginX;
                
                // compare cell width and origin x with others
                if (_cellOriginX == _cell.frame.origin.x && _cellWidth == _cell.frame.size.width) {
                    _mergeCellHeight += _cell.frame.size.height + _mPadding;
                }
                else {
                    // set cell width equal flag
                    _cellWidthEqual = NO;
                    
                    break;
                }
            }
            
            // all cell width equal
            if (_cellWidthEqual) {
                // get merge rows total height
                CGFloat _mergeRowsTotalHeight = - _mPadding;
                for (NSInteger ___index = 0; ___index < pRange.length; ___index++) {
                    _mergeRowsTotalHeight += ((NSNumber *)[_mRowHeightArr objectAtIndex:pRange.location + ___index]).floatValue + _mPadding;
                }
                
                // compare merge cell height with merge rows total height
                if (_mergeCellHeight == _mergeRowsTotalHeight) {
                    // update merge present cell(the top cell) frame and remove other cells
                    for (NSInteger ____index = 0; ____index < pRange.length; ____index++) {
                        // get the cell for updating
                        UISoftKeyboardCell *__cell = [[_mCellDic objectForKey:[NSNumber numberWithInteger:pRange.location + ____index]] objectAtIndex:((NSNumber *)[pCellIndexs objectAtIndex:____index]).integerValue];
                        
                        // top cell
                        if (0 == ____index) {
                            // update cell frame
                            __cell.frame = CGRectMake(__cell.frame.origin.x, __cell.frame.origin.y, __cell.frame.size.width, _mergeCellHeight);
                        }
                        // others
                        else {
                            // remove the cell
                            [__cell removeFromSuperview];
                            
                            // update cell dictionary
                            [[_mCellDic objectForKey:[NSNumber numberWithInteger:pRange.location + ____index]] replaceObjectAtIndex:((NSNumber *)[pCellIndexs objectAtIndex:____index]).integerValue withObject:[[_mCellDic objectForKey:[NSNumber numberWithInteger:pRange.location]] objectAtIndex:((NSNumber *)[pCellIndexs objectAtIndex:0]).integerValue]];
                        }
                    }
                    
                    // merge success
                    _ret = YES;
                }
                else {
                    NSLog(@"Error: mustn't merge the merged cell");
                }
            }
        }
    }
    
    return _ret;
}

- (NSArray *)generateCellWidthArrayInRow:(NSInteger)pRow{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // init temp cell width array
    NSMutableArray *_tmpArray = [[NSMutableArray alloc] init];

    // get cell number in row
    NSInteger _cellNumberInRow = ((NSNumber *)[_mCellNumberArr objectAtIndex:pRow]).integerValue;
    
    // create and init cell width set flag
    BOOL _cellWidthSetFlag = [_mDataSource respondsToSelector:@selector(softKeyboard:widthForCellAtIndexPath:)];
    
    // set temp cell width array
    for (NSInteger _index = 0; _index < _cellNumberInRow; _index++) {
        @autoreleasepool {
            // get cell width
            if (_cellWidthSetFlag) {
                [_tmpArray addObject:[NSNumber numberWithFloat:[_mDataSource softKeyboard:self widthForCellAtIndexPath:[NSIndexPath indexPathForCell:_index inRow:pRow]]]];
            }
            else {
                [_tmpArray addObject:[NSNumber numberWithFloat:(self.frame.size.width - 2 * _mMargin - (_cellNumberInRow - 1) * _mPadding) / _cellNumberInRow]];
            }
        }
    }
    
    // check set width cell total width and hasn't set width cell number
    CGFloat _setWidthCellsTotalWidth = 0.0;
    NSInteger _cellHasnotSetWidthNumber = 0;
    for (NSNumber *_cellWidth in _tmpArray) {
        // judge cell width is it 0.0
        if (0.0 == _cellWidth.floatValue) {
            _cellHasnotSetWidthNumber += 1;
        }
        
        _setWidthCellsTotalWidth += _cellWidth.floatValue;
    }
    
    // get remaining cell average width
    CGFloat _remainingCellAvgWidth = (self.frame.size.width - 2 * _mMargin - (_cellNumberInRow - 1) * _mPadding - _setWidthCellsTotalWidth) <= 0 ? - 1.0 : (self.frame.size.width - 2 * _mMargin - (_cellNumberInRow - 1) * _mPadding - _setWidthCellsTotalWidth) / _cellHasnotSetWidthNumber;
    
    // set return result: cell width array
    for (NSNumber *_cellWidth in _tmpArray) {
        [_ret addObject:(0.0 == _cellWidth.floatValue) ? [NSNumber numberWithFloat:_remainingCellAvgWidth] : ((self.frame.size.width - 2 * _mMargin) < _cellWidth.floatValue) ? [NSNumber numberWithFloat:(self.frame.size.width - 2 * _mMargin)] : _cellWidth];
    }
    
    // check cell number in row and update cell width
    if (1 == _cellNumberInRow) {
        // just one cell in the row
        [_ret replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:self.frame.size.width - 2 * _mMargin]];
    }
    
    return _ret;
}

- (NSArray *)generateRowHeightArray{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // init temp row height array
    NSMutableArray *_tmpArray = [[NSMutableArray alloc] init];
    
    // get row number
    NSInteger _rowNumber = _mRow;
    
    // create and init row height set flag
    BOOL _rowHeightSetFlag = [_mDataSource respondsToSelector:@selector(softKeyboard:heightForRow:)];
    
    // set temp row height array 
    for (NSInteger _index = 0; _index < _rowNumber; _index++) {
        // get row height
        if (_rowHeightSetFlag) {
            [_tmpArray addObject:[NSNumber numberWithFloat:[_mDataSource softKeyboard:self heightForRow:_index]]];
        }
        else {
            [_tmpArray addObject:[NSNumber numberWithFloat:(self.frame.size.height - 2 * _mMargin - (_mRow - 1) * _mPadding) / _mRow]];
        }
    }
    
    // check set height row total height and hasn't set height row number
    CGFloat _setHeightRowsTotalHeight = 0.0;
    NSInteger _rowHasnotSetHeightNumber = 0;
    for (NSNumber *_rowHeight in _tmpArray) {
        // judge row height is it 0.0
        if (0.0 == _rowHeight.floatValue) {
            _rowHasnotSetHeightNumber += 1;
        }
        
        _setHeightRowsTotalHeight += _rowHeight.floatValue;
    }
    
    // get remaining row average height
    CGFloat _remainingRowAvgHeight = (self.frame.size.height - 2 * _mMargin - (_rowNumber - 1) * _mPadding - _setHeightRowsTotalHeight) <= 0 ? - 1.0 : (self.frame.size.height - 2 * _mMargin - (_rowNumber - 1) * _mPadding - _setHeightRowsTotalHeight) / _rowHasnotSetHeightNumber;
    
    // set return result: row height array
    for (NSNumber *_rowHeight in _tmpArray) {
        [_ret addObject:(0.0 == _rowHeight.floatValue) ? [NSNumber numberWithFloat:_remainingRowAvgHeight] : ((self.frame.size.height - 2 * _mMargin) < _rowHeight.floatValue) ? [NSNumber numberWithFloat:(self.frame.size.height - 2 * _mMargin)] : _rowHeight];
    }
    
    // check row number and update row height
    if (1 == _rowNumber) {
        // just has one row
        [_ret replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:self.frame.size.height - 2 * _mMargin]];
    }
    
    return _ret;
}

- (CGFloat)cellTotalWidthToIndex:(NSInteger)pIndex inRow:(NSInteger)pRow{
    CGFloat _ret = _mMargin;
    
    // check index
    if (pIndex > [[_mCellWidthDic objectForKey:[NSNumber numberWithInteger:pRow]] count]) {
        _ret = self.frame.size.width;
    }
    else {
        // get cell total width to index
        for (NSInteger _index = 0; _index < pIndex; _index++) {
            _ret += ((NSNumber *)[[_mCellWidthDic objectForKey:[NSNumber numberWithInteger:pRow]] objectAtIndex:_index]).floatValue + _mPadding;
        }
    }
    
    return _ret;
}

- (CGFloat)rowTotalHeightToIndex:(NSInteger)pIndex{
    CGFloat _ret = _mMargin;
    
    // check index
    if (pIndex > [_mRowHeightArr count]) {
        _ret = self.frame.size.height;
    }
    else {
        // get row total height to index
        for (NSInteger _index = 0; _index < pIndex; _index++) {
            _ret += ((NSNumber *)[_mRowHeightArr objectAtIndex:_index]).floatValue + _mPadding;
        }
    }
    
    return _ret;
}

@end




@implementation NSIndexPath (UISoftKeyboard)

- (void)setSkb_row:(NSInteger)skb_row{    
    [[FoundationExtensionManager shareFoundationExtensionManager] setFoundationExtensionBeanExtInfoDicValue:[NSNumber numberWithInteger:skb_row] withExtInfoDicKey:SOFTKEYBOARD_ROW forKey:[NSNumber numberWithInteger:[super hash]]];
}

- (NSInteger)skb_row{
    return ((NSNumber *)[[[[FoundationExtensionManager shareFoundationExtensionManager] foundationExtensionForKey:[NSNumber numberWithInteger:[super hash]]] extensionDic] objectForKey:SOFTKEYBOARD_ROW]).integerValue;
}

- (void)setSkb_cell:(NSInteger)skb_cell{    
    [[FoundationExtensionManager shareFoundationExtensionManager] setFoundationExtensionBeanExtInfoDicValue:[NSNumber numberWithInteger:skb_cell] withExtInfoDicKey:SOFTKEYBOARD_CELL forKey:[NSNumber numberWithInteger:[super hash]]];
}

- (NSInteger)skb_cell{
    return ((NSNumber *)[[[[FoundationExtensionManager shareFoundationExtensionManager] foundationExtensionForKey:[NSNumber numberWithInteger:[super hash]]] extensionDic] objectForKey:SOFTKEYBOARD_CELL]).integerValue;
}

+ (NSIndexPath *)indexPathForCell:(NSInteger)pSoftKeyboardCell inRow:(NSInteger)pSoftKeyboardRow{
    NSIndexPath *_ret = [[NSIndexPath alloc] init];
    
    // set softKeyboard row and cell number
    _ret.skb_row = pSoftKeyboardRow;
    _ret.skb_cell = pSoftKeyboardCell;
    
    return _ret;
}

- (BOOL)compareWithUISoftKeyboardIndexPath:(NSIndexPath *)pIndexPath{
    BOOL _ret = NO;
    
    if (self.skb_row == pIndexPath.skb_row && self.skb_cell == pIndexPath.skb_cell) {
        _ret = YES;
    }
    
    return _ret;
}

- (void)dealloc{
    // remove foundation extension bean from FoundationExtensionBeanDictionary
    [[FoundationExtensionManager shareFoundationExtensionManager] removeFoundationExtensionForKey:[NSNumber numberWithInteger:[super hash]]];
}

@end
