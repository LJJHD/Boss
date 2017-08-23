//
//  JHBoss_PhysicalExaminationModel.m
//  Boss
//
//  Created by sftoday on 2017/5/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PhysicalExaminationModel.h"

@implementation JHBoss_PhysicalExaminationModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"checkList" : [JHBoss_PhysicalExaminationItemModel class]};
}

@end


@implementation JHBoss_PhysicalExaminationItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id"};
}

@end
