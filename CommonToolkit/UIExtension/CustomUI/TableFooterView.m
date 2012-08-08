//
//  tableFooterView.m
//  feiying
//
//  Created by  on 12-2-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TableFooterView.h"
#import "NSBundle+Extension.h"

// table foot spinner view
@implementation TableFootSpinnerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
        // create indicator text label
        UILabel *_indicatorText = [[UILabel alloc] init];
        // set frame
        _indicatorText.frame = CGRectMake(140.0-64.0, 11.0, 103.0, 23.0);
        // set text and text font
        _indicatorText.text = NSLocalizedStringFromCommonToolkitBundle(@"Loading More", "");
        _indicatorText.font = [UIFont systemFontOfSize:14.0];
        _indicatorText.textColor = [UIColor grayColor];
        _indicatorText.textAlignment = UITextAlignmentCenter;
        _indicatorText.backgroundColor = [UIColor clearColor];
        // create and init activityView
        UIActivityIndicatorView *_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        // set frame
		_activityView.frame = CGRectMake(140.0+64.0+2.0, 11.0, 23.0, 23.0);
        
        // add indicatorText and activityView to view
        [self addSubview:_indicatorText];
		[self addSubview:_activityView];
        
        // start animating
        [_activityView startAnimating];
    }
    return self;
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




// table foot no more data view
@implementation TableFootNoMoreDataView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create indicator text label
        UILabel *_indicatorText = [[UILabel alloc] init];
        // set frame
        _indicatorText.frame = CGRectMake((320.0-120.0)/2, 11.0, 120.0, 23.0);
        // set text and text font
        _indicatorText.text = NSLocalizedStringFromCommonToolkitBundle(@"No more data", "");
        _indicatorText.font = [UIFont boldSystemFontOfSize:14.0];
        _indicatorText.textColor = [UIColor grayColor];
        _indicatorText.textAlignment = UITextAlignmentCenter;
        _indicatorText.backgroundColor = [UIColor clearColor];
        // add indicatorText and activityView to view
        [self addSubview:_indicatorText];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
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
