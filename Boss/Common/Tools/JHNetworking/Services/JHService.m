//
//  JHService.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHService.h"

@implementation JHService

- (instancetype)init{
    if (self = [super init]) {
        NSAssert([self conformsToProtocol:@protocol(JHServiceProtocol)], @"must conform to 'JHServiceProtocol' ");
        self.child = (id<JHServiceProtocol>)self;
    }
    return self;
}

- (BOOL)isOnline{
    return AppIsOnline();
}

- (NSString *)apiBaseUrl{
    NSString * baseUrl = JHBaseServiceURL();
    
    if (self.isOnline) {
        if ([self.child respondsToSelector:@selector(onlineApiBaseUrl)]) {
            baseUrl = [self.child onlineApiBaseUrl];
        }else if ([self.child respondsToSelector:@selector(onlineApiCategory)]){
            baseUrl = [baseUrl stringByAppendingPathComponent:[self.child onlineApiCategory]];
        }
    }else{
        if ([self.child respondsToSelector:@selector(offlineApiBaseUrl)]) {
            baseUrl = [self.child offlineApiBaseUrl];
        }else if ([self.child respondsToSelector:@selector(offlineApiCategory)]){
            baseUrl = [baseUrl stringByAppendingPathComponent:[self.child offlineApiCategory]];
        }
    }
    return baseUrl;
}

- (NSString *)apiVersion{
    NSString * apiVersion = JHBaseServiceVersion();
    if (self.isOnline && [self.child respondsToSelector:@selector(onlineApiVersion)]) {
        apiVersion = [self.child onlineApiVersion];
    }else if (!self.isOnline && [self.child respondsToSelector:@selector(offlineApiVersion)]){
        apiVersion = [self.child offlineApiVersion];
    }
    return apiVersion;
}

@end

