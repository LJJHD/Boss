//
//  JHBoss_MerchatBusinessDataModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/11.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_MerchatBusinessDataModel : JHBaseModel
@property (nonatomic , strong) NSNumber              *passengerFlow;//客流量
@property (nonatomic , strong) NSNumber              *rateOfPassengerFlow;//客流量比率

@property (nonatomic , strong) NSNumber              *exceptionOrderNum;
@property (nonatomic , strong) NSNumber              *NewPassenger;//新客户
@property (nonatomic , assign) CGFloat              perPassergerPrice;//客单价
@property (nonatomic , strong) NSNumber             * rateOfPerPassergerPrice;//客单价比率

@property (nonatomic , strong) NSNumber              *oldPassenger;
@property (nonatomic , copy) NSString              * rateOfLastTime;//异常订单比率
@property (nonatomic , copy) NSString              * rateOfNegative;
@property (nonatomic , strong) NSNumber              *negativeNum;//差评
@property (nonatomic , copy) NSString              * rateOfNewPassenger;
@property (nonatomic , strong) NSNumber              *sales;//营业额
@property (nonatomic , copy) NSString              * rateOfOldPassenger;
@end
