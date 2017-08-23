//
//  JHUploadExecutorFactory.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

/*
 文件上传功能，在上传失败的情况下，默认不会自动重新上传。因为，失败的原因很可能是因为网络条件不佳，重新上传机制不好把握
 微信的机制实际上是使用了一个 单例 对文件上传做了功能实现。
 和 APIManager 不一样的是，APIManager 是 vc 的一个属性，会随着 vc 的 dealloc 而 dealloc。
 但是 UploadManager 不会，UploadManager 会始终存在着，支持多个 vc 的上传工作。
 
 总的结构式：
 JHUploadExecutorFactory ---
                            JHUploadExecutor---
                                                JHUploadTaskInfo
                                                JHUploadTaskInfo
                                                JHUploadTaskInfo...
                            JHUploadExecutor---
                                                JHUploadTaskInfo
                                                JHUploadTaskInfo
                                                JHUploadTaskInfo...
                            JHUploadExecutor---
                                                JHUploadTaskInfo
                                                JHUploadTaskInfo
                                                JHUploadTaskInfo...
                                                ...
 */

#import <Foundation/Foundation.h>
#import "JHUploadExecutor.h"

#pragma mark - notification
extern const NSNotificationName kUploadExecutorFinishAllTaskKey;

#pragma mark - keyNameList
extern const NSString * kJHUploadExecutorChatRoomNumber;
extern const NSString * kJHUploadExecutorViewController;
extern const NSString * kJHUploadExecutorView;

@interface JHUploadExecutorFactory : NSObject<JHUploadAllTaskCallBackProtocol>

+ (instancetype)sharedManager;

/**
 JHUploadExecutorFactory 中持有一个字典，字典中的 value 是 executor ，key是根据外界传入的参数确定的
 keyParams —— 是一个字典，其中包含的信息将会组成一个key，用来指明一个 executor
 该方法会创建/复用一个 executor，
 
 如果，正在上传的过程中，用户退出了界面，那么上传的任务还是要继续的，executor 仍旧存在。
 当用户再次进入界面，这个时候，由于上次的上传还未完成，所以，会使用之前的那个 executor
 如果用户是在上传结束后离开的界面，那么，第二次进入界面，就会获得新的 executor
 一个 executor 封装了所有的上传操作，当 executor 中所有的任务完成后，executor 也会自动从 JHUploadExecutorFactory 中移除
 */
- (id<JHUploadExecutorProtocol>)executor:(Class)aClass keyParams:(NSDictionary *)keyParams;

- (void)remoceUploadExecutor:(NSDictionary *)keyParams;

@property (strong, nonatomic, readonly) NSArray<__kindof JHUploadExecutor*> * executorList;

@end

