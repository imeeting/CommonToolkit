//
//  UIAttributedLabel.m
//  CommonToolkit
//
//  Created by  on 12-7-14.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "UIAttributedLabel.h"

#import "NSAttributedString+Extension.h"

#define OHAttributedLabel_WarnAboutKnownIssues 1

CTTextAlignment CTTextAlignmentFromUITextAlignment(UITextAlignment alignment) {
	switch (alignment) {
		case UITextAlignmentLeft: 
            return kCTLeftTextAlignment;
		case UITextAlignmentCenter: 
            return kCTCenterTextAlignment;
		case UITextAlignmentRight: 
            return kCTRightTextAlignment;
            // special OOB value if we decide to use it even if it's not really standard... 
		case UITextAlignmentJustify: 
            return kCTJustifiedTextAlignment; 
		default: 
            return kCTNaturalTextAlignment;
	}
}

CTLineBreakMode CTLineBreakModeFromUILineBreakMode(UILineBreakMode lineBreakMode) {
	switch (lineBreakMode) {
		case UILineBreakModeWordWrap: 
            return kCTLineBreakByWordWrapping;
		case UILineBreakModeCharacterWrap: 
            return kCTLineBreakByCharWrapping;
		case UILineBreakModeClip: 
            return kCTLineBreakByClipping;
		case UILineBreakModeHeadTruncation: 
            return kCTLineBreakByTruncatingHead;
		case UILineBreakModeTailTruncation: 
            return kCTLineBreakByTruncatingTail;
		case UILineBreakModeMiddleTruncation: 
            return kCTLineBreakByTruncatingMiddle;
		default: 
            return 0;
	}
}

// point flipped
// don't use this method for origins, origins always depend on the height of the rect
CGPoint CGPointFlipped(CGPoint point, CGRect bounds) {
	return CGPointMake(point.x, CGRectGetMaxY(bounds)-point.y);
}

// rect flipped
CGRect CGRectFlipped(CGRect rect, CGRect bounds) {
	return CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(bounds)-CGRectGetMaxY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
}

// get NSRange from CFRange
NSRange NSRangeFromCFRange(CFRange range) {
	return NSMakeRange(range.location, range.length);
}

// line font metrics
CGRect CTLineGetTypographicBoundsAsRect(CTLineRef line, CGPoint lineOrigin) {
	CGFloat _ascent = 0.0;
	CGFloat _descent = 0.0;
	CGFloat _leading = 0.0;
	CGFloat _width = CTLineGetTypographicBounds(line, &_ascent, &_descent, &_leading);
	CGFloat _height = _ascent + _descent /* + _leading */;
	
	return CGRectMake(lineOrigin.x, lineOrigin.y - _descent, _width, _height);
}

// run font metrics
CGRect CTRunGetTypographicBoundsAsRect(CTRunRef run, CTLineRef line, CGPoint lineOrigin) {
	CGFloat _ascent = 0.0;
	CGFloat _descent = 0.0;
	CGFloat _leading = 0.0;
	CGFloat _width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &_ascent, &_descent, &_leading);
	CGFloat _height = _ascent + _descent /* + _leading */;
	
	CGFloat _xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
	
	return CGRectMake(lineOrigin.x + _xOffset, lineOrigin.y - _descent, _width, _height);
}

// lined
BOOL CTLineContainsCharactersFromStringRange(CTLineRef line, NSRange range) {
	NSRange _lineRange = NSRangeFromCFRange(CTLineGetStringRange(line));
	NSRange _intersectedRange = NSIntersectionRange(_lineRange, range);
	return (_intersectedRange.length > 0);
}

// runned
BOOL CTRunContainsCharactersFromStringRange(CTRunRef run, NSRange range) {
	NSRange _runRange = NSRangeFromCFRange(CTRunGetStringRange(run));
	NSRange _intersectedRange = NSIntersectionRange(_runRange, range);
	return (_intersectedRange.length > 0);
}


// UIAttributedLabel extension
@interface UIAttributedLabel ()

// custom init
- (void)customInit;

// link text at character index
- (NSTextCheckingResult *)linkAtCharacterIndex:(CFIndex)pIndex;
// link text at point
- (NSTextCheckingResult *)linkAtPoint:(CGPoint)pPoint;

// get link setting attributed text
- (NSMutableAttributedString *)attributedTextWithLinks;

// resrt text frame
- (void)resetTextFrame;

// drawing avtive link heightlight
- (void)drawActiveLinkHighlightForRect:(CGRect)pRect;

#if OHAttributedLabel_WarnAboutKnownIssues
- (void)warnAboutKnownIssues_CheckLineBreakMode;
- (void)warnAboutKnownIssues_CheckAdjustsFontSizeToFitWidth;
#endif

@end




@implementation UIAttributedLabel

@synthesize automaticallyAddLinksForType = _mAutomaticallyAddLinksForType;

@synthesize linkColor = _mLinkColor;
@synthesize highlightedLinkColor = _mHighlightedLinkColor; 

@synthesize underlineLinks = _mUnderlineLinks;

@synthesize onlyCatchTouchesOnLinks = _mOnlyCatchTouchesOnLinks;

@synthesize centerVertically = _mCenterVertically;

@synthesize extendBottomToFit = _mExtendBottomToFit;

@synthesize delegate = _mDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // custom init
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
	if (self) {
		[self customInit];
#if OHAttributedLabel_WarnAboutKnownIssues
		[self warnAboutKnownIssues_CheckLineBreakMode];
		[self warnAboutKnownIssues_CheckAdjustsFontSizeToFitWidth];
#endif
	}
	return self;
}

- (void)dealloc{
	[self resetTextFrame];
    
	_mLinkColor = nil;
	_mHighlightedLinkColor = nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    // never return self. always return the result of [super hitTest..].
	// this takes userInteraction state, enabled, alpha values etc. into account
	UIView *_hitResult = [super hitTest:point withEvent:event];
	
	// don't check for links if the event was handled by one of the subviews
	if (_hitResult != self) {
		return _hitResult;
	}
	
	if (self.onlyCatchTouchesOnLinks) {
		BOOL _didHitLink = ([self linkAtPoint:point] != nil);
		if (!_didHitLink) {
			// not catch the touch if it didn't hit a link
			return nil;
		}
	}
	return _hitResult;
}

- (CGSize)sizeThatFits:(CGSize)size{
    NSMutableAttributedString *_attributedTextWithLinks = [self attributedTextWithLinks];
	if (!_attributedTextWithLinks) {
        return CGSizeZero;
    }
    
	return [_attributedTextWithLinks sizeConstrainedToSize:size fitRange:NULL];
}

- (void)setNeedsDisplay{
    [self resetTextFrame];
    
	[super setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *_touch = [touches anyObject];
	CGPoint _point = [_touch locationInView:self];
	
	_mActiveLink = [self linkAtPoint:_point];
	_mTouchStartPoint = _point;
	
	// we're using activeLink to draw a highlight in -drawRect:
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *_touch = [touches anyObject];
	CGPoint _point = [_touch locationInView:self];
	
	NSTextCheckingResult *_linkAtTouchesEnded = [self linkAtPoint:_point];
	
	BOOL _closeToStart = (abs(_mTouchStartPoint.x - _point.x) < 10 && abs(_mTouchStartPoint.y - _point.y) < 10);
    
	// we can check on equality of the ranges themselfes since the data detectors create new results
	if (_mActiveLink && (NSEqualRanges(_mActiveLink.range, _linkAtTouchesEnded.range) || _closeToStart)) {
		BOOL _openLink = (self.delegate && [self.delegate respondsToSelector:@selector(attributedLabel:shouldFollowLink:)]) ? [self.delegate attributedLabel:self shouldFollowLink:_mActiveLink] : YES;
        
		if (_openLink) {
            [[UIApplication sharedApplication] openURL:_mActiveLink.URL];
        }
	}
	
	_mActiveLink = nil;
	
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	_mActiveLink = nil;
    
	[self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect{
    if (_mAttributedText) {
		CGContextRef _contextRef = UIGraphicsGetCurrentContext();
		CGContextSaveGState(_contextRef);
		
		// flipping the context to draw core text
		// no need to flip our typographical bounds from now on
		CGContextConcatCTM(_contextRef, CGAffineTransformScale(CGAffineTransformMakeTranslation(0, self.bounds.size.height), 1.f, -1.f));
		
		if (self.shadowColor) {
			CGContextSetShadowWithColor(_contextRef, self.shadowOffset, 0.0, self.shadowColor.CGColor);
		}
		
		NSMutableAttributedString *_attributedTextWithLinks = [self attributedTextWithLinks];
		if (self.highlighted && self.highlightedTextColor != nil) {
			[_attributedTextWithLinks setTextColor:self.highlightedTextColor];
		}
		if (_mTextFrameRef == NULL) {
			CTFramesetterRef _frameSetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_attributedTextWithLinks);
			_mDrawingRect = self.bounds;
			if (self.centerVertically || self.extendBottomToFit) {
				CGSize _size = CTFramesetterSuggestFrameSizeWithConstraints(_frameSetterRef, CFRangeMake(0, 0), NULL, CGSizeMake(_mDrawingRect.size.width, CGFLOAT_MAX), NULL);
				if (self.extendBottomToFit) {
					CGFloat _delta = MAX(0.f , ceilf(_size.height - _mDrawingRect.size.height)) + 10 /* Security margin */;
					_mDrawingRect.origin.y -= _delta;
					_mDrawingRect.size.height += _delta;
				}
				if (self.centerVertically) {
					_mDrawingRect.origin.y -= (_mDrawingRect.size.height - _size.height) / 2;
				}
			}
			CGMutablePathRef _path = CGPathCreateMutable();
			CGPathAddRect(_path, NULL, _mDrawingRect);
			_mTextFrameRef = CTFramesetterCreateFrame(_frameSetterRef, CFRangeMake(0, 0), _path, NULL);
			CGPathRelease(_path);
			CFRelease(_frameSetterRef);
		}
		
		// draw highlights for activeLink
		if (_mActiveLink) {
			[self drawActiveLinkHighlightForRect:_mDrawingRect];
		}
		
		CTFrameDraw(_mTextFrameRef, _contextRef);
        
		CGContextRestoreGState(_contextRef);
	} 
    else {
		[super drawTextInRect:rect];
	}
}

- (void)setText:(NSString *)text{
    NSString* _cleanedText = [[text stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // will call setNeedsDisplay too
	[super setText:_cleanedText]; 
    
	[self resetAttributedText];
}

- (void)setTextColor:(UIColor *)textColor{
    [_mAttributedText setTextColor:textColor];
    
    // will call setNeedsDisplay too
	[super setTextColor:textColor]; 
}

- (void)setFont:(UIFont *)font{
    [_mAttributedText setFont:font];
    
    // will call setNeedsDisplay too
	[super setFont:font]; 
}

- (void)setTextAlignment:(UITextAlignment)textAlignment{
    CTTextAlignment _coreTextAlign = CTTextAlignmentFromUITextAlignment(textAlignment);
	CTLineBreakMode _coreTextLBM = CTLineBreakModeFromUILineBreakMode(self.lineBreakMode);
    
	[_mAttributedText setTextAlignment:_coreTextAlign lineBreakMode:_coreTextLBM];
	
    // will call setNeedsDisplay too
    [super setTextAlignment:textAlignment]; 
}

- (void)setLineBreakMode:(UILineBreakMode)lineBreakMode{
    CTTextAlignment _coreTextAlign = CTTextAlignmentFromUITextAlignment(self.textAlignment);
	CTLineBreakMode _coreTextLBM = CTLineBreakModeFromUILineBreakMode(lineBreakMode);
	
    [_mAttributedText setTextAlignment:_coreTextAlign lineBreakMode:_coreTextLBM];
	
    // will call setNeedsDisplay too
	[super setLineBreakMode:lineBreakMode]; 
	
#if OHAttributedLabel_WarnAboutKnownIssues
	[self warnAboutKnownIssues_CheckLineBreakMode];
#endif
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setAttributedText:(NSAttributedString *)attributedText{
	_mAttributedText = [attributedText mutableCopy];
    
	[self setAccessibilityLabel:_mAttributedText.string];
	
    [self removeAllCustomLinks];
	
    [self setNeedsDisplay];
}

- (NSAttributedString *)attributedText{
    if (!_mAttributedText) {
		[self resetAttributedText];
	}
    
    // immutable autoreleased copy
	return [_mAttributedText copy]; 
}

- (void)setAutomaticallyAddLinksForType:(NSTextCheckingTypes)automaticallyAddLinksForType{
    _mAutomaticallyAddLinksForType = automaticallyAddLinksForType;
    
	[self setNeedsDisplay];
}

- (void)setCenterVertically:(BOOL)centerVertically{
    _mCenterVertically = centerVertically;
    
	[self setNeedsDisplay];
}

- (void)setExtendBottomToFit:(BOOL)extendBottomToFit{
    _mExtendBottomToFit = extendBottomToFit;
    
	[self setNeedsDisplay];
}

-(void)resetAttributedText{
    // create mutable attributed string
    NSMutableAttributedString* _attributedString = [NSMutableAttributedString attributedStringWithString:self.text];
    
    // set font and text color
    [_attributedString setFont:self.font];
    [_attributedString setTextColor:self.textColor];
    
    // get text alignment and line break mode
    CTTextAlignment _coreTextAlign = CTTextAlignmentFromUITextAlignment(self.textAlignment);
    CTLineBreakMode _coreTextLBM = CTLineBreakModeFromUILineBreakMode(self.lineBreakMode);
    
    // set text alignment and line break mode
    [_attributedString setTextAlignment:_coreTextAlign lineBreakMode:_coreTextLBM];
    
    // reset attributed label attributed string
	self.attributedText = _attributedString;
}

- (void)addCustomLink:(NSURL *)pLinkUrl inRange:(NSRange)pRange{
    NSTextCheckingResult *_link = [NSTextCheckingResult linkCheckingResultWithRange:pRange URL:pLinkUrl];
    
	[_mCustomLinks addObject:_link];
    
	[self setNeedsDisplay];
}

- (void)removeAllCustomLinks{
    [_mCustomLinks removeAllObjects];
    
	[self setNeedsDisplay];
}

- (void)customInit{
    _mCustomLinks = [[NSMutableArray alloc] init];
	_mLinkColor = [UIColor blueColor];
	_mHighlightedLinkColor = [UIColor colorWithWhite:0.4 alpha:0.3];
	_mUnderlineLinks = YES;
	_mAutomaticallyAddLinksForType = NSTextCheckingTypeLink;
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel:0"]]) {
		_mAutomaticallyAddLinksForType |= NSTextCheckingTypePhoneNumber;
	}
	_mOnlyCatchTouchesOnLinks = YES;
    
	self.userInteractionEnabled = YES;
	self.contentMode = UIViewContentModeRedraw;
    
	[self resetAttributedText];
}

- (NSTextCheckingResult *)linkAtCharacterIndex:(CFIndex)pIndex{
    __block NSTextCheckingResult *_foundResult = nil;
	
	NSString *_plainText = [_mAttributedText string];
	if (_plainText && (self.automaticallyAddLinksForType > 0)) {
		NSError *_error = nil;
        
		NSDataDetector *_linkDetector = [NSDataDetector dataDetectorWithTypes:self.automaticallyAddLinksForType error:&_error];
        
		[_linkDetector enumerateMatchesInString:_plainText options:0 range:NSMakeRange(0, [_plainText length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            NSRange _range = [result range];
            if (NSLocationInRange(pIndex, _range)) {
                _foundResult = result;
                *stop = YES;
            }
        }];
        
        if (_foundResult) {
            return _foundResult;
        }
	}
	
	[_mCustomLinks enumerateObjectsUsingBlock:^(id obj, NSUInteger aidx, BOOL *stop) {
        NSRange _range = [(NSTextCheckingResult*)obj range];
        if (NSLocationInRange(pIndex, _range)) {
            _foundResult = obj;
            *stop = YES;
        }
    }];
    
    return _foundResult;
}

- (NSTextCheckingResult *)linkAtPoint:(CGPoint)pPoint{
    static const CGFloat _kVMargin = 5.f;
    
	if (!CGRectContainsPoint(CGRectInset(_mDrawingRect, 0, -_kVMargin), pPoint)) {
        return nil;
    }
	
	CFArrayRef _lines = CTFrameGetLines(_mTextFrameRef);
	if (!_lines) {
        return nil;
    }
    
	CFIndex _nbLines = CFArrayGetCount(_lines);
	NSTextCheckingResult *_link = nil;
	
	CGPoint _origins[_nbLines];
	CTFrameGetLineOrigins(_mTextFrameRef, CFRangeMake(0,0), _origins);
	
	for (int _index = 0 ; _index < _nbLines ; ++_index) {
		// this actually the origin of the line rect, so we need the whole rect to flip it
		CGPoint _lineOriginFlipped = _origins[_index];
		
		CTLineRef _line = CFArrayGetValueAtIndex(_lines, _index);
		CGRect _lineRectFlipped = CTLineGetTypographicBoundsAsRect(_line, _lineOriginFlipped);
		CGRect _lineRect = CGRectFlipped(_lineRectFlipped, CGRectFlipped(_mDrawingRect,self.bounds));
		
		_lineRect = CGRectInset(_lineRect, 0, _kVMargin);
		if (CGRectContainsPoint(_lineRect, pPoint)) {
			CGPoint _relativePoint = CGPointMake(pPoint.x-CGRectGetMinX(_lineRect),
												pPoint.y-CGRectGetMinY(_lineRect));
			CFIndex __index = CTLineGetStringIndexForPosition(_line, _relativePoint);
			_link = ([self linkAtCharacterIndex:__index]);
			if (_link) {
                return _link;
            }
		}
	}
	return nil;
}

- (NSMutableAttributedString *)attributedTextWithLinks{
    NSMutableAttributedString* _attributedString = [self.attributedText mutableCopy];
	if (!_attributedString) {
        return nil;
    }
	
	NSString *_plainText = _attributedString.string;
	if (_plainText && (self.automaticallyAddLinksForType > 0)) {
		NSError *_error = nil;
        
		NSDataDetector *_linkDetector = [NSDataDetector dataDetectorWithTypes:self.automaticallyAddLinksForType error:&_error];
        
		[_linkDetector enumerateMatchesInString:_plainText options:0 range:NSMakeRange(0, [_plainText length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            int32_t _uStyle = self.underlineLinks ? kCTUnderlineStyleSingle : kCTUnderlineStyleNone;
            UIColor *_thisLinkColor = (self.delegate && [self.delegate respondsToSelector:@selector(colorForLink:underlineStyle:)])
			 ? [self.delegate colorForLink:result underlineStyle:&_uStyle] : self.linkColor;
			 
            if (_thisLinkColor) {
                [_attributedString setTextColor:_thisLinkColor range:[result range]];
            }
				 
            if (_uStyle > 0) {
                [_attributedString setTextUnderlineStyle:_uStyle range:[result range]];
            }
        }];
    }
    
    [_mCustomLinks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSTextCheckingResult *_result = (NSTextCheckingResult *)obj;
		 
        int32_t _uStyle = self.underlineLinks ? kCTUnderlineStyleSingle : kCTUnderlineStyleNone;
        UIColor* _thisLinkColor = (self.delegate && [self.delegate respondsToSelector:@selector(colorForLink:underlineStyle:)])
		 ? [self.delegate colorForLink:_result underlineStyle:&_uStyle] : self.linkColor;
		 
        @try {
            if (_thisLinkColor) {
                [_attributedString setTextColor:_thisLinkColor range:[_result range]];
            }
            if (_uStyle>0) {
                [_attributedString setTextUnderlineStyle:_uStyle range:[_result range]];
            }
        }
        @catch (NSException *exception) {
            // protection against NSRangeException
            if ([[exception name] isEqualToString:NSRangeException]) {
                NSLog(@"[UIAttributedLabel] exception: %@", exception);
            } 
            else {
                @throw;
            }
        }
    }];
	
    return _attributedString;
}

- (void)resetTextFrame{
    if (_mTextFrameRef) {
		CFRelease(_mTextFrameRef);
        
		_mTextFrameRef = NULL;
	}
}

- (void)drawActiveLinkHighlightForRect:(CGRect)pRect{
    CGContextRef _contextRef = UIGraphicsGetCurrentContext();
	CGContextSaveGState(_contextRef);
	CGContextConcatCTM(_contextRef, CGAffineTransformMakeTranslation(pRect.origin.x, pRect.origin.y));
	[self.highlightedLinkColor setFill];
	
	NSRange _activeLinkRange = _mActiveLink.range;
	
	CFArrayRef _lines = CTFrameGetLines(_mTextFrameRef);
	CFIndex _lineCount = CFArrayGetCount(_lines);
	CGPoint _lineOrigins[_lineCount];
	CTFrameGetLineOrigins(_mTextFrameRef, CFRangeMake(0, 0), _lineOrigins);
	for (CFIndex _index = 0; _index < _lineCount; _index++) {
		CTLineRef _line = CFArrayGetValueAtIndex(_lines, _index);
		
		if (!CTLineContainsCharactersFromStringRange(_line, _activeLinkRange)) {
            // with next line
			continue; 
		}
		
		// we use this rect to union the bounds of successive runs that belong to the same active link
		CGRect _unionRect = CGRectZero;
		
		CFArrayRef _runs = CTLineGetGlyphRuns(_line);
		CFIndex _runCount = CFArrayGetCount(_runs);
		for (CFIndex __index = 0; __index < _runCount; __index++) {
			CTRunRef _run = CFArrayGetValueAtIndex(_runs, __index);
			
			if (!CTRunContainsCharactersFromStringRange(_run, _activeLinkRange)) {
				if (!CGRectIsEmpty(_unionRect)) {
					CGContextFillRect(_contextRef, _unionRect);
					_unionRect = CGRectZero;
				}
                // with next run
				continue; 
			}
			
			CGRect _linkRunRect = CTRunGetTypographicBoundsAsRect(_run, _line, _lineOrigins[_index]);
            // putting the rect on pixel edges
			_linkRunRect = CGRectIntegral(_linkRunRect);
            // increase the rect a little
			_linkRunRect = CGRectInset(_linkRunRect, -1, -1);	
			if (CGRectIsEmpty(_unionRect)) {
				_unionRect = _linkRunRect;
			} 
            else {
				_unionRect = CGRectUnion(_unionRect, _linkRunRect);
			}
		}
		if (!CGRectIsEmpty(_unionRect)) {
			CGContextFillRect(_contextRef, _unionRect);
			//unionRect = CGRectZero;
		}
	}
	CGContextRestoreGState(_contextRef);
}

#if OHAttributedLabel_WarnAboutKnownIssues
- (void)warnAboutKnownIssues_CheckLineBreakMode {
	BOOL _truncationMode = (self.lineBreakMode == UILineBreakModeHeadTruncation) || (self.lineBreakMode == UILineBreakModeMiddleTruncation) || (self.lineBreakMode == UILineBreakModeTailTruncation);
    
	if (_truncationMode) {
		NSLog(@"[UIAttributedLabel] Warning: \"UILineBreakMode...Truncation\" lineBreakModes not yet fully supported by CoreText and UIAttributedLabel");
		NSLog(@"                    (truncation will appear on each paragraph instead of the whole text)");
		NSLog(@"                    This is a known issue (Help to solve this would be greatly appreciated).");
		NSLog(@"                    See https://github.com/AliSoftware/OHAttributedLabel/issues/3");
	}
}

- (void)warnAboutKnownIssues_CheckAdjustsFontSizeToFitWidth {
	if (self.adjustsFontSizeToFitWidth) {
		NSLog(@"[OHAttributedLabel] Warning: \"adjustsFontSizeToFitWidth\" property not supported by CoreText and UIAttributedLabel! This property will be ignored.");
	}	
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth{
    [super setAdjustsFontSizeToFitWidth:adjustsFontSizeToFitWidth];
	[self warnAboutKnownIssues_CheckAdjustsFontSizeToFitWidth];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines{
    NSLog(@"[UIAttributedLabel] Warning: the numberOfLines property is not yet supported by CoreText and UIAttributedLabel. (this property is ignored right now)");
	NSLog(@"                    This is a known issue (Help to solve this would be greatly appreciated).");
	NSLog(@"                    See https://github.com/AliSoftware/OHAttributedLabel/issues/34");
    
	[super setNumberOfLines:numberOfLines];
}
#endif

@end
