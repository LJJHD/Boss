//
//  JHBoss_TurnoverOrFlowOrPriceModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/7.
//  Copyright © 2017年 jinghan. All rights reserved.
// 营业额、客流量、客单价

#import "JHBaseModel.h"

@interface JHBoss_TurnoverOrFlowOrPriceModel : JHBaseModel
@property (nonatomic , copy) NSString              * yunit;//天 或 周或月或年。时间范围
@property (nonatomic , copy) NSString              * data;//金额
@property (nonatomic , strong) NSArray<NSString *>              * xlist;//x轴的值
@property (nonatomic , copy) NSString              * name;// 营业额、客流量、客单价
@property (nonatomic , copy) NSString              * unit;//钱的单位
@property (nonatomic , strong) NSArray<NSString *>              * ylist;//y轴的值
@end
