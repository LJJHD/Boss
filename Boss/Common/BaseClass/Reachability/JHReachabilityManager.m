//
//  JHReachabilityManager.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHReachabilityManager.h"

@implementation JHReachabilityManager
+ (instancetype)shareManager{
    static JHReachabilityManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = (JHReachabilityManager *)[self reachabilityForInternetConnection];
    });
    return manager;
}

+ (void)setup{
    [[NSNotificationCenter defaultCenter]addObserver:[self shareManager] selector:@selector(reachabilityChange:) name:kReachabilityChangedNotification object:nil];
    [[self shareManager]startNotifier];
}

- (void)reachabilityChange:(NSNotification*)not{
    switch ([Reachability reachabilityForInternetConnection].currentReachabilityStatus)
    {
        case NotReachable://网络连接失败
            [JHUtility showToastWithMessage:@"网络断开链接"];
            break;
        case ReachableViaWWAN://蜂窝连接
            
            break;
        case ReachableViaWiFi://Wi-Fi连接
            
            break;
            
        default:
            break;
    }
}

@end
