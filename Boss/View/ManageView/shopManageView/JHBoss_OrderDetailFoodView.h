//
//  JHBoss_OrderDetailFoodView.h
//  Boss
//
//  Created by jinghankeji on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_OrderListModel.h"
@interface JHBoss_OrderDetailFoodView : UIView
@property (weak, nonatomic) IBOutlet UIView *needPayBackGroundView;
@property (weak, nonatomic) IBOutlet UIView *discountBackgroundView;
@property (nonatomic, assign) double payMoney;
@property (nonatomic, assign) float needPayMoney;
@property (nonatomic, strong) JHBoss_OrderListModel *orderListModel;

/**
 点击确定返回block
 money 减免金额
 discount 折扣 比如 7.5折
 */
@property (nonatomic, copy)void(^discountBlock)(NSString *money,NSString *discount);
@end
