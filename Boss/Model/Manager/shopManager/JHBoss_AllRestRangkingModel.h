//
//  JHBoss_AllRestRangkingModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_AllRestRangkingModel : JHBaseModel
@property (nonatomic , copy) NSString              * picUrl;//餐厅图片
@property (nonatomic , strong) NSNumber            *  passengerFlow;//客流量
@property (nonatomic , strong) NSNumber            *  NewPassenger;//新顾客
@property (nonatomic , strong) NSNumber            *  merchantId;
@property (nonatomic , strong) NSNumber            * perPassergerPrice;//客单价
@property (nonatomic , strong) NSNumber            *  oldPassenger;//老顾客
@property (nonatomic , strong) NSNumber            * rateOfTable;//翻台率
@property (nonatomic , strong) NSNumber            *  sales;//营业额
@property (nonatomic , copy) NSString              * merchantName;//餐厅名
@property (nonatomic , copy) NSString              * rateOfNewPassenger;//新顾客比例
@property (nonatomic , copy) NSString              * rateOfOldPassenger;//老顾客占的比例
@end


