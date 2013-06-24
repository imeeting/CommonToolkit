//
//  HttpUtils+Signature.m
//  CommonToolkit
//
//  Created by Ares on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "HttpUtils+Signature.h"

#import "NSString+Extension.h"
#import "NSArray+Extension.h"
#import "CommonUtils.h"
#import "UserManager.h"

// user name parameter key
#define USERNAME_PARAMETER_KEY    @"username"
// signature parameter key
#define SIGNATURE_PARAMETER_KEY    @"sig"

@implementation HttpUtils (Signature)

// generate signature with request parameter
+ (NSString *)generateSignatureWithParameter:(NSDictionary *)pParameter{
    // create need to signature parameter data array
    NSMutableArray *_parameterDataArray = [[NSMutableArray alloc] init];
    
    // init need to signature parameter data array
    [pParameter enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        [_parameterDataArray addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    
    // append user name to post body data array and add to http request post body
    [_parameterDataArray addObject:[NSString stringWithFormat:@"%@=%@", USERNAME_PARAMETER_KEY, [[[UserManager shareUserManager] userBean] name]]];
    NSLog(@"post body data array = %@", _parameterDataArray);
    
    // sort parameter data array
    NSMutableArray *_sortedParameterDataArray = [[NSMutableArray alloc] initWithArray:[_parameterDataArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]];
    NSLog(@"sorted post body data array = %@", _sortedParameterDataArray);
    
    // append userKey to sort parameter data array
    if([[[UserManager shareUserManager] userBean] userKey]){
        [_sortedParameterDataArray addObject:[[[UserManager shareUserManager] userBean] userKey]];
    }
    NSLog(@"after append user key, sorted post body data array = %@", _sortedParameterDataArray);
    
    // generate signature
    NSString *_signature = [[_sortedParameterDataArray toStringWithSeparator:nil] md5];
    NSLog(@"the signature is %@", _signature);
    
    return _signature;
}

+ (void)getSignatureRequestWithUrl:(NSString *)pUrl andParameter:(NSDictionary *)pParameter andUserInfo:(NSDictionary *)pUserInfo andRequestType:(HTTPRequestType)pType andProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel{
    // create and init signature get request parameter
    NSMutableDictionary *_signatureGetRequestParameter = [NSMutableDictionary dictionaryWithDictionary:pParameter];
    
    // append user name to get request url
    [_signatureGetRequestParameter setObject:[[[UserManager shareUserManager] userBean] name] forKey:USERNAME_PARAMETER_KEY];
    // add signature to get request url
    [_signatureGetRequestParameter setObject:[self generateSignatureWithParameter:pParameter] forKey:SIGNATURE_PARAMETER_KEY];
    
    // send get request
    [self getRequestWithUrl:pUrl andParameter:_signatureGetRequestParameter andUserInfo:pUserInfo andRequestType:pType andProcessor:pProcessor andFinishedRespSelector:pFinRespSel andFailedRespSelector:pFailRespSel];
}

+ (void)postSignatureRequestWithUrl:(NSString *)pUrl andPostFormat:(HttpPostFormat)pPostFormat andParameter:(NSMutableDictionary *)pParameter andUserInfo:(NSDictionary *)pUserInfo andRequestType:(HTTPRequestType)pType andProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel{
    // check parameter
    pParameter = pParameter ? pParameter : [[NSMutableDictionary alloc] init];
    
    // add signature to post parameter
    [pParameter setObject:[self generateSignatureWithParameter:pParameter] forKey:SIGNATURE_PARAMETER_KEY];
    // append user name to post parameter
    [pParameter setObject:[[[UserManager shareUserManager] userBean] name] forKey:USERNAME_PARAMETER_KEY];
    
    // send post request
    [self postRequestWithUrl:pUrl andPostFormat:pPostFormat andParameter:pParameter andUserInfo:pUserInfo andRequestType:pType andProcessor:pProcessor andFinishedRespSelector:pFinRespSel andFailedRespSelector:pFailRespSel];
}

@end
