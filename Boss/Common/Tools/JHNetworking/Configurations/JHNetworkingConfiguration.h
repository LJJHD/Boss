//
//  JHNetworkingConfiguration.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#ifndef JHNetworkingConfiguration_h
#define JHNetworkingConfiguration_h

typedef NS_ENUM(NSUInteger, JHURLResponseStatus){
    JHURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的 JHAPIBaseManager 来决定。
    JHURLResponseStatusErrorTimeout,
    JHURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSTimeInterval kJHNetworkingTimeoutSeconds = 20.0f;
static NSTimeInterval kJHCacheOutdateTimeSeconds = 300; // 5分钟的cache过期时间
static NSUInteger kJHCacheCountLimit = 1000; // 最多1000条cache

#endif /* JHNetworkingConfiguration_h */
