//
//  UIAttributedLabel.h
//  CommonToolkit
//
//  Created by Ares on 12-7-14.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreText/CoreText.h>

@class UIAttributedLabel;

// define justify text alignment
#define UITextAlignmentJustify ((UITextAlignment)kCTJustifiedTextAlignment)

// get CTTextAlignment from UITextAlignment
CTTextAlignment CTTextAlignmentFromUITextAlignment(UITextAlignment alignment);

// get CTLineBreakMode from UILineBreakMode
CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode);


// attributed label delegate
@protocol UIAttributedLabelDelegate <NSObject>

@optional

// set is attributed label
- (BOOL)attributedLabel:(UIAttributedLabel *)pAttributedLabel shouldFollowLink:(NSTextCheckingResult *)pLinkInfo;

// underline style is combination of CTUnderlineStyle and CTUnderlineStyleModifiers
- (UIColor *)colorForLink:(NSTextCheckingResult *)pLinkInfo underlineStyle:(CTUnderlineStyle *)pUnderlineStyle;

@end




// attributed label
@interface UIAttributedLabel : UILabel {
    // attributed label text, use this instead of the "text" property inherited from UILabel to set and get text
    NSMutableAttributedString *_mAttributedText;
    
    // defaults to NSTextCheckingTypeLink, + NSTextCheckingTypePhoneNumber if "tel:" scheme supported
    NSTextCheckingTypes _mAutomaticallyAddLinksForType;
    
    // defaults to [UIColor blueColor], see also UIAttributedLabelDelegate
    UIColor *_mLinkColor;
    // defaults to [UIColor colorWithWhite:0.2 alpha:0.5]
    UIColor *_mHighlightedLinkColor;
    
    // defaults to YES, see also UIAttributedLabelDelegate
    BOOL _mUnderlineLinks;
    
    // if YES, pointInside will only return YES if the touch is on a link, if NO, pointInside will always return YES (defaults to NO)
    BOOL _mOnlyCatchTouchesOnLinks;
    
    BOOL _mCenterVertically;
    // allows to draw text past the bottom of the view if need, may help in rare cases (like using Emoji)
    BOOL _mExtendBottomToFit;
    
    // text frame reference
	CTFrameRef _mTextFrameRef;
    // attribute label drawing rect
	CGRect _mDrawingRect;
    // touch start point
    CGPoint _mTouchStartPoint;
	
    // custom link array
    NSMutableArray *_mCustomLinks;
    // avtive link
    NSTextCheckingResult *_mActiveLink;
    
    // attributed label delegate
    id<UIAttributedLabelDelegate> _mDelegate;
}

@property (nonatomic, copy) NSAttributedString *attributedText;

@property (nonatomic, assign) NSTextCheckingTypes automaticallyAddLinksForType; 

@property (nonatomic, retain) UIColor *linkColor;
@property (nonatomic, retain) UIColor *highlightedLinkColor; 

@property (nonatomic, assign) BOOL underlineLinks; 

@property (nonatomic, assign) BOOL onlyCatchTouchesOnLinks; 

@property (nonatomic, assign) BOOL centerVertically;

@property (nonatomic, assign) BOOL extendBottomToFit; 

@property (nonatomic, retain) id<UIAttributedLabelDelegate> delegate;

// rebuild the attributedString based on UILabel's text/font/color/alignment/... properties
- (void)resetAttributedText; 

// add custom link in range
- (void)addCustomLink:(NSURL *)pLinkUrl inRange:(NSRange)pRange;

// remove all custom links
- (void)removeAllCustomLinks;

@end
