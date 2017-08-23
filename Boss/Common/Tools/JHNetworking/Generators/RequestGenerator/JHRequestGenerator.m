//
//  JHRequestGenerator.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHRequestGenerator.h"
#import "JHService.h"
#import "JHServiceFactory.h"
#import <AFNetworking/AFNetworking.h>
#import "JHNetworkingConfiguration.h"
#import "NSURLRequest+JHRequestParams.h"

@interface JHRequestGenerator()

@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation JHRequestGenerator

+ (instancetype)sharedInstance{
    static JHRequestGenerator *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JHRequestGenerator alloc]init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    JHService *service = [[JHServiceFactory shareInstance]serviceWithIdentifier:serviceIdentifier];
    NSString *urlString;
    if (isObjNotEmpty(service.apiVersion)) {
        urlString = [NSString stringWithFormat:@"%@/%@/%@",service.apiBaseUrl,service.apiVersion,methodName];
    }else{
        urlString = [NSString stringWithFormat:@"%@/%@",service.apiBaseUrl,methodName];
    }
//    [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxx"]; 设置 UUID
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:requestParams error:nil];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    JHService *service = [[JHServiceFactory shareInstance]serviceWithIdentifier:serviceIdentifier];
    NSString *urlString;
    if (isObjNotEmpty(service.apiVersion)) {
        urlString = [NSString stringWithFormat:@"%@/%@/%@",service.apiBaseUrl,service.apiVersion,methodName];
    }else{
        urlString = [NSString stringWithFormat:@"%@/%@",service.apiBaseUrl,methodName];
    }
//     [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generatePutRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    JHService *service = [[JHServiceFactory shareInstance]serviceWithIdentifier:serviceIdentifier];
    NSString *urlString;
    if (isObjNotEmpty(service.apiVersion)) {
        urlString = [NSString stringWithFormat:@"%@/%@/%@",service.apiBaseUrl,service.apiVersion,methodName];
    }else{
        urlString = [NSString stringWithFormat:@"%@/%@",service.apiBaseUrl,methodName];
    }
//    [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"PUT" URLString:urlString parameters:requestParams error:NULL];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    request.requestParams = requestParams;
    return request;
}

- (NSURLRequest *)generateDeleteRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    JHService *service = [[JHServiceFactory shareInstance]serviceWithIdentifier:serviceIdentifier];
    NSString *urlString;
    if (isObjNotEmpty(service.apiVersion)) {
        urlString = [NSString stringWithFormat:@"%@/%@/%@",service.apiBaseUrl,service.apiVersion,methodName];
    }else{
        urlString = [NSString stringWithFormat:@"%@/%@",service.apiBaseUrl,methodName];
    }
    //    [self.httpRequestSerializer setValue:[[NSUUID UUID] UUIDString] forHTTPHeaderField:@"xxxxxxxx"];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"DELETE" URLString:urlString parameters:requestParams error:NULL];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    request.requestParams = requestParams;
    return request;
}

#pragma mark - setter / getter
- (AFHTTPRequestSerializer *)httpRequestSerializer{
    if (isObjEmpty(_httpRequestSerializer)) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = kJHNetworkingTimeoutSeconds;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}

@end
