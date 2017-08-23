//
//  JHBoss_UserWarpper.m
//  Boss
//
//  Created by SeaDragon on 2017/7/14.
//  Copyright © 2017年 jinghan. All rights reserved.
//全局非存储变量

#import "JHBoss_UserWarpper.h"


@implementation JHBoss_UserWarpper

+ (instancetype)shareInstance {

    static JHBoss_UserWarpper *_instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[JHBoss_UserWarpper alloc] init];
    });
    
    return _instance;
}


@end


