//
//  JHBoss_WelcomeDishsModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//  最受欢迎的菜系

#import "JHBaseModel.h"

@interface JHBoss_WelcomeDishsModel : JHBaseModel
@property (nonatomic, copy) NSString *dishCategoryName;//菜名
@property (nonatomic, strong) NSNumber *dishCategoryId;
@property (nonatomic, strong) NSNumber *saleAmount;//售出分数

@end
