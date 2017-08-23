//
//  JHBoss_PushSettingModel.m
//  Boss
//
//  Created by sftoday on 2017/5/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PushSettingModel.h"

@implementation JHBoss_PushSettingModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"pushTargets" : [JHBoss_PushTargetsSettingModel class],
             @"subscribeReports" : [JHBoss_PushReportSettingModel class]};
}

@end


@implementation JHBoss_PushTargetsSettingModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id"};
}

@end


@implementation JHBoss_PushReportSettingModel

@end
