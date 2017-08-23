//
//  JHBoss_StaffDetailModel.m
//  Boss
//
//  Created by jinghankeji on 2017/5/15.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffDetailModel.h"


@implementation JHBoss_StaffEvaluationListModel

@end



@implementation JHBoss_StaffAccountModel

@end


@implementation JHBoss_StaffDetailModel


+(NSDictionary *)mj_objectClassInArray{

    return @{@"accountModel" : [JHBoss_StaffAccountModel class],@"evaluationList":[JHBoss_StaffEvaluationListModel class]};


}

@end
