//
//  JHBoss_UserWarpper.h
//  Boss
//
//  Created by SeaDragon on 2017/7/14.
//  Copyright © 2017年 jinghan. All rights reserved.
//存储全局非存储信息

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBoss_UserWarpper : NSObject

//用户ID
@property (nonatomic, copy) NSString *userID;

//用户是否安装微信
@property (nonatomic, assign) BOOL isInstallWX;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
