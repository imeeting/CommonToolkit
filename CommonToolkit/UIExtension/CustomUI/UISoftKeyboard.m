//
//  UISoftKeyboard.m
//  CommonToolkit
//
//  Created by  on 12-6-25.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UISoftKeyboard.h"

#import "FoundationExtensionManager.h"

// softKeyboard row key
#define SOFTKEYBOARDROW @"softKeyboardRow"
// softKeyboard cell key
#define SOFTKEYBOARDCELL @"softKeyboardCell"

// default row or cell number
#define DEFAULTROWORCELLNUMBER  1

// softkeyboard cell margin and padding default value
#define MARGINPADDINGDEFAULTVALUE   1

// UISoftKeyboard extension
@interface UISoftKeyboard ()

// generate cell width array in particular row
- (NSArray *)generateCellWidthArrayInRow:(NSInteger)pRow;

// generate row height array
- (NSArray *)generateRowHeightArray;

// get cell total width to index in row
- (CGFloat)cellTotalWidthToIndex:(NSInteger)pIndex withCellWidthArray:(NSArray *)pCellWidthArray;

// get row total height to index
- (CGFloat)rowTotalHeightToIndex:(NSInteger)pIndex withRowHeightArray:(NSArray *)pRowHeightArray;

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
        // Initialization code
        
        // alloc cell number array
        _mCellNumberArr = [[NSMutableArray alloc] init];
        
        // alloc cell dictionary
        _mCellDic = [[NSMutableDictionary alloc] init];
        
        // set margin and padding default value
        _mMargin = _mPadding = MARGINPADDINGDEFAULTVALUE;
        
        //
    }
    return self;
}

- (void)setDataSource:(id<UISoftKeyboardDataSource>)dataSource{
    // set softKeyboard dataSource
    _mDataSource = dataSource;
    
    // init softkeyboard row number, cell number array and softKeyboard cell view
    // get rows
    _mRow = [dataSource numberOfRowsInSoftKeyboard:self] <= 0 ? DEFAULTROWORCELLNUMBER : [dataSource numberOfRowsInSoftKeyboard:self];
    
    // create and init softKeyboard cell height array
    NSArray *_rowHeightArray = [self generateRowHeightArray];
    
    // process each row
    for (NSInteger _index = 0; _index < _mRow; _index++) {
        // get cell number in row
        NSInteger _cellNumberInRow = [dataSource softKeyboard:self numberOfCellsInRow:_index] <= 0 ? DEFAULTROWORCELLNUMBER : [dataSource softKeyboard:self numberOfCellsInRow:_index];
        
        // add cell numberin row to cell number array
        [_mCellNumberArr addObject:[NSNumber numberWithInteger:_cellNumberInRow]];
        
        // get row height
        CGFloat _rowHeight = ((NSNumber *)[_rowHeightArray objectAtIndex:_index]).floatValue;
        
        // create and init cell width array in row
        NSArray *_cellWidthArrayInRow = [self generateCellWidthArrayInRow:_index];
        
        // create and init cell array in row
        NSMutableArray *_cellArray = [[NSMutableArray alloc] init];
        
        // create and int softkeyboard cell view and add to softKeyboard
        for (NSInteger __index = 0; __index < _cellNumberInRow; __index++) {
            @autoreleasepool {
                // get cell
                UISoftKeyboardCell *_cell = [dataSource softKeyboard:self cellForRowAtIndexPath:[NSIndexPath indexPathForCell:__index inRow:_index]];
                
                // add cell to cell array in row
                [_cellArray addObject:_cell];
                
                // check cell width and height
                if (_rowHeight >= 0.0 && ((NSNumber *)[_cellWidthArrayInRow objectAtIndex:__index]).floatValue >= 0.0) {
                    // update cell frame, origin x not confirmed
                    _cell.frame = CGRectMake([self cellTotalWidthToIndex:__index withCellWidthArray:_cellWidthArrayInRow], [self rowTotalHeightToIndex:_index withRowHeightArray:_rowHeightArray], ((NSNumber *)[_cellWidthArrayInRow objectAtIndex:__index]).floatValue, _rowHeight);
                    
                    // add to softKeyboard view
                    [self addSubview:_cell];
                }
            }
        }
        
        // set cell dictionary
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
    if (pRange.location + pRange.length < _mRow && pRange.length == [pCellIndexs count]) {
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
            // create and init cell width default value
            CGFloat _cellWidth = - 2.0;
            
            // create and init merged cell height
            CGFloat _mergeCellHeight = - _mPadding;
            
            // check cell width
            BOOL _cellWidthEqual = YES;
            
            for (NSInteger _index = 0; _index < pRange.length; _index++) {
                UISoftKeyboardCell *_cell = [[_mCellDic objectForKey:[NSNumber numberWithInteger:pRange.location + _index]] objectAtIndex:((NSNumber *)[pCellIndexs objectAtIndex:_index]).integerValue];
                
                // set cell width
                _cellWidth = (- 2.0 == _cellWidth) ? _cell.frame.size.width : _cellWidth;
                
                // compare cell width with others
                if (_cellWidth == _cell.frame.size.width) {
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
                // update merged present cell frame
                UISoftKeyboardCell *__cell = [[_mCellDic objectForKey:[NSNumber numberWithInteger:pRange.location]] objectAtIndex:((NSNumber *)[pCellIndexs objectAtIndex:0]).integerValue];
                
                __cell.frame = CGRectMake(__cell.frame.origin.x, __cell.frame.origin.y, __cell.frame.size.width, _mergeCellHeight);
                
                // bring to front
                [self bringSubviewToFront:__cell];
                
                // merge ok
                _ret = YES;
            }
        }
    }
    
    return _ret;
}

- (NSArray *)generateCellWidthArrayInRow:(NSInteger)pRow{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // init tmp array
    NSMutableArray *_tmpArray = [[NSMutableArray alloc] init];

    // get cell number in row
    NSInteger _cellNumberInRow = ((NSNumber *)[_mCellNumberArr objectAtIndex:pRow]).integerValue;
    
    // init cell width setted flag
    BOOL _cellWidthSettedFlag = [_mDataSource respondsToSelector:@selector(softKeyboard:widthForCellAtIndexPath:)];
    
    // init temp cell width array
    for (NSInteger _index = 0; _index < _cellNumberInRow; _index++) {
        @autoreleasepool {
            // get cell width
            if (_cellWidthSettedFlag) {
                [_tmpArray addObject:[NSNumber numberWithFloat:[_mDataSource softKeyboard:self widthForCellAtIndexPath:[NSIndexPath indexPathForCell:_index inRow:pRow]]]];
            }
            else {
                [_tmpArray addObject:[NSNumber numberWithFloat:(self.frame.size.width - 2 * _mMargin - (_cellNumberInRow - 1) * _mPadding) / _cellNumberInRow]];
            }
        }
    }
    
    // check cell total width and hasn't width cell number
    CGFloat _cellsTotalWidth = 0.0;
    NSInteger _cellHasnotWidthNumber = 0;
    for (NSNumber *_cellWidth in _tmpArray) {
        // check width is 0.0
        if (0.0 == _cellWidth.floatValue) {
            _cellHasnotWidthNumber += 1;
        }
        
        _cellsTotalWidth += _cellWidth.floatValue;
    }
    
    // get remaining cell average width
    CGFloat _remainingCellAvgWidth = (self.frame.size.width - 2 * _mMargin - (_cellNumberInRow - 1) * _mPadding - _cellsTotalWidth) <= 0 ? - 1.0 : (self.frame.size.width - 2 * _mMargin - (_cellNumberInRow - 1) * _mPadding - _cellsTotalWidth) / _cellHasnotWidthNumber;
    
    // set return cell width array
    for (NSNumber *_cellWidth in _tmpArray) {
        [_ret addObject:(0.0 == _cellWidth.floatValue) ? [NSNumber numberWithFloat:_remainingCellAvgWidth] : ((self.frame.size.width - 2 * _mMargin) < _cellWidth.floatValue) ? [NSNumber numberWithFloat:(self.frame.size.width - 2 * _mMargin)] : _cellWidth];
    }
    
    // check cell number in row
    if (1 == _cellNumberInRow) {
        [_ret replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:self.frame.size.width - 2 * _mMargin]];
    }
    
    return _ret;
}

- (NSArray *)generateRowHeightArray{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // init tmp array
    NSMutableArray *_tmpArray = [[NSMutableArray alloc] init];
    
    // get row number
    NSInteger _rowNumber = _mRow;
    
    // init row height setted flag
    BOOL _rowHeightSettedFlag = [_mDataSource respondsToSelector:@selector(softKeyboard:heightForRow:)];
    
    // init temp row height array 
    for (NSInteger _index = 0; _index < _rowNumber; _index++) {
        // get row height
        if (_rowHeightSettedFlag) {
            [_tmpArray addObject:[NSNumber numberWithFloat:[_mDataSource softKeyboard:self heightForRow:_index]]];
        }
        else {
            [_tmpArray addObject:[NSNumber numberWithFloat:(self.frame.size.height - 2 * _mMargin - (_mRow - 1) * _mPadding) / _mRow]];
        }
    }
    
    // check row total height and hasn't height row number
    CGFloat _rowsTotalHeight = 0.0;
    NSInteger _rowHasnotHeightNumber = 0;
    for (NSNumber *_rowHeight in _tmpArray) {
        // check height is 0.0
        if (0.0 == _rowHeight.floatValue) {
            _rowHasnotHeightNumber += 1;
        }
        
        _rowsTotalHeight += _rowHeight.floatValue;
    }
    
    // get remaining row average height
    CGFloat _remainingRowAvgHeight = (self.frame.size.height - 2 * _mMargin - (_rowNumber - 1) * _mPadding - _rowsTotalHeight) <= 0 ? - 1.0 : (self.frame.size.height - 2 * _mMargin - (_rowNumber - 1) * _mPadding - _rowsTotalHeight) / _rowHasnotHeightNumber;
    
    // set return row height array
    for (NSNumber *_rowHeight in _tmpArray) {
        [_ret addObject:(0.0 == _rowHeight.floatValue) ? [NSNumber numberWithFloat:_remainingRowAvgHeight] : ((self.frame.size.height - 2 * _mMargin) < _rowHeight.floatValue) ? [NSNumber numberWithFloat:(self.frame.size.height - 2 * _mMargin)] : _rowHeight];
    }
    
    // check row number
    if (1 == _rowNumber) {
        [_ret replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:self.frame.size.height - 2 * _mMargin]];
    }
    
    return _ret;
}

- (CGFloat)cellTotalWidthToIndex:(NSInteger)pIndex withCellWidthArray:(NSArray *)pCellWidthArray{
    CGFloat _ret = _mMargin;
    
    // check index parameter
    if (pIndex > [pCellWidthArray count]) {
        _ret = self.frame.size.width;
    }
    else {
        // get cell total width to index
        for (NSInteger _index = 0; _index < pIndex; _index++) {
            _ret += ((NSNumber *)[pCellWidthArray objectAtIndex:_index]).floatValue + _mPadding;
        }
    }
    
    return _ret;
}

- (CGFloat)rowTotalHeightToIndex:(NSInteger)pIndex withRowHeightArray:(NSArray *)pRowHeightArray{
    CGFloat _ret = _mMargin;
    
    // check index parameter
    if (pIndex > [pRowHeightArray count]) {
        _ret = self.frame.size.height;
    }
    else {
        // get row total height to index
        for (NSInteger _index = 0; _index < pIndex; _index++) {
            _ret += ((NSNumber *)[pRowHeightArray objectAtIndex:_index]).floatValue + _mPadding;
        }
    }
    
    return _ret;
}

@end




@implementation NSIndexPath (UISoftKeyboard)

- (void)setSkb_row:(NSInteger)skb_row{    
    [[FoundationExtensionManager shareFoundationExtensionManager] setFoundationExtensionBeanExtInfoDicValue:[NSNumber numberWithInteger:skb_row] withExtInfoDicKey:SOFTKEYBOARDROW forKey:[NSNumber numberWithInteger:[super hash]]];
}

- (NSInteger)skb_row{
    return ((NSNumber *)[[[[FoundationExtensionManager shareFoundationExtensionManager] foundationExtensionForKey:[NSNumber numberWithInteger:[super hash]]] extensionDic] objectForKey:SOFTKEYBOARDROW]).integerValue;
}

- (void)setSkb_cell:(NSInteger)skb_cell{    
    [[FoundationExtensionManager shareFoundationExtensionManager] setFoundationExtensionBeanExtInfoDicValue:[NSNumber numberWithInteger:skb_cell] withExtInfoDicKey:SOFTKEYBOARDCELL forKey:[NSNumber numberWithInteger:[super hash]]];
}

- (NSInteger)skb_cell{
    return ((NSNumber *)[[[[FoundationExtensionManager shareFoundationExtensionManager] foundationExtensionForKey:[NSNumber numberWithInteger:[super hash]]] extensionDic] objectForKey:SOFTKEYBOARDCELL]).integerValue;
}

+ (NSIndexPath *)indexPathForCell:(NSInteger)pSoftKeyboardCell inRow:(NSInteger)pSoftKeyboardRow{
    NSIndexPath *_ret = [[NSIndexPath alloc] init];
    
    // set softKeyboard row and cell number
    _ret.skb_row = pSoftKeyboardRow;
    _ret.skb_cell = pSoftKeyboardCell;
    
    return _ret;
}

- (void)dealloc{
    // remove foundation extension bean from FoundationExtensionBeanDictionary
    [[FoundationExtensionManager shareFoundationExtensionManager] removeFoundationExtensionForKey:[NSNumber numberWithInteger:[super hash]]];
}

@end
