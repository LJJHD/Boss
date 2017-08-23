//
//  JHUploadExecutorFactory.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHUploadExecutorFactory.h"

const NSNotificationName  kUploadExecutorFinishAllTaskKey = @"kUploadExecutorFinishAllTaskKey";

const NSString * kJHUploadExecutorChatRoomNumber = @"kJHUploadExecutorChatRoomNumber";
const NSString * kJHUploadExecutorViewController = @"kJHUploadExecutorViewController";
const NSString * kJHUploadExecutorView = @"kJHUploadExecutorView";

@interface JHUploadExecutorFactory()

@property (strong, nonatomic, readwrite) NSArray<__kindof JHUploadExecutor*> * executorList;

@property (strong, nonatomic) dispatch_semaphore_t lock;

@property (strong, nonatomic) NSMutableDictionary * dispatchTable;

@end

@implementation JHUploadExecutorFactory

+ (instancetype)sharedManager{
    static JHUploadExecutorFactory * factory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        factory = [[JHUploadExecutorFactory alloc]init];
        factory.lock = dispatch_semaphore_create(1);
    });
    return factory;
}

- (id<JHUploadExecutorProtocol>)executor:(Class)aClass keyParams:(NSDictionary *)keyParams{
    dispatch_semaphore_wait(self.lock, DISPATCH_TIME_FOREVER);
    NSAssert(keyParams[kJHUploadExecutorChatRoomNumber], @"must has a chat room number");
    NSAssert(keyParams[kJHUploadExecutorView] || keyParams[kJHUploadExecutorViewController], @"must has a vc or view");
    
    NSString * key = [self dispatchTableKey:keyParams];
    UIViewController *uploadVc = [self uploadVc:keyParams];
    if (isObjEmpty(self.dispatchTable[key])) {
        JHUploadExecutor *executor = [[aClass alloc]initWithVc:uploadVc identify:key];
        executor.callBackDelegate = self;
        self.dispatchTable[key] = executor;
    }
    dispatch_semaphore_signal(self.lock);
    return self.dispatchTable[key];
}

- (void)remoceUploadExecutor:(NSDictionary *)keyParams{
    NSAssert(keyParams[kJHUploadExecutorView] || keyParams[kJHUploadExecutorViewController], @"must has a vc or view");
    NSString *key = [self dispatchTableKey:keyParams];
    if (isObjNotEmpty(self.dispatchTable[key])) {
        [self.dispatchTable removeObjectForKey:key];
    }
}

#pragma mark - private method
- (UIViewController *)uploadVc:(NSDictionary *)keyParams{
    UIViewController *uploadVc = nil;
    if (keyParams[kJHUploadExecutorViewController]){
        uploadVc = keyParams[kJHUploadExecutorViewController];
    }else if (keyParams[kJHUploadExecutorView]) {
        UIView *uploadView = keyParams[kJHUploadExecutorView];
        uploadVc = uploadView.currentViewController;
    }
    return uploadVc;
}

- (NSString *)dispatchTableKey:(NSDictionary *)keyParams{
    NSString *key = [NSString stringWithFormat:@"%ld",(long)((NSNumber *)keyParams[kJHUploadExecutorChatRoomNumber]).integerValue];
        key = [key stringByAppendingPathComponent:NSStringFromClass([self uploadVc:keyParams].class)];
    return key;
}

#pragma mark - delegate
- (void)executorHasUploadAllTasks:(JHUploadExecutor *)executor{
    [[NSNotificationCenter defaultCenter]postNotificationName:kUploadExecutorFinishAllTaskKey object:executor];
    if (executor.takeoffViewController == nil) {
        [self.dispatchTable removeObjectForKey:executor.identify];
    }
}

#pragma mark - setter / getter
- (NSMutableDictionary *)dispatchTable{
    if (_dispatchTable == nil) {
        _dispatchTable = [NSMutableDictionary dictionary];
    }
    return _dispatchTable;
}

@end
