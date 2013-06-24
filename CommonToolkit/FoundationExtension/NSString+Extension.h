//
//  NSString+Extension.h
//  CommonToolkit
//
//  Created by Ares on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

// contains sub string
- (BOOL)containsSubString:(NSString *)pString;

// range array of string
- (NSArray *)rangesOfString:(NSString *)pString;

// string to array with separated string
- (NSArray *)toArrayWithSeparator:(NSString *)pSeparator;

// string by trimming characters in string
- (NSString *)stringByTrimmingCharactersInString:(NSString *)pString;

// trim whitespace and new line character
- (NSString *)trimWhitespaceAndNewline;

// get paragraphs array of the string, according to '\n'
- (NSArray *)stringParagraphs;

// get string pixel length with string font size and it is bold
- (CGFloat)stringPixelLengthByFontSize:(CGFloat)pFontSize andIsBold:(BOOL) pBold;

// get string pixel height with string font size and it is bold
- (CGFloat)stringPixelHeightByFontSize:(CGFloat)pFontSize andIsBold:(BOOL) pBold;

// string md5
- (NSString *)md5;

// is nil
- (BOOL)isNil;

// perfect http request url
- (NSString *)perfectHttpRequestUrl;

@end
