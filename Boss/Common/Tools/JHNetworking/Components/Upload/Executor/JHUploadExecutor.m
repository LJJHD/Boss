//
//  JHUploadExecutor.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHUploadExecutor.h"
#import "JHUploadTaskInfo.h"
#import "JHReachabilityManager.h"
#import "JHServiceFactory.h"

@interface JHUploadExecutor()

@property (copy,   nonatomic, readwrite) NSString * executorName;
@property (assign, nonatomic, readwrite) BOOL hasUploadAllTask;

@property (strong, nonatomic, readwrite) JHUploadTaskInfo * currentUploadingTaskInfo;

@property (strong, nonatomic) NSMutableArray * waitingUploadTaskList;

@property (strong, nonatomic) NSMutableArray * uploadSucceedTaskList;

@property (strong, nonatomic) NSMutableArray * uploadFailedTaskList;

@property (weak, nonatomic, readwrite) UIViewController * takeoffViewController;

@property (assign, nonatomic, readwrite) BOOL isLoading;

@property (strong, nonatomic) AFHTTPSessionManager * httpSessionManager;

@property (strong, nonatomic) NSURLSessionDataTask * currentUploadingTask;

@property (strong, nonatomic) NSOperationQueue * uploadOperationQueue;

@property (copy,   nonatomic, readwrite) NSString *identify;

@end

@implementation JHUploadExecutor

#pragma mark - life cycle
- (instancetype)initWithVc:(UIViewController *)aVC identify:(NSString *)identify{
    NSAssert([self conformsToProtocol:@protocol(JHUploadExecutorProtocol)], @"sub class must conform 'JHUploadExecutorProtocol' protocol");
    if (self = [super init]) {
        self.executorName = NSStringFromClass([aVC class]);
        self.takeoffViewController = aVC;
        self.child = (JHUploadExecutor<JHUploadExecutorProtocol>*)self;
        self.identify = identify;
    }
    return self;
}

- (void)dealloc{
    [self cancelAllUploadingTask];
}

#pragma mark - public

- (void)startUpload{
    if (isObjNotEmpty(self.waitingUploadTaskList) && self.isLoading == NO) {
        __weak typeof(self) weakSelf = self;
        NSBlockOperation * blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            JHUploadTaskInfo *currentUploadInfo = strongSelf.waitingUploadTaskList.firstObject;
            strongSelf.currentUploadingTaskInfo = currentUploadInfo;
            NSDictionary * params = [strongSelf.child executor:strongSelf paramsForUpload:currentUploadInfo];
            NSString *mimeType = [strongSelf mimetTypeForUpload:strongSelf.currentUploadingTaskInfo];
            
            [strongSelf.waitingUploadTaskList removeObjectAtIndex:0];
            if ([strongSelf shouldUpload:params uploadTaskInfo:currentUploadInfo]) {
                if ([JHReachabilityManager shareManager].currentReachabilityStatus != NotReachable) {
                    strongSelf.isLoading = YES;
                    [strongSelf.currentUploadingTaskInfo updateUploadStatus:Upload_In_Uploading];
                    
                    void(^operationBlock)() = ^(){
                        __strong typeof(weakSelf) strongSelf = self;
                        strongSelf.currentUploadingTask = nil;
                        strongSelf.isLoading = NO;
                        if (strongSelf.shouldAutoUpload) {
                            [strongSelf startUpload];
                        }
                        if (strongSelf.waitingUploadTaskList.count == 0) {
                            strongSelf.hasUploadAllTask = YES;
                            if ([strongSelf.callBackDelegate respondsToSelector:@selector(executorHasUploadAllTasks:)]) {
                                [strongSelf.callBackDelegate executorHasUploadAllTasks:strongSelf];
                            }
                        }
                    };
                    strongSelf.currentUploadingTaskInfo.dataContent = [strongSelf dataForUpload:strongSelf.currentUploadingTaskInfo];
                    
                    strongSelf.currentUploadingTask =  [strongSelf.httpSessionManager
                                                        POST:[strongSelf uploadServiceAddress]
                                                        parameters:params
                                                        constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                                                            __strong typeof(weakSelf) strongSelf = weakSelf;
                                                            [formData appendPartWithFileData:strongSelf.currentUploadingTaskInfo.dataContent
                                                                                        name:[strongSelf.child executor:strongSelf nameForUpload:currentUploadInfo]
                                                                                    fileName:[strongSelf.child executor:strongSelf fileNameForUpload:currentUploadInfo] mimeType:mimeType];
                                                        } progress:^(NSProgress * _Nonnull uploadProgress) {
                                                            __strong typeof(weakSelf) strongSelf = weakSelf;
                                                            if ([strongSelf.delegate respondsToSelector:@selector(executor:uploadingTask:Progress:)]) {
                                                                [strongSelf.delegate executor:strongSelf uploadingTask:strongSelf.currentUploadingTaskInfo Progress:uploadProgress];
                                                            }
                                                        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                            __strong typeof(weakSelf) strongSelf = weakSelf;
                                                            [strongSelf.currentUploadingTaskInfo updateUploadStatus:Upload_Succeed];
                                                            if ([strongSelf beforePerformSuccessUploadWithUploadInfo:strongSelf.currentUploadingTaskInfo]) {
                                                                if ([strongSelf.delegate respondsToSelector:@selector(executor:uploadDidSuccess:response:)]) {
                                                                    [strongSelf.delegate executor:strongSelf uploadDidSuccess:self.currentUploadingTaskInfo response:[[JHUploadResponse alloc]initWithResponseObject:responseObject error:nil]];
                                                                }
                                                            }
                                                            [strongSelf didPerformSuccessUploadWithUploadInfo:strongSelf.currentUploadingTaskInfo];
                                                            strongSelf.currentUploadingTaskInfo.dataContent = nil;
                                                            [strongSelf.uploadSucceedTaskList addObject:strongSelf.currentUploadingTaskInfo];
                                                            operationBlock();
                                                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                            __strong typeof(weakSelf) strongSelf = weakSelf;
                                                            [strongSelf.currentUploadingTaskInfo updateUploadStatus:Upload_Failed];
                                                            if ([strongSelf beforePerformFailUploadWithUploadInfo:strongSelf.currentUploadingTaskInfo]) {
                                                                if ([strongSelf.delegate respondsToSelector:@selector(executor:uploadDidFailed:response:)]) {
                                                                    [strongSelf.delegate executor:strongSelf uploadDidFailed:strongSelf.currentUploadingTaskInfo response:[[JHUploadResponse alloc]initWithResponseObject:nil error:error]];
                                                                }
                                                            }
                                                            [strongSelf didPerformFailUploadWithUploadInfo:strongSelf.currentUploadingTaskInfo];
                                                            strongSelf.currentUploadingTaskInfo.dataContent = nil;
                                                            [strongSelf.uploadFailedTaskList addObject:strongSelf.currentUploadingTaskInfo];
                                                            operationBlock();
                                                        }];
                    [strongSelf.currentUploadingTaskInfo bindUploadingTaskId:strongSelf.currentUploadingTask];
                    if ([strongSelf.interceptor respondsToSelector:@selector(executor:didStartUploadWithUploadInfo:)]) {
                        [strongSelf.interceptor executor:strongSelf didStartUploadWithUploadInfo:strongSelf.currentUploadingTaskInfo];
                    }
                }
            }
        }];
        [self.uploadOperationQueue addOperation:blockOperation];
    }else{
        NSLog(@"no upload task");
    }
}

- (void)addUploadTask:(JHUploadTaskInfo *)info{
    [self.waitingUploadTaskList addObject:info];
}

- (void)addUploadTaskFromArray:(NSArray<__kindof JHUploadTaskInfo *>*)array{
    [self.waitingUploadTaskList addObjectsFromArray:array];
}

- (BOOL)shouldAutoUpload{
    return YES;
}

- (void)cancelCurrentUploadingTask{
    if (isObjNotEmpty(self.currentUploadingTask)) {
        [self.currentUploadingTask cancel];
    }
}

- (void)cancelAllUploadingTask{
    [self.waitingUploadTaskList removeAllObjects];
    [self cancelCurrentUploadingTask];
}

#pragma mark - private method
- (BOOL)shouldUpload:(NSDictionary *)params uploadTaskInfo:(JHUploadTaskInfo *)info{
    if ([self.interceptor respondsToSelector:@selector(executor:shouldStartUpload:uploadInfo:)]) {
        return [self.interceptor executor:self shouldStartUpload:params uploadInfo:info];
    }
    return YES;
}

/**
 调用上传成功代理函数 前 的切片
 */
- (BOOL)beforePerformSuccessUploadWithUploadInfo:(JHUploadTaskInfo *)info{
    if ([self.interceptor respondsToSelector:@selector(executor:beforePerformSuccessUploadWithUploadInfo:)]) {
        return [self.interceptor executor:self beforePerformSuccessUploadWithUploadInfo:info];
    }
    return YES;
}

/**
 调用上传成功代理函数 后 的切片
 */
- (void)didPerformSuccessUploadWithUploadInfo:(JHUploadTaskInfo *)info{
    if ([self.interceptor respondsToSelector:@selector(executor:didPerformSuccessUploadWithUploadInfo:)]) {
        [self.interceptor executor:self didPerformSuccessUploadWithUploadInfo:info];
    }
}

/**
 调用上传失败代理函数 前 的切片
 */
- (BOOL)beforePerformFailUploadWithUploadInfo:(JHUploadTaskInfo *)info{
    if ([self.interceptor respondsToSelector:@selector(executor:beforePerformFailUploadWithUploadInfo:)]) {
        return [self.interceptor executor:self beforePerformFailUploadWithUploadInfo:info];
    }
    return YES;
}

/**
 调用上传失败代理函数 后 的切片
 */
- (void)didPerformFailUploadWithUploadInfo:(JHUploadTaskInfo *)info{
    if ([self.interceptor respondsToSelector:@selector(executor:didPerformFailUploadWithUploadInfo:)]) {
        [self.interceptor executor:self didPerformFailUploadWithUploadInfo:info];
    }
}

- (NSString *)uploadServiceAddress{
    JHService * service = [[JHServiceFactory shareInstance]serviceWithIdentifier:[self.child serviceType]];
    NSString * uploadServiceAddress = @"";
    if (isObjNotEmpty(service.apiVersion)) {
        uploadServiceAddress = [NSString stringWithFormat:@"%@/%@/%@",service.apiBaseUrl,service.apiVersion,self.child.methodName];
    }else{
        uploadServiceAddress = [NSString stringWithFormat:@"%@/%@",service.apiBaseUrl,self.child.methodName];
    }
    return uploadServiceAddress;
}

- (NSString *)mimetTypeForUpload:(JHUploadTaskInfo *)uploadInfo{
    NSString *mimeType = nil;
    if ([self.child respondsToSelector:@selector(executor:mimeTypeForUpload:)]) {
        mimeType = [self.child executor:self mimeTypeForUpload:uploadInfo];
    }else{
        switch (uploadInfo.taskType) {
            case UploadTaskType_Image:
                mimeType = @"image/jpeg";
                break;
            case UploadTaskType_Record:
                mimeType = @"audio/wav";
                break;
            default:
                break;
        }
    }
    return mimeType;
}

- (NSData *)dataForUpload:(JHUploadTaskInfo *)info{
    NSData * data = nil;
    if ([self.child respondsToSelector:@selector(executor:dataForUpload:)]) {
        data = [self.child executor:self dataForUpload:info];
    }else{
        if (isObjNotEmpty(info.dataContent)) {
            data = info.dataContent;
        }else{
            switch (info.taskType) {
                case UploadTaskType_Image:
                {
                    UIImage *image = [UIImage imageWithContentsOfFile:info.uploadFileURL.absoluteString];
                    data = UIImageJPEGRepresentation(image, info.compressRate);
                }
                    break;
                case UploadTaskType_Record:
                    data = [NSData dataWithContentsOfURL:info.uploadFileURL];
                    break;
                default:
                    break;
            }
        }
    }
    return data;
}

#pragma mark - setter / getter

- (NSMutableArray *)waitingUploadTaskList{
    if (_waitingUploadTaskList == nil) {
        _waitingUploadTaskList = [NSMutableArray array];
    }
    return _waitingUploadTaskList;
}

- (NSMutableArray *)uploadSucceedTaskList{
    if (_uploadSucceedTaskList == nil) {
        _uploadSucceedTaskList = [NSMutableArray array];
    }
    return _uploadSucceedTaskList;
}

- (NSMutableArray *)uploadFailedTaskList{
    if (_uploadFailedTaskList == nil) {
        _uploadFailedTaskList = [NSMutableArray array];
    }
    return _uploadFailedTaskList;
}

- (NSArray *)allUploadTasks{
    NSMutableArray * allUploadTasks = [NSMutableArray array];
    [allUploadTasks addObjectsFromArray:self.waitingUploadTaskList];
    [allUploadTasks addObjectsFromArray:self.uploadSucceedTaskList];
    [allUploadTasks addObjectsFromArray:self.uploadFailedTaskList];
    return [allUploadTasks copy];
}

- (NSArray *)uploadFailedTasks{
    return [self.uploadFailedTaskList copy];
}

- (NSArray *)uploadSucceedTasks{
    return [self.uploadSucceedTaskList copy];
}

- (NSArray *)waitingUploadTasks{
    return [self.waitingUploadTaskList copy];
}

- (AFHTTPSessionManager *)httpSessionManager{
    if (isObjEmpty(_httpSessionManager)) {
        _httpSessionManager = [AFHTTPSessionManager manager];
    }
    return _httpSessionManager;
}

- (NSOperationQueue *)uploadOperationQueue{
    if (_uploadOperationQueue == nil) {
        _uploadOperationQueue = [[NSOperationQueue alloc]init];
    }
    return _uploadOperationQueue;
}

@end
