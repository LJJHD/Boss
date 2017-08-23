//
//  JHBaseAPIManager.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHURLResponse.h"

@class JHBaseAPIManager;

extern const NSString * kJHAPIBaseManagerRequestID;

// api 落地后的回调
@protocol JHAPIManagerCallBackProtocol <NSObject>

@required
- (void)managerCallAPIDidSuccess:(JHBaseAPIManager *)manager;
- (void)managerCallAPIDidFailed:(JHBaseAPIManager *)manager;

@end

@protocol JHAPIManagerValidator <NSObject>
@required

/**
 当请求降落时 对 server 返回的数据进行验证。主要是为了保证关键数据不为空
 */
- (BOOL)manager:(JHBaseAPIManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;

@optional
/**
 当请求起飞前，对将要传给 server 的参数进行验证，譬如手机号长度，验证码长度等等。
 这部分需求原本是写在 viewcontroller 里，现在从中剥离出来
 */
- (BOOL)manager:(JHBaseAPIManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end


/**
 让manager能够获取调用API所需要的数据
 */
@protocol JHAPIManagerParamSource <NSObject>
@required
- (NSDictionary *)paramsForApi:(JHBaseAPIManager *)manager;
@end


typedef NS_ENUM (NSUInteger, JHAPIManagerStatusType){
    JHAPIManagerStatus_Default,       //没有产生过API请求，这个是manager的默认状态。
    JHAPIManagerStatus_Success,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    JHAPIManagerStatus_NoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    JHAPIManagerStatus_ParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    JHAPIManagerStatus_Timeout,       //请求超时。CTAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看CTAPIProxy的相关代码。
    JHAPIManagerStatus_NoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, JHAPIManagerRequestType){
    JHAPIManagerRequestTypeGet,
    JHAPIManagerRequestTypePost,
    JHAPIManagerRequestTypePut,
    JHAPIManagerRequestTypeDelete
};

/*
 将原本的方法 override 变为使用 protocol 来调用
 CTAPIBaseManager的派生类必须符合这些protocol,
 */
@protocol JHAPIManagerProtocol <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (JHAPIManagerRequestType)requestType;
- (BOOL)shouldCache;

// used for pagable API Managers mainly
@optional
- (void)cleanData;
- (NSInteger)loadDataWithParams:(NSDictionary *)params;
- (BOOL)shouldLoadFromNative;

@end

/*************************************************************************************************/
/*                                    JHAPIManagerInterceptor                                    */
/*************************************************************************************************/
/*
 JHAPIBaseManager的派生类必须符合这些protocal
 */
@protocol JHAPIManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(JHBaseAPIManager *)manager beforePerformSuccessWithResponse:(JHURLResponse *)response;
- (void)manager:(JHBaseAPIManager *)manager afterPerformSuccessWithResponse:(JHURLResponse *)response;

- (BOOL)manager:(JHBaseAPIManager *)manager beforePerformFailWithResponse:(JHURLResponse *)response;
- (void)manager:(JHBaseAPIManager *)manager afterPerformFailWithResponse:(JHURLResponse *)response;

- (BOOL)manager:(JHBaseAPIManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(JHBaseAPIManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

@end

@interface JHBaseAPIManager : NSObject

@property (nonatomic, weak) id<JHAPIManagerCallBackProtocol> delegate;
@property (nonatomic, weak) id<JHAPIManagerParamSource> paramSource;
@property (nonatomic, weak) id<JHAPIManagerValidator> validator;
@property (nonatomic, weak) id<JHAPIManagerInterceptor> interceptor;
@property (nonatomic, weak) NSObject<JHAPIManagerProtocol> *child; //里面会调用到NSObject的方法，所以这里不用id

@property (nonatomic, readonly) JHAPIManagerStatusType statusType;
@property (nonatomic, strong) JHURLResponse *response;

@property (nonatomic, assign, readonly) BOOL isLoading;

//尽量使用loadData这个方法,这个方法会通过param source来获得参数，这使得参数的生成逻辑位于controller中的固定位置
- (NSInteger)loadData;

- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

- (void)cleanData;
- (BOOL)shouldCache;

@end
