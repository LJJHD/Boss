//
//  JHBaseAPIManager.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseAPIManager.h"
#import "JHCache.h"
#import "JHServiceFactory.h"
#import "JHAPIProxy.h"
#import "JHReachabilityManager.h"

@interface JHBaseAPIManager()

@property (strong, nonatomic) id fetchedRawData;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, assign) BOOL isNativeDataEmpty;

@property (nonatomic, readwrite) JHAPIManagerStatusType statusType;
@property (nonatomic, strong) NSMutableArray *requestIdList;
@property (assign, nonatomic, readonly, getter=isReachable) BOOL reachable;
@property (nonatomic, strong) JHCache *cache;

@end

const NSString * kJHAPIBaseManagerRequestID = @"kJHAPIBaseManagerRequestID";

@implementation JHBaseAPIManager

#pragma mark - life cycle
- (instancetype)init{
    if (self = [super init]) {
        NSAssert([self conformsToProtocol:@protocol(JHAPIManagerProtocol)], @"sub class must conforms 'JHAPIManagerProtocol'");
        _statusType = JHAPIManagerStatus_Default;
        self.child = (id<JHAPIManagerProtocol>)self;
    }
    return self;
}

- (void)dealloc{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - public method

- (void)cleanData{
    [self.cache clean];
    self.fetchedRawData = nil;
    self.statusType = JHAPIManagerStatus_Default;
}

- (void)cancelAllRequests{
    [[JHAPIProxy sharedInstance]cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID{
    [self removeRequestIdWithRequestID:requestID];
    [[JHAPIProxy sharedInstance]cancelRequestWithRequestID:@(requestID)];
}

#pragma mark - calling api
- (NSInteger)loadData{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    NSInteger requestID = [self loadDataWithParams:params];
    return requestID;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params{
    NSInteger requestID = 0;
    if ([self shouldCallAPIWithParams:params]) {
        if ([self isCorrectParams:params]) {
            if ([self shouldLoadFromNative]) {
                [self loadDataFromNative];
            }
            if ([self shouldCache] && [self hasCacheWithParams:params]) {//先检查下是否有缓存
                return requestID;
            }
            if (self.isReachable) {
                self.isLoading = YES;
                JHAPIProxy * proxy = [JHAPIProxy sharedInstance];
                __weak typeof(self) weakSelf = self;
                void (^successBlock)(JHURLResponse *response) = ^(JHURLResponse *response){
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf successedOnCallingAPI:response];
                };
                void (^failBlock)(JHURLResponse *response) = ^(JHURLResponse *response){
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    [strongSelf failedOnCallingAPI:response withErrorType:JHAPIManagerStatus_Default];
                };
                
                switch (self.child.requestType) {
                    case JHAPIManagerRequestTypeGet:
                        requestID = [proxy callGETWithParams:params serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:successBlock fail:failBlock];
                        break;
                    case JHAPIManagerRequestTypePost:
                        requestID = [proxy callPOSTWithParams:params serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:successBlock fail:failBlock];
                        break;
                    case JHAPIManagerRequestTypePut:
                        requestID = [proxy callPUTWithParams:params serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:successBlock fail:failBlock];
                        break;
                    case JHAPIManagerRequestTypeDelete:
                        requestID = [proxy callDELETEWithParams:params serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:successBlock fail:failBlock];
                        break;
                    default:
                        break;
                }
                [self.requestIdList addObject:@(requestID)];
                NSMutableDictionary *paramsToChild = [params mutableCopy];
                paramsToChild[kJHAPIBaseManagerRequestID] = @(requestID);
                [self afterCallingAPIWithParams:params];
                return requestID;
            }else{
                [self failedOnCallingAPI:nil withErrorType:JHAPIManagerStatus_NoNetWork];
            }
        }else{
            [self failedOnCallingAPI:nil withErrorType:JHAPIManagerStatus_ParamsError];
        }
    }
    return requestID;
}

#pragma mark - api callbacks
- (void)successedOnCallingAPI:(JHURLResponse *)response{
    self.isLoading = NO;
    self.response = response;
    
    if ([self shouldLoadFromNative]) {
        if (response.isCache == NO) {
            [[NSUserDefaults standardUserDefaults] setObject:response.responseData forKey:[self.child methodName]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if (isObjNotEmpty(response.content)) {
        self.fetchedRawData = [response.content copy];
    }else{
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validator respondsToSelector:@selector(manager:isCorrectWithCallBackData:)]) {
        if ([self.validator manager:self isCorrectWithCallBackData:response.content]) {
            if (!response.isCache && [self shouldCache]) {
                [self.cache saveCacheWithData:response.responseData serviceIdentifier:self.child.serviceType methodName:self.child.methodName requestParams:response.requestParams];
            }
            if ([self beforePerformSuccessWithResponse:response]) {
                [self.delegate managerCallAPIDidSuccess:self];
            }
            [self afterPerformSuccessWithResponse:response];
        }else{
             [self failedOnCallingAPI:response withErrorType:JHAPIManagerStatus_NoContent];
        }
    }
}

- (void)failedOnCallingAPI:(JHURLResponse *)response withErrorType:(JHAPIManagerStatusType)errorType{
    self.isLoading = NO;
    self.response = response;
    self.statusType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self beforePerformFailWithResponse:response]) {
        
    }
    [self afterPerformFailWithResponse:response];
}

#pragma mark - method for interceptor

- (BOOL)beforePerformSuccessWithResponse:(JHURLResponse *)response{
    BOOL result = YES;
    self.statusType = JHAPIManagerStatus_Success;
    if ([self.interceptor respondsToSelector:@selector(manager: beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(JHURLResponse *)response{
    if ([self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailWithResponse:(JHURLResponse *)response{
    BOOL result = YES;
    if ([self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailWithResponse:(JHURLResponse *)response{
    if ([self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params{
    if ([self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    }
    return YES;
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params{
    if ([self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

- (BOOL)isCorrectParams:(NSDictionary *)params{
    if ([self.validator respondsToSelector:@selector(manager:isCorrectWithParamsData:)]) {
        return [self.validator manager:self isCorrectWithParamsData:params];
    }
    return YES;
}

- (BOOL)shouldCache{
    return YES;
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params{
    NSString *serviceIdentifier = self.child.serviceType;
    NSString *methodName = self.child.methodName;
    NSData *result = [self.cache fetchCachedDataWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params];
    
    if (result == nil) {
        return NO;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof (weakSelf) strongSelf = weakSelf;
        JHURLResponse *response = [[JHURLResponse alloc] initWithData:result];
        response.requestParams = params;
        [strongSelf successedOnCallingAPI:response];
    });
    return YES;
}

- (void)loadDataFromNative{
    NSString *methodName = self.child.methodName;
    NSDictionary *result = (NSDictionary *)[[NSUserDefaults standardUserDefaults] objectForKey:methodName];
    
    if (result) {
        self.isNativeDataEmpty = NO;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            JHURLResponse *response = [[JHURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:result options:0 error:NULL]];
            [strongSelf successedOnCallingAPI:response];
        });
    } else {
        self.isNativeDataEmpty = YES;
    }
}

- (BOOL)shouldLoadFromNative{
    return NO;
}

#pragma mark - setter / getter
- (BOOL)isLoading{
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}

- (BOOL)isReachable{
    BOOL isReachability = [JHReachabilityManager shareManager].isReachable;
    if (!isReachability) {
        self.statusType = JHAPIManagerStatus_NoNetWork;
    }
    return isReachability;
}

- (NSMutableArray *)requestIdList{
    if (isObjEmpty(_requestIdList)) {
        _requestIdList = [NSMutableArray array];
    }
    return _requestIdList;
}
@end
