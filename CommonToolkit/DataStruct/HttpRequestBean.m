//
//  HttpRequestBean.m
//  CommonToolkit
//
//  Created by  on 12-6-16.
//  Copyright (c) 2012年 richitec. All rights reserved.
//

#import "HttpRequestBean.h"

#import <objc/message.h>

#import "HttpRequestManager.h"

#import "CommonUtils.h"

#import "NSBundle+Extension.h"

#import "ASIFormDataRequest.h"
#import "iToast.h"

// HttpRequestBean extension
@interface HttpRequestBean ()

// httpRequestBean did finished request
- (void)httpRequestDidFinishedRequest:(ASIHTTPRequest *)pRequest;

// httpRequestBean did failed request
- (void)httpRequestDidFailedRequest:(ASIHTTPRequest *)pRequest;

@end




@implementation HttpRequestBean

@synthesize processor = _processor;
@synthesize finishedRespSelector = _finishedRespSelector;
@synthesize failedRespSelector = _failedRespSelector;

+ (HttpRequestBean *)initWithProcessor:(id)pProcessor andFinishedRespSelector:(SEL)pFinRespSel andFailedRespSelector:(SEL)pFailRespSel{
    // create and init httpRequestBean object
    HttpRequestBean *_httpRequestObject = [[HttpRequestBean alloc] init];
    
    // set httpRequestBean attributes
    _httpRequestObject.processor = pProcessor;
    _httpRequestObject.finishedRespSelector = pFinRespSel;
    _httpRequestObject.failedRespSelector = pFailRespSel;
    
    return _httpRequestObject;
}

- (void)httpRequestDidFinishedRequest:(ASIHTTPRequest *)pRequest{
    // check processor and finished response selector
    if ([CommonUtils validateProcessor:self.processor andSelector:self.finishedRespSelector]) {
        // [self.processor performSelector:self.finishedRespSelector withObject:pRequest];
        objc_msgSend(self.processor, self.finishedRespSelector, pRequest);
    }
    else {
        NSLog(@"Warning : %@", self.processor ? [NSString stringWithFormat:@"http request object processor %@ can't implement did finished response method %@", NSStringFromClass([self.processor class]), NSStringFromSelector(self.finishedRespSelector)] : [NSString stringWithFormat:@"http request object processor is nil"]);
    }
    
    // remove self from http request bean dictionary
    [[HttpRequestManager shareHttpRequestManager] removeHttpRequestBeanForKey:[NSNumber numberWithInteger:[pRequest hash]]];
}

- (void)httpRequestDidFailedRequest:(ASIHTTPRequest *)pRequest{
    // check processor and failed response selector
    if ([CommonUtils validateProcessor:self.processor andSelector:self.failedRespSelector]) {
        // [self.processor performSelector:self.failedRespSelector withObject:pRequest];
        objc_msgSend(self.processor, self.failedRespSelector, pRequest);
    }
    // check http request object failed response selector, if nil use default http request did failed selector
    else if (self.processor && nil == self.failedRespSelector) {
        // get error
        NSError *_error = [pRequest error];
        NSLog(@"httpRequest object didFailed - request url = %@, error: %@, response data: %@", pRequest.url, _error, pRequest.responseData);
        
        // show default http request did failed toast
        [[iToast makeText:NSLocalizedStringFromCommonToolkitBundle(@"default http request did failed toast", nil)] show];
    }
    else {
        NSLog(@"Warning : %@", self.processor ? [NSString stringWithFormat:@"http request object processor %@ can't implement did failed response method %@", NSStringFromClass([self.processor class]), NSStringFromSelector(self.failedRespSelector)] : [NSString stringWithFormat:@"http request object processor is nil"]);
    }
    
    // remove self from http request bean dictionary
    [[HttpRequestManager shareHttpRequestManager] removeHttpRequestBeanForKey:[NSNumber numberWithInteger:[pRequest hash]]];
}

@end
