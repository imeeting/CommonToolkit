//
//  NSString+Extension.m
//  CommonToolkit
//
//  Created by  on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "NSString+Extension.h"

#import <CommonCrypto/CommonDigest.h>

#import "RegexKitLite.h"

@interface NSString (Private)

// multiplied by array
- (NSArray *)multipliedByArray:(NSArray *)pArray;

@end




@implementation NSString (Common)

- (BOOL)containsSubString:(NSString *)pString{
    BOOL _ret = NO;
    
    // define range
    NSRange _range = [[self lowercaseString] rangeOfString:[pString lowercaseString]];
    
    if (NSNotFound != _range.location) {
        _ret = YES;
    }
    
    return _ret;
}

- (NSArray *)toArrayWithSeparator:(NSString *)pSeparator{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // check separator
    if (!pSeparator || [pSeparator isEqualToString:@""]) {
        // traversal the string
        for (NSInteger _index = 0; _index < self.length; _index++) {
            [_ret addObject:[self substringWithRange:NSMakeRange(_index, 1)]];
        }
    }
    else {
        [_ret addObjectsFromArray:[self componentsSeparatedByString:pSeparator]];
    }
    
    return _ret;
}

- (NSString *)stringByTrimmingCharactersInString:(NSString *)pString{
    NSMutableString *_ret = [[NSMutableString alloc] init];
    
    NSArray *_separatedArray = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:pString]];
    
    for(NSString *_string in _separatedArray){
        [_ret appendString:_string];
    }
    
    return _ret;
}

- (NSString *)trimWhitespaceAndNewline{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray *)stringParagraphs{
    // string paragraphs array
    NSArray *_paragraphsArray = [self componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    //NSLog(@"string = %@, paragraphs array = %@ and count = %d", self, _paragraphsArray, [_paragraphsArray count]);
    
    return _paragraphsArray;
}

- (CGFloat)stringPixelLengthByFontSize:(CGFloat)pFontSize andIsBold:(BOOL)pBold{
    return [self sizeWithFont:pBold ? [UIFont boldSystemFontOfSize:pFontSize] : [UIFont systemFontOfSize:pFontSize]].width;
}

- (CGFloat)stringPixelHeightByFontSize:(CGFloat)pFontSize andIsBold:(BOOL)pBold{
    return [self sizeWithFont:pBold ? [UIFont boldSystemFontOfSize:pFontSize] : [UIFont systemFontOfSize:pFontSize]].height;
}

- (NSString *)md5{
    const char *cCharUTF8String = [self UTF8String];
    unsigned char _result[16];
    
    CC_MD5(cCharUTF8String, strlen(cCharUTF8String), _result);
    
    NSString *_ret = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", _result[0], _result[1], _result[2], _result[3], _result[4], _result[5], _result[6], _result[7], _result[8], _result[9], _result[10], _result[11], _result[12], _result[13], _result[14], _result[15]];
    
    //NSLog(@"string md5: orig string: %@ and after md5 = %@", _ret, [_ret uppercaseString]);
    
    return [_ret uppercaseString];
}

- (BOOL)isNil{
    BOOL _ret = NO;
    
    if (!self || [[self trimWhitespaceAndNewline] isEqualToString:@""]) {
        _ret = YES;
    }
    
    return _ret;
}

- (NSString *)perfectHttpRequestUrl{
    NSString *_ret;
    
    // check url is nil and has prefix "http://" or "https://"
    if (![self isNil] && ![self hasPrefix:@"http://"] && ![self hasPrefix:@"https://"]) {
        _ret = [NSString stringWithFormat:@"http://%@", self];
    }
    else {
        _ret = self;
    }
    
    return _ret;
}

@end




@implementation NSString (Contact)

- (NSArray *)splitToFirstAndOthers{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // check self
    if ([self isNil]) {
        NSLog(@"Error: nil or empty string mustn't split");
    }
    else if (self.length >= 2) {
        // get first letter and others
        NSString *_firstLetter = [self substringToIndex:1];
        NSString *_others = [self substringFromIndex:1];
        
        [_ret addObjectsFromArray:[_firstLetter multipliedByArray:[_others splitToFirstAndOthers]]];
    }
    else {
        [_ret addObject:self];
    }
    
    return _ret;
}

- (NSArray *)getAllPrefixes{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    for (NSInteger _index = 0; _index < self.length; _index++) {
        [_ret addObject:[self substringToIndex:_index + 1]];
    }
    
    return _ret;
}

- (NSArray *)toArraySeparatedByCharacter{
    NSMutableArray *_ret = [NSMutableArray arrayWithArray:[self componentsSeparatedByRegex:@"([A-Za-z0-9]*)"]];
    
    // all characters
    if (_ret && 0 == [_ret count] && ![self isNil]) {
        [_ret addObject:self];
    }
    else if (_ret && [_ret count] > 0) {
        // trim "" object
        for (NSInteger _index = 0; _index < [_ret count]; _index++) {
            if ([[_ret objectAtIndex:_index] isNil]) {
                [_ret removeObjectAtIndex:_index];
            }
        }
    }
    
    return _ret;
}

@end




@implementation NSString (Private)

- (NSArray *)multipliedByArray:(NSArray *)pArray{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];

    for (NSString *_string in pArray) {
        // x1 x2
        [_ret addObject:[NSString stringWithFormat:@"%@%@%@", self, SPLIT_SEPARATOR, _string]];
        // x1x2
        [_ret addObject:[NSString stringWithFormat:@"%@%@", self, _string]];
    }

    return _ret;
}

@end
