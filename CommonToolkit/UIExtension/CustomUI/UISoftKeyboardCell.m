//
//  UISoftKeyboardCell.m
//  CommonToolkit
//
//  Created by  on 12-6-25.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UISoftKeyboardCell.h"

#import "UIView+UI+ViewController.h"

#import "UISoftKeyboard.h"

@implementation UISoftKeyboardCell

@synthesize frontView = _mFrontView;

@synthesize pressedBackgroundColor = _mPressedBackgroundColor;
@synthesize pressedBackgroundImg = _mPressedBackgroundImg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    // set frame
    [super setFrame:frame];
    
    // update front view frame
    _mFrontView.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
}

- (void)setFrontView:(UIView *)frontView{
    // save front view
    _mFrontView = frontView;
    
    // set front view background color transparent
    frontView.backgroundColor = [UIColor clearColor];
    
    // set front view frame
    frontView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
    
    // add to cell
    [self addSubview:frontView];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    // set background color
    super.backgroundColor = backgroundColor;
    
    // save normal background color if nil
    _mNormalBackgroundColor = _mNormalBackgroundColor ? _mNormalBackgroundColor: backgroundColor;
}

- (void)setBackgroundImg:(UIImage *)backgroundImg{
    // set background image
    super.backgroundImg = backgroundImg;
    
    // save normal background image if nil
    _mNormalBackgroundImg = _mNormalBackgroundImg ? _mNormalBackgroundImg : backgroundImg;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // set background color is pressed background color or image
    self.backgroundColor = _mPressedBackgroundImg ? [UIColor colorWithPatternImage:_mPressedBackgroundImg] : _mPressedBackgroundColor ? _mPressedBackgroundColor : _mNormalBackgroundColor;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    // recover background color or image
    // check normal background image
    if (_mNormalBackgroundImg) {
        self.backgroundImg = _mNormalBackgroundImg;
    }
    else {
        self.backgroundColor = _mNormalBackgroundColor;
    }
    
    // call softKeyboard response selector if implemented
    if ([((UISoftKeyboard *)self.superview).delegate respondsToSelector:@selector(softKeyboard:didSelectCellAtIndexPath:)]) {
        [((UISoftKeyboard *)self.superview).delegate softKeyboard:(UISoftKeyboard *)self.superview didSelectCellAtIndexPath:[((UISoftKeyboard *)self.superview) indexPathForCell:self]];
    }
    else {
        NSLog(@"Warning : %@ can't implemante UISoftKeyboard response selector %@", NSStringFromClass(((UISoftKeyboard *)self.superview).delegate.class), NSStringFromSelector(@selector(softKeyboard:didSelectCellAtIndexPath:)));
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touched moved");
    NSLog(@"event = %@ and touches = %@", event, touches);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
