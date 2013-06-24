//
//  NSAttributedString+Extension.h
//  CommonToolkit
//
//  Created by Ares on 12-7-13.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreText/CoreText.h>

// static class constructor
@interface NSAttributedString (ClassConstructors)

// create attributed string with string
+ (id)attributedStringWithString:(NSString *)pString;

// create attributed string with other attributed string
+ (id)attributedStringWithAttributedString:(NSAttributedString *)pAttributedString;

@end




// constrained size
@interface NSAttributedString (ConstrainedSize)

// commodity method that call the following method:(CGSize)sizeConstrainedToSize:fitRange: with NULL for the fitRange parameter
- (CGSize)sizeConstrainedToSize:(CGSize)pMaxSize;

// get NSAttributedString constrained size, if fit range is not NULL, on return it will contain the used range that actually fits the constrained size. Note: Use CGFLOAT_MAX for the CGSize's height if you don't want a constraint for the height
- (CGSize)sizeConstrainedToSize:(CGSize)pMaxSize fitRange:(NSRange *)pFitRange;

@end




// convenient and efficient attribute modifier
@interface NSMutableAttributedString (CommodityAttributeModifiers)

// set font
- (void)setFont:(UIFont *)pFont;
- (void)setFont:(UIFont *)pFont range:(NSRange)pRange;
- (void)setFontName:(NSString *)pFontName size:(CGFloat)pSize;
- (void)setFontName:(NSString *)pFontName size:(CGFloat)pSize range:(NSRange)pRange;
- (void)setFontFamily:(NSString *)pFontFamily size:(CGFloat)pSize bold:(BOOL)pIsBold italic:(BOOL)pIsItalic range:(NSRange)pRange;

// set text bold
- (void)setTextBold:(BOOL)pIsBold range:(NSRange)pRange;
// set text italic
- (void)setTextItalic:(BOOL)pItalic range:(NSRange)pRange;
// set text font symbolic traits
- (void)setTextFontSymbolicTraits:(CTFontSymbolicTraits)pFontSymbolicTraits range:(NSRange)pRange;

// set text color
- (void)setTextColor:(UIColor *)pColor;
- (void)setTextColor:(UIColor *)pColor range:(NSRange)pRange;

// set text underline and style
- (void)setTextUnderline:(BOOL)pIsUnderline;
- (void)setTextUnderline:(BOOL)pIsUnderline range:(NSRange)pRange;
// underline style is a combination of CTUnderlineStyle and CTUnderlineStyleModifiers
- (void)setTextUnderlineStyle:(CTUnderlineStyle)pStyle range:(NSRange)pRange; 

// set text alignment and lineBreak mode
- (void)setTextAlignment:(CTTextAlignment)pAlignment lineBreakMode:(CTLineBreakMode)pLineBreakMode;
- (void)setTextAlignment:(CTTextAlignment)pAlignment lineBreakMode:(CTLineBreakMode)pLineBreakMode range:(NSRange)pRange;

@end
