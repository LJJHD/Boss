//
//  JHPrepareTools.h
//  JinghanLife
//
//  Created by 晶汉mac on 2017/1/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
/**
 准备工具类
 存放一些准备的方法
 **/
@interface JHPrepareTools : NSObject
//版本逻辑更新
+(void)updateAppVersionDetermin;

//是否是第一次启动
+ (void)initFirstLaunchWithKey:(NSString*)key;
@end
