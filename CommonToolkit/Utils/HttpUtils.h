//
//  HttpUtils.h
//  CommonToolkit
//
//  Created by Ares on 12-6-11.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

// http request type
typedef enum {
    synchronous,
    asynchronous
} HTTPRequestType;


// http post format, nonentity for get request, mustn't use for post request
typedef enum {
    nonentity,
    urlEncoded,
    multipartFormData
} HttpPostFormat;


@interface HttpUtils : NSObject

// get http request
+ (void)getRequestWithUrl:(NSString *)pUrl andParameter:(NSDictionary *)pParameter andUserInfo:(NSDictionary *)pUserInfo andRequestType:(HTTPRequestType)pType andProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel;

// post http request
+ (void)postRequestWithUrl:(NSString *)pUrl andPostFormat:(HttpPostFormat)pPostFormat andParameter:(NSDictionary *)pParameter andUserInfo:(NSDictionary *)pUserInfo andRequestType:(HTTPRequestType)pType andProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel;

@end
