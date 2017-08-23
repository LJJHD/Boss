//
//  JHBoss_StaffEvaluateListModel.h
//  Boss
//
//  Created by jinghankeji on 2017/5/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_MoreStaffEvaluateListModel : JHBaseModel
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              *number;//评价人账号
@property (nonatomic , copy) NSString              *content;//content 评价内容
@property (nonatomic , copy) NSString              *time;//评价时间
@property (nonatomic , copy) NSString              *waiter;//评价人

@end
