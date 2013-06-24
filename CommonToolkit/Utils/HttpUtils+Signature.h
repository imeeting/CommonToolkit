//
//  HttpUtils+Signature.h
//  CommonToolkit
//
//  Created by Ares on 12-6-15.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "HttpUtils.h"

@interface HttpUtils (Signature)

// get signature http request
+ (void)getSignatureRequestWithUrl:(NSString *)pUrl andParameter:(NSDictionary *)pParameter andUserInfo:(NSDictionary *)pUserInfo andRequestType:(HTTPRequestType)pType andProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel;

// post signature http request
+ (void)postSignatureRequestWithUrl:(NSString *)pUrl andPostFormat:(HttpPostFormat)pPostFormat andParameter:(NSMutableDictionary *)pParameter andUserInfo:(NSDictionary *)pUserInfo andRequestType:(HTTPRequestType)pType andProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel;

@end
