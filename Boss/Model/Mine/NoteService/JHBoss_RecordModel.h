//
//  JHBoss_RecordModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface Records : JHBaseModel
@property (nonatomic , strong) NSNumber            * amount;//金额
@property (nonatomic , copy) NSString              * account;//账号
@property (nonatomic , copy) NSString              * content;
@property (nonatomic , strong) NSNumber            *  operateDate;//时间
@end

@interface JHBoss_RecordModel : JHBaseModel
@property (nonatomic , strong) NSArray<Records *>              * records;
@property (nonatomic , copy) NSString              * operateMonthDate;
@property (nonatomic , strong) NSNumber            *  totalAmount;
@end
