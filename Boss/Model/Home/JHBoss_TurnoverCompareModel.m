//
//  JHBoss_TurnoverCompareModel.m
//  Boss
//
//  Created by jinghankeji on 2017/7/11.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_TurnoverCompareModel.h"


@implementation LastYearTurnover

@end

@implementation LastMonthTurnover

@end

@implementation RateOfLastMonth

@end

@implementation ThisYearTurnover

@end

@implementation RateOfLastYear

@end

@implementation JHBoss_TurnoverCompareModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"lastYearTurnover":[LastYearTurnover class],@"lastMonthTurnover":[LastMonthTurnover class],@"rateOfLastMonth":[RateOfLastMonth class],@"thisYearTurnover":[ThisYearTurnover class],@"rateOfLastYear":[RateOfLastYear class],};
}
@end
