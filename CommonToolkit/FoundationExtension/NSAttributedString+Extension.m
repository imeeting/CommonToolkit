//
//  NSAttributedString+Extension.m
//  CommonToolkit
//
//  Created by  on 12-7-13.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "NSAttributedString+Extension.h"

// margin
#define MARGIN  1

@implementation NSAttributedString (ClassConstructors)

+ (id)attributedStringWithString:(NSString *)pString{
    return pString ? [[self alloc] initWithString:pString] : nil;
}

+ (id)attributedStringWithAttributedString:(NSAttributedString *)pAttributedString{
    return pAttributedString ? [[self alloc] initWithAttributedString:pAttributedString] : nil;
}

@end




@implementation NSAttributedString (ConstrainedSize)

- (CGSize)sizeConstrainedToSize:(CGSize)pMaxSize{
    return [self sizeConstrainedToSize:pMaxSize fitRange:NULL];
}

- (CGSize)sizeConstrainedToSize:(CGSize)pMaxSize fitRange:(NSRange *)pFitRange{
    // create self attributed string frame setter reference
    CTFramesetterRef _frameSetterRef = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);

    // get constrained frame size
    CFRange _fitCFRange = CFRangeMake(0, 0);
    CGSize _constrainedFrame = CTFramesetterSuggestFrameSizeWithConstraints(_frameSetterRef, CFRangeMake(0, 0), NULL, pMaxSize, &_fitCFRange);

    // check fit range parameter, if not NULL reset it
    if (pFitRange) {
        *pFitRange = NSMakeRange(_fitCFRange.location, _fitCFRange.length);
    }

    // release frame setter reference
    if (_frameSetterRef) {
        CFRelease(_frameSetterRef);
    }

    // take 1pt of margin for security
    return CGSizeMake(floorf(_constrainedFrame.width + MARGIN), floorf(_constrainedFrame.height + MARGIN));
}

@end




@implementation NSMutableAttributedString (CommodityAttributeModifiers)

- (void)setFont:(UIFont *)pFont{
    [self setFontName:pFont.fontName size:pFont.pointSize];
}

- (void)setFont:(UIFont *)pFont range:(NSRange)pRange{
    [self setFontName:pFont.fontName size:pFont.pointSize range:pRange];
}

- (void)setFontName:(NSString *)pFontName size:(CGFloat)pSize{
    [self setFontName:pFontName size:pSize range:NSMakeRange(0, [self length])];
}

- (void)setFontName:(NSString *)pFontName size:(CGFloat)pSize range:(NSRange)pRange{
    // kCTFontAttributeName
    // get font reference with font name and size
	CTFontRef _fontRef = CTFontCreateWithName((__bridge CFStringRef)pFontName, pSize, NULL);
    
    // get font reference succeed
	if (_fontRef) {
        // work around for Apple leak
        [self removeAttribute:(NSString *)kCTFontAttributeName range:pRange]; 
        [self addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)_fontRef range:pRange];
        
        // release font reference
        CFRelease(_fontRef);
    }
}

- (void)setFontFamily:(NSString *)pFontFamily size:(CGFloat)pSize bold:(BOOL)pIsBold italic:(BOOL)pIsItalic range:(NSRange)pRange{
    // kCTFontAttributeName
    // generate font traits dictionary
	NSDictionary *_fontTraitsDic = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:(pIsBold ? kCTFontBoldTrait : 0) | (pIsItalic ? kCTFontItalicTrait : 0)] forKey:(NSString *)kCTFontSymbolicTrait];
    
    // font attributes : kCTFontFamilyNameAttribute + kCTFontTraitsAttribute
    // generate font attributes dictionary
	NSDictionary *_fontAttributesDic = [NSDictionary dictionaryWithObjectsAndKeys:pFontFamily, kCTFontFamilyNameAttribute, _fontTraitsDic, kCTFontTraitsAttribute, nil];
	
    // get font descriptor reference with font attributes
	CTFontDescriptorRef _fontDescriptorRef = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)_fontAttributesDic);
    
    // get font descriptor succeed
	if (_fontDescriptorRef) {
        // get font reference with font descriptor
        CTFontRef _fontRef = CTFontCreateWithFontDescriptor(_fontDescriptorRef, pSize, NULL);
        
        // get font reference succeed
        if (_fontRef) {
            // work around for Apple leak
            [self removeAttribute:(NSString *)kCTFontAttributeName range:pRange]; 
            [self addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)_fontRef range:pRange];
            
            // release font reference 
            CFRelease(_fontRef);
        }
        
        // release font descriptor reference
        CFRelease(_fontDescriptorRef);
    }
}

- (void)setTextBold:(BOOL)pIsBold range:(NSRange)pRange{
    // kCTFontAttributeName
    [self setTextFontSymbolicTraits:pIsBold ? kCTFontBoldTrait : 0 range:pRange];
}

- (void)setTextItalic:(BOOL)pItalic range:(NSRange)pRange{
    // kCTFontAttributeName
    [self setTextFontSymbolicTraits:pItalic ? kCTFontItalicTrait : 0 range:pRange];
}

- (void)setTextFontSymbolicTraits:(CTFontSymbolicTraits)pFontSymbolicTraits range:(NSRange)pRange{
    // kCTFontAttributeName
    // get start point and effective range
    NSUInteger _startPoint = pRange.location;
	NSRange _effectiveRange;
    
	do {
		// get font reference at start point and in effective range 
		CTFontRef _existedFontRef = (__bridge CTFontRef)[self attribute:(NSString *)kCTFontAttributeName atIndex:_startPoint effectiveRange:&_effectiveRange];
        
		// get the intersection range for which this font is effective
		NSRange _intersectionRange = NSIntersectionRange(pRange, _effectiveRange);
		
        // get font reference for this font and apply
		CTFontRef _fontRef = CTFontCreateCopyWithSymbolicTraits(_existedFontRef, 0.0, NULL, pFontSymbolicTraits, pFontSymbolicTraits);
        
        // get font reference succeed
		if (_fontRef) {
            // work around for Apple leak
			[self removeAttribute:(NSString *)kCTFontAttributeName range:_intersectionRange]; 
			[self addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)_fontRef range:_intersectionRange];
            
            // release font reference
			CFRelease(_fontRef);
		} 
        else {
			NSLog(@"Warning: can't find the font reference for font %@, try another font family (like Helvetica) instead", (__bridge NSString *)CTFontCopyFullName(_existedFontRef));
		}
        
		// if the font range was not covering the whole range, continue with next run
		_startPoint = NSMaxRange(_effectiveRange);
	} while(_startPoint < NSMaxRange(pRange));
}

- (void)setTextColor:(UIColor *)pColor{
    [self setTextColor:pColor range:NSMakeRange(0, [self length])];
}

- (void)setTextColor:(UIColor *)pColor range:(NSRange)pRange{
    // kCTForegroundColorAttributeName
    // work around for Apple leak
    [self removeAttribute:(NSString *)kCTForegroundColorAttributeName range:pRange];
	[self addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)pColor.CGColor range:pRange];
}

- (void)setTextUnderline:(BOOL)pIsUnderline{
    [self setTextUnderline:pIsUnderline range:NSMakeRange(0, [self length])];
}

- (void)setTextUnderline:(BOOL)pIsUnderline range:(NSRange)pRange{
    // set default underLine style: kCTUnderlineStyleSingle + kCTUnderlinePatternSolid
	[self setTextUnderlineStyle:pIsUnderline ? (kCTUnderlineStyleSingle | kCTUnderlinePatternSolid) : kCTUnderlineStyleNone range:pRange];
}

- (void)setTextUnderlineStyle:(CTUnderlineStyle)pStyle range:(NSRange)pRange{
    // kCTUnderlineStyleAttributeName
    // work around for Apple leak
    [self removeAttribute:(NSString *)kCTUnderlineStyleAttributeName range:pRange];
	[self addAttribute:(NSString *)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:pStyle] range:pRange];
}

- (void)setTextAlignment:(CTTextAlignment)pAlignment lineBreakMode:(CTLineBreakMode)pLineBreakMode{
    [self setTextAlignment:pAlignment lineBreakMode:pLineBreakMode range:NSMakeRange(0, [self length])];
}

- (void)setTextAlignment:(CTTextAlignment)pAlignment lineBreakMode:(CTLineBreakMode)pLineBreakMode range:(NSRange)pRange{
    // kCTParagraphStyleAttributeName
    // paragraph style: kCTParagraphStyleSpecifierAlignment + kCTParagraphStyleSpecifierLineBreakMode
	CTParagraphStyleSetting _paragraphStyleSettings[2] = {{.spec = kCTParagraphStyleSpecifierAlignment, .valueSize = sizeof(CTTextAlignment), .value = (const void*)&pAlignment}, {.spec = kCTParagraphStyleSpecifierLineBreakMode, .valueSize = sizeof(CTLineBreakMode), .value = (const void*)&pLineBreakMode}};
    
    // get paragraph style reference
	CTParagraphStyleRef _paragraphStyleRef = CTParagraphStyleCreate(_paragraphStyleSettings, sizeof(_paragraphStyleSettings) / sizeof(*_paragraphStyleSettings));
    
    // get paragraph reference succeed
    if (_paragraphStyleRef) {
        // work around for Apple leak
        [self removeAttribute:(NSString *)kCTParagraphStyleAttributeName range:pRange];
        [self addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(__bridge id)_paragraphStyleRef range:pRange];
        
        // release paragraph style reference
        CFRelease(_paragraphStyleRef);
    }
}

@end
