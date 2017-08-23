//
//  JHBoss_DataDetailsModel.m
//  Boss
//
//  Created by sftoday on 2017/5/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_DataDetailsModel.h"

@implementation JHBoss_DataDetailsModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"dataList":[NSNumber class]};
}

@end
