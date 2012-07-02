//
//  ECUIControlTableViewCell.h
//  imeeting_iphone
//
//  Created by star king on 12-6-8.
//  Copyright (c) 2012年 elegant cloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECUIControlTableViewCell : UITableViewCell

// init with label tip and control
-(id) initWithLabelTip:(NSString*) pString andControl:(UIControl*) pControl;

// init with controls array
-(id) initWithControls:(NSArray*) pControls;


@end
