//
//  HttpUtil.h
//  CommonToolkit
//
//  Created by  on 12-6-11.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    synchronous,
    asynchronous
} HTTPRequestType;


typedef enum {
    nonentity,
    urlEncoded,
    multipartFormData
} HttpPostFormat;


@interface HttpUtil : NSObject

// get http request
+ (void)getRequestWithUrl:(NSString *)pUrl andParameter:(NSDictionary *)pParameter andUserInfo:(NSDictionary *)pUserInfo andRequestType:(HTTPRequestType)pType andProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel;

// post http request
+ (void)postRequestWithUrl:(NSString *)pUrl andPostFormat:(HttpPostFormat)pPostFormat andParameter:(NSDictionary *)pParameter andUserInfo:(NSDictionary *)pUserInfo andRequestType:(HTTPRequestType)pType andProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel;

@end
