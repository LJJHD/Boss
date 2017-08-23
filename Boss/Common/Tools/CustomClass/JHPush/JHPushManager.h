//
//  JHPushManager.h
//  Boss
//
//  Created by sftoday on 2017/4/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
// 引入JPush功能所需头文件
#import "JPUSHService.h"

@interface JHPushManager : JPUSHRegisterEntity

+ (instancetype)shareManager;
+ (void)setup;

@end
