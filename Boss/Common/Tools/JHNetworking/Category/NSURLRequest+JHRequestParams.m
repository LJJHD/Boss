//
//  NSURLRequest+JHRequestParams.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "NSURLRequest+JHRequestParams.h"
#import <objc/runtime.h>

static void *kJHNetworkingRequestParams = &kJHNetworkingRequestParams;

@implementation NSURLRequest (JHRequestParams)

- (void)setRequestParams:(NSDictionary *)requestParams{
    objc_setAssociatedObject(self, kJHNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams{
    return objc_getAssociatedObject(self, kJHNetworkingRequestParams);
}

@end
