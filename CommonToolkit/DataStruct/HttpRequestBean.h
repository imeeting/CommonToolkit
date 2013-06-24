//
//  HttpRequestBean.h
//  CommonToolkit
//
//  Created by Ares on 12-6-16.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestBean : NSObject

// http request processor
@property (nonatomic, retain) id processor;
// http request finished response selector
@property (nonatomic, readwrite) SEL finishedRespSelector;
// http request failed response selector
@property (nonatomic, readwrite) SEL failedRespSelector;

// init with processor, finishedRespSelector and failedRespSelector
+ (HttpRequestBean *)initWithProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel;

@end
