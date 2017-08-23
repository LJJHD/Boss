//
//  JHBoss_PrepaymentOrderModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_PrepaymentOrderModel : JHBaseModel
@property (nonatomic , assign) CGFloat              amountMoney;
@property (nonatomic , copy) NSString              * orderNo;
@property (nonatomic , strong) NSNumber            *  billType;
@end
