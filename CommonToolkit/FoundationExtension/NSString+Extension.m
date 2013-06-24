//
//  NSString+Extension.m
//  CommonToolkit
//
//  Created by Ares on 12-6-7.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "NSString+Extension.h"

#import <CommonCrypto/CommonDigest.h>

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

- (NSArray *)rangesOfString:(NSString *)pString{
    NSMutableArray *_ret = [[NSMutableArray alloc] init];
    
    // define parent string
    NSString *_parentString = self;
    
    // define parent string location in self string
    NSInteger _parentStringLocation = 0;
    
    // define range of paramter string in parent string
    NSRange _range = NSMakeRange(0, 0);
    
    // get ranges
    do {
        // reset range
        _range = [_parentString rangeOfString:pString];
        
        // parameter string found in parent string
        if (NSNotFound != _range.location) {
            // reset parent string
            _parentString = [_parentString substringFromIndex:_range.location + _range.length];
            
            // add ranges to return result
            [_ret addObject:NSStringFromRange(NSMakeRange(_parentStringLocation + _range.location, _range.length))];
            
            // save parent string location in self string
            _parentStringLocation += _range.location + _range.length;
        }
    } while (0 != _range.length && _range.length <= _parentString.length);
    
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
