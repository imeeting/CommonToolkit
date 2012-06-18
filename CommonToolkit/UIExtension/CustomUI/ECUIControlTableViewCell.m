//
//  ECUIControlTableViewCell.m
//  imeeting_iphone
//
//  Created by star king on 12-6-8.
//  Copyright (c) 2012年 elegant cloud. All rights reserved.
//

#import "ECUIControlTableViewCell.h"
#import "NSString+Extension.h"

@implementation ECUIControlTableViewCell

-(id) initWithLabelTip:(NSString *)pString andControl:(UIControl *)pControl{
    self = [super init];
    if (self) {
        //NSLog(@"controlTableViewCell - initWithLabelTip - tip string = %@ and control = %@", pString, pControl);
        // set cell default height
        CGFloat _cellHeight = 40.0;
        
        // set style
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // save control width
        CGFloat _controlWidth = pControl.frame.size.width;
        
        // cell content setting
        UILabel *_labelTip = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 5.0, 80.0, 30.0)];
        // set text
        _labelTip.font = [UIFont boldSystemFontOfSize:15];
        _labelTip.text = pString;
        _labelTip.backgroundColor = [UIColor clearColor];
        
        
        pControl.frame = CGRectMake(_labelTip.frame.origin.x+_labelTip.frame.size.width+5.0, _labelTip.frame.origin.y, self.frame.size.width-(_labelTip.frame.origin.x+_labelTip.frame.size.width+5.0)-_labelTip.frame.origin.x-20.0, _labelTip.frame.size.height);
        
        // add table cell content to view
        if(pString && pControl == nil){
            // update label tip frame and font
            // get label string row
            NSInteger _rows = 0;
            for(NSString *_paragraph in [pString stringParagraphs]){
                _rows += ((NSInteger)[_paragraph stringPixelLengthByFontSize:14 andIsBold:NO]%260==0) ? [_paragraph stringPixelLengthByFontSize:14 andIsBold:NO]/260.0 : [_paragraph stringPixelLengthByFontSize:14 andIsBold:NO]/260.0+1; 
            }
            // update frame
            _labelTip.frame = CGRectMake(_labelTip.frame.origin.x, _labelTip.frame.origin.y, 280.0, _rows*[pString stringPixelLengthByFontSize:14 andIsBold:NO]);
            _labelTip.numberOfLines = _rows;
            // update font
            _labelTip.font = [UIFont systemFontOfSize:14.0];
            
            //update cellHeight
            _cellHeight = _rows*[pString stringPixelHeightByFontSize:14 andIsBold:NO]+2*5.0;
        }
        else if(pString == nil && pControl){
            // control left move center
            pControl.frame = CGRectMake((self.frame.size.width-20.0-_controlWidth)/2, pControl.frame.origin.y, _controlWidth, pControl.frame.size.height);
        }
        
        // add components to cell content view
        if(pString){
            [self.contentView addSubview:_labelTip];
        }
        if(pControl){
            [self.contentView addSubview:pControl];
        }
        
        // set frame size height
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _cellHeight);
    }
    return self;
}

// init with controls array
-(id) initWithControls:(NSArray*) pControls{
    self = [super init];
    if (self) {
        //NSLog(@"controlTableViewCell - initWithLabelTip - tip string = %@ and control = %@", pString, pControl);
        // set cell default height
        CGFloat _cellHeight = 40.0;
        
        // set style
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // save each control's width and add each control to cell content view
        NSMutableArray *_controlsWidthArray = [[NSMutableArray alloc] initWithCapacity:[pControls count]];
        for(UIControl *_control in pControls){
            // save width
            [_controlsWidthArray addObject:[NSNumber numberWithFloat:_control.frame.size.width]];
            // add to cell content view
            [self.contentView addSubview:_control];
        }
        
        // process two and three controls
        switch ([pControls count]) {
            case 2:
            {
                // get two controls
                UIControl *_control1 = [pControls objectAtIndex:0];
                UIControl *_control2 = [pControls objectAtIndex:1];
                
                // controls move
                _control1.frame = CGRectMake((self.frame.size.width-20.0)/2-5.0-((NSNumber*)[_controlsWidthArray objectAtIndex:0]).floatValue, 5.0, ((NSNumber*)[_controlsWidthArray objectAtIndex:0]).floatValue, 30.0);
                _control2.frame = CGRectMake((self.frame.size.width-20.0)/2+5.0, 5.0, ((NSNumber*)[_controlsWidthArray objectAtIndex:1]).floatValue, 30.0);
            }
                break;
                
            case 3:
            {
                // get three controls
                UIControl *_control1 = [pControls objectAtIndex:0];
                UIControl *_control2 = [pControls objectAtIndex:1];
                UIControl *_control3 = [pControls objectAtIndex:2];
                
                // controls center
                _control2.frame = CGRectMake((self.frame.size.width-20.0-((NSNumber*)[_controlsWidthArray objectAtIndex:1]).floatValue)/2, 5.0, ((NSNumber*)[_controlsWidthArray objectAtIndex:1]).floatValue, 30.0);
                _control1.frame = CGRectMake(_control2.frame.origin.x-5.0-((NSNumber*)[_controlsWidthArray objectAtIndex:0]).floatValue, 5.0, ((NSNumber*)[_controlsWidthArray objectAtIndex:0]).floatValue, 30.0);
                _control3.frame = CGRectMake(_control2.frame.origin.x+((NSNumber*)[_controlsWidthArray objectAtIndex:1]).floatValue+5.0, 5.0, ((NSNumber*)[_controlsWidthArray objectAtIndex:2]).floatValue, 30.0);
            }
                break;
        }
        
        // set frame size height
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _cellHeight);
    }
    return self;
}


@end
