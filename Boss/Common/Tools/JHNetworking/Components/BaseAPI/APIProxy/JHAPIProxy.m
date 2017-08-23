//
//  JHAPIProxy.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHAPIProxy.h"
#import "JHRequestGenerator.h"
#import <AFNetworking.h>


@interface JHAPIProxy()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation JHAPIProxy

#pragma mark - life cycle
+ (instancetype)sharedInstance{
    static JHAPIProxy *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JHAPIProxy alloc]init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(JHCallback)success fail:(JHCallback)fail{
    NSURLRequest *request = [[JHRequestGenerator sharedInstance]generateGETRequestWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName];
    return [[self callApiWithRequest:request success:success fail:fail] integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(JHCallback)success fail:(JHCallback)fail{
    NSURLRequest *request = [[JHRequestGenerator sharedInstance]generatePOSTRequestWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName];
    return [[self callApiWithRequest:request success:success fail:fail] integerValue];
}
- (NSInteger)callPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(JHCallback)success fail:(JHCallback)fail{
    NSURLRequest *request = [[JHRequestGenerator sharedInstance]generatePutRequestWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName];
    return [[self callApiWithRequest:request success:success fail:fail] integerValue];
}

- (NSInteger)callDELETEWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName success:(JHCallback)success fail:(JHCallback)fail{
    NSURLRequest *request = [[JHRequestGenerator sharedInstance]generateDeleteRequestWithServiceIdentifier:serviceIdentifier requestParams:params methodName:methodName];
    return [[self callApiWithRequest:request success:success fail:fail] integerValue];
}

/** 这个函数存在的意义在于，如果将来要把AFNetworking换掉，只要修改这个函数的实现即可。 */
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(JHCallback)success fail:(JHCallback)fail{
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if (error) {
            JHURLResponse *response = [[JHURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData error:error];
            fail?fail(response):nil;
        } else {
            // 检查http response是否成立。
            JHURLResponse *CTResponse = [[JHURLResponse alloc] initWithResponseString:responseString requestId:requestID request:request responseData:responseData status:JHURLResponseStatusSuccess];
            success?success(CTResponse):nil;
        }
    }];
    NSNumber *requestId = @([dataTask taskIdentifier]);
    self.dispatchTable[requestId] = dataTask;
    return requestId;
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID{
    NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList{
    for (NSNumber * requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

#pragma mark - setter / getter
- (NSMutableDictionary *)dispatchTable{
    if (isObjEmpty(_dispatchTable)) {
        _dispatchTable = [NSMutableDictionary dictionary];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager{
    if (isObjEmpty(_sessionManager)) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}



@end
