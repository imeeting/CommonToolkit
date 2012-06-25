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

// softkeyboard cell margin and padding default value
#define MARGINPADDINGDEFAULTVALUE   1

// UISoftKeyboard extension
@interface UISoftKeyboard ()

// generate cell width array in particular row
- (NSArray *)generateCellWidthArrayInRow:(NSInteger)pRow;

// get cell total width to index in row
- (CGFloat)cellTotalWidthToIndex:(NSInteger)pIndex withCellWidthArray:(NSArray *)pCellWidthArray;

@end




@implementation UISoftKeyboard

@synthesize margin = _margin;
@synthesize padding = _padding;

@synthesize dataSource = _mDataSource;
@synthesize delegate = _mDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // alloc cell number array
        _mCellArray = [[NSMutableArray alloc] init];
        
        // set margin and padding default value
        _margin = _padding = MARGINPADDINGDEFAULTVALUE;
        
        //
    }
    return self;
}

- (void)setDataSource:(id<UISoftKeyboardDataSource>)dataSource{
    // set softKeyboard dataSource
    _mDataSource = dataSource;
    
    // init softkeyboard row number, cell number array and softKeyboard cell view
    // get rows
    _mRow = [dataSource numberOfRowsInSoftKeyboard:self];
    
    // get softKeyboard cell height
    CGFloat _cellHeight = (self.frame.size.height - 2 * _margin - (_mRow - 1) * _padding) / _mRow;
    
    // process each row
    for (NSInteger _index = 0; _index < _mRow; _index++) {
        // get cell number in row
        NSInteger _cellNumberInRow = [dataSource softKeyboard:self numberOfCellsInRow:_index];
        
        // add to cell number array
        [_mCellArray addObject:[NSNumber numberWithInteger:_cellNumberInRow]];
        
        // create and init cell width array in row
        NSArray *_cellWidthArrayInRow = [self generateCellWidthArrayInRow:_index];
        
        // create and int softkeyboard cell view and add to softKeyboard
        for (NSInteger __index = 0; __index < _cellNumberInRow; __index++) {
            // genetate indexPath
            NSIndexPath *_indexPath = [NSIndexPath indexPathForCell:__index inRow:_index];
            
            // get cell
            UISoftKeyboardCell *_cell = [dataSource softKeyboard:self cellForRowAtIndexPath:_indexPath];
            
            // get cell width
            CGFloat _cellWidth = ((NSNumber *)[_cellWidthArrayInRow objectAtIndex:__index]).floatValue;
            
            // update cell frame, origin x not confirmed
            _cell.frame = CGRectMake([self cellTotalWidthToIndex:__index withCellWidthArray:_cellWidthArrayInRow], _margin + _index * (_cellHeight + _padding), _cellWidth, _cellHeight);
            
            // add to softKeyboard view
            [self addSubview:_cell];
        }
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

- (NSArray *)generateCellWidthArrayInRow:(NSInteger)pRow{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // init tmp array
    NSMutableArray *_tmpArray = [[NSMutableArray alloc] init];

    // get cell number in row
    NSInteger _cellNumberInRow = [_mDataSource softKeyboard:self numberOfCellsInRow:pRow];
    
    // init cell width setted flag
    BOOL _cellWidthSettedFlag = [_mDataSource respondsToSelector:@selector(softKeyboard:widthForCellAtIndexPath:)];
    
    for (NSInteger _index = 0; _index < _cellNumberInRow; _index++) {
        // get cell width
        if (_cellWidthSettedFlag) {
            [_tmpArray addObject:[NSNumber numberWithFloat:[_mDataSource softKeyboard:self widthForCellAtIndexPath:[NSIndexPath indexPathForCell:_index inRow:pRow]]]];
        }
        else {
            [_tmpArray addObject:[NSNumber numberWithFloat:(self.frame.size.width - 2 * _margin - (_cellNumberInRow - 1) * _padding) / _cellNumberInRow]];
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
    CGFloat _remainingCellAvgWidth = (self.frame.size.width - 2 * _margin - (_cellNumberInRow - 1) * _padding - _cellsTotalWidth) / _cellHasnotWidthNumber;
    
    // set return cell width array
    for (NSNumber *_cellWidth in _tmpArray) {
        [_ret addObject:(0.0 == _cellWidth.floatValue) ? [NSNumber numberWithFloat:_remainingCellAvgWidth] : _cellWidth];
    }
    
    return _ret;
}

- (CGFloat)cellTotalWidthToIndex:(NSInteger)pIndex withCellWidthArray:(NSArray *)pCellWidthArray{
    CGFloat _ret = _padding;
    
    // check index parameter
    if (pIndex > [pCellWidthArray count]) {
        _ret = self.frame.size.width;
    }
    else {
        // get cell total width to index
        for (NSInteger _index = 0; _index < pIndex; _index++) {
            _ret += ((NSNumber *)[pCellWidthArray objectAtIndex:_index]).floatValue + _padding;
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
