//
//  JHService.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

/*
 一个完整的 Api 构成：
 commonHeader/category/version/method
 例如：
 http://192.168.1.200:8042/spika/v1/file/upload
 commonHeader = http://192.168.1.200:8042
 category = spika
 version = v1
 method = file/upload —— 这个分属在 api manager 中管理，而不在 service 中。
 原因是，一个 service 的 api 实际上是一个 api 集合，commonHeader/category/version 表征了一个 api 集合所在的位置（和文件夹系统实际上是一样的）
 这个集合中有多个 api ，method 指出的就是具体一个 api manager 希望调用的 api，所以 method 这个交由 api manager 管理
 
 service 的代理方法中，应用层要根据自身的实际情况，返回相应的 api 内容
 ApiBaseUrl 应当是完整的接口地址
 考虑到项目中绝大部分 service 的地址，其实都有一个公共的header，所以，为每个 service 输入一个完整的 ApiBaseUrl有些累赘
 */

#import <Foundation/Foundation.h>

@protocol JHServiceProtocol <NSObject>

@optional
@property (nonatomic, readonly) BOOL isOnline;

/**
 线上线下的url
 */
@property (nonatomic, readonly) NSString *offlineApiBaseUrl;
@property (nonatomic, readonly) NSString *onlineApiBaseUrl;

/**
 线上线下的url分类
 */
@property (nonatomic, readonly) NSString *offlineApiCategory;
@property (nonatomic, readonly) NSString *onlineApiCategory;

/**
 线上线下的url版本
 */
@property (nonatomic, readonly) NSString *offlineApiVersion;
@property (nonatomic, readonly) NSString *onlineApiVersion;

@end

@interface JHService : NSObject

@property (nonatomic, strong, readonly) NSString *apiBaseUrl;
@property (nonatomic, strong, readonly) NSString *apiVersion;
@property (nonatomic, assign, readonly) BOOL isOnline;

@property (nonatomic, weak) id<JHServiceProtocol> child;

@end
