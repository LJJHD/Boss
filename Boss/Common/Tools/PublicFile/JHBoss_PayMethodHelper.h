//
//  JHBoss_PayMethodHelper.h
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//获取支付方法的便利工具类

#import <Foundation/Foundation.h>

@class JHBoss_PayMehtodItem;

@interface JHBoss_PayMethodHelper : NSObject

- (NSMutableArray *)fetchPayMethodDataSourcesWithoutZFB:(BOOL)zfb;

@end
