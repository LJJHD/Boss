//
//  JHBoss_RestaurantModel.m
//  Boss
//
//  Created by sftoday on 2017/5/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_RestaurantModel.h"

@implementation JHBoss_RestaurantModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"merchantId",@"name":@"merchantName"};
}

@end
