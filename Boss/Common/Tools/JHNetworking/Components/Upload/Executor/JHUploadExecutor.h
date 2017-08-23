//
//  JHUploadExecutor.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHUploadResponse.h"

@class JHUploadTaskInfo;
@class JHUploadExecutor;
/**
 上传过程中的代理，上传进度，上传成功，上传失败
 */
@protocol JHUploadExecutorCallBackProtocol <NSObject>

- (void)executor:(JHUploadExecutor *)executor uploadDidSuccess:(JHUploadTaskInfo *)info response:(JHUploadResponse *)response;
- (void)executor:(JHUploadExecutor *)executor uploadDidFailed:(JHUploadTaskInfo *)info response:(JHUploadResponse *)response;
- (void)executor:(JHUploadExecutor *)executor uploadingTask:(JHUploadTaskInfo *)info Progress:(NSProgress *)progress;

@end

/**
 上传完了所有上传任务的回调，这个回调是给 JHBaseUploadManager 提供的
 */
@protocol JHUploadAllTaskCallBackProtocol <NSObject>

- (void)executorHasUploadAllTasks:(JHUploadExecutor *)executor;

@end

/**
 上传任务所需要的一些参数
 */
@protocol JHUploadExecutorProtocol <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (NSDictionary *)executor:(JHUploadExecutor *)executor paramsForUpload:(JHUploadTaskInfo *)info;
- (NSString *)executor:(JHUploadExecutor *)executor nameForUpload:(JHUploadTaskInfo *)info;
- (NSString *)executor:(JHUploadExecutor *)executor fileNameForUpload:(JHUploadTaskInfo *)info;

@optional
- (BOOL)shouldAutoUpload;
- (NSString *)executor:(JHUploadExecutor *)executor mimeTypeForUpload:(JHUploadTaskInfo *)info;

/**
 装配要上传的文件的二进制数据，逻辑上是这样的
 1、如果代理实现了该方法，那么上传的二进制文件就是有代理返回的二进制文件
 2、如果JHUploadTaskInfo中设置了 dataContent，那么上传的二进制文件就是这个 dataContent
 3、使用公共的转换方法，将 image（会根据 压缩比进行压缩，最终做成 jgp 格式） 和 record 转换成 二进制文件
 */
- (NSData *)executor:(JHUploadExecutor *)executor dataForUpload:(JHUploadTaskInfo *)info;

@end

/**
 上传过程前后的监听
 */
@protocol JHUploadExecutorInterceptor <NSObject>

@optional

/**
 是否能开始某个文件的上传
 */
- (BOOL)executor:(JHUploadExecutor *)executor shouldStartUpload:(NSDictionary *)uploadParam uploadInfo:(JHUploadTaskInfo *)info;

/**
 已开始某个文件的上传
 */
- (void)executor:(JHUploadExecutor *)executor didStartUploadWithUploadInfo:(JHUploadTaskInfo *)info;

/**
 调用上传成功代理函数 前 的切片
 */
- (BOOL)executor:(JHUploadExecutor *)executor beforePerformSuccessUploadWithUploadInfo:(JHUploadTaskInfo *)info;

/**
 调用上传成功代理函数 后 的切片
 */
- (void)executor:(JHUploadExecutor *)executor didPerformSuccessUploadWithUploadInfo:(JHUploadTaskInfo *)info;

/**
 调用上传失败代理函数 前 的切片
 */
- (BOOL)executor:(JHUploadExecutor *)executor beforePerformFailUploadWithUploadInfo:(JHUploadTaskInfo *)info;

/**
 调用上传失败代理函数 后 的切片
 */
- (void)executor:(JHUploadExecutor *)executor didPerformFailUploadWithUploadInfo:(JHUploadTaskInfo *)info;

@end

/**
 这个类中，封装了所有上传中的逻辑，代理对象，以及上传中涉及到的具体事务
 需要注意的是，上传业务一般是由 vc 发起的，而在一个 vc 中可能会要上传多个文件。这个时候，必须要维护一个数组，来持有所有的上传文件 info
 使用 JHBaseUploadManager 来管理所有的 JHUploadExecutor
 
 由于，上传操作在 vc pop 之后还会继续，所以，datasource 和 delegate 都必须由子类本上来实现，而不能给 vc 去实现
 
 */
@interface JHUploadExecutor : NSObject

@property (weak, nonatomic) JHUploadExecutor<JHUploadExecutorProtocol> * child;

@property (weak, nonatomic) id<JHUploadExecutorCallBackProtocol> delegate;
@property (weak, nonatomic) id<JHUploadExecutorInterceptor> interceptor;
@property (weak, nonatomic) id<JHUploadAllTaskCallBackProtocol> callBackDelegate;

@property (assign, nonatomic, readonly) BOOL isLoading;
@property (copy,   nonatomic, readonly) NSString *identify;

 /**
 一般就是发起上传任务的 vc 的name
 */
@property (copy, nonatomic, readonly) NSString * executorName;

/**
 将所有的上传任务都完成了。
 */
@property (assign, nonatomic, readonly) BOOL hasUploadAllTask;

/**
 所有的上传数组，包括已上传的，等待上传的，上传失败的
 */
@property (strong, nonatomic, readonly) NSArray * allUploadTasks;

/**
 上传失败的数组
 */
@property (strong, nonatomic, readonly) NSArray * uploadFailedTasks;

/**
 上传成功的数组
 */
@property (strong, nonatomic, readonly) NSArray * uploadSucceedTasks;

/**
 上传等待中的数组
 */
@property (strong, nonatomic, readonly) NSArray * waitingUploadTasks;

/**
 正在上传的任务 info
 */
@property (strong, nonatomic, readonly) JHUploadTaskInfo * currentUploadingTaskInfo;

/**
 发起上传请求的 viewcontroller
 */
@property (weak, nonatomic, readonly) UIViewController * takeoffViewController;

- (instancetype)initWithVc:(UIViewController *)aVC identify:(NSString *)identify;

- (void)addUploadTask:(JHUploadTaskInfo *)info;

- (void)addUploadTaskFromArray:(NSArray<__kindof JHUploadTaskInfo *>*)array;

/**
 start the upload manually
 */
- (BOOL)shouldAutoUpload;

- (void)startUpload;

- (void)cancelCurrentUploadingTask;

- (void)cancelAllUploadingTask;

@end
