//
//  JHBoss_GeneralCollectionModel.m
//  Boss
//
//  Created by sftoday on 2017/5/15.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_GeneralCollectionModel.h"

@implementation JHBoss_GeneralCollectionModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id":@"id",
             @"noticeCount":@"newNoticeCount"};
}

@end
