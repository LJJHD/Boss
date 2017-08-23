//
//  JHBoss_PayMethodTableViewCell.h
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//支付方法

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHBoss_PayMehtodItem;

@interface JHBoss_PayMethodTableViewCell : UITableViewCell

@property (nonatomic, strong) JHBoss_PayMehtodItem *payItem;

@end

NS_ASSUME_NONNULL_END
