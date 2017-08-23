//
//  JHBoss_DishModel.h
//  Boss
//
//  Created by sftoday on 2017/5/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHBoss_DishModel : NSObject

@property (nonatomic, strong) NSNumber *dishSaleNum;
@property (nonatomic, strong) NSNumber *highOpinionNum; // 好评数
@property (nonatomic, strong) NSNumber *memberPrice;
@property (nonatomic, strong) NSNumber *dishId;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSNumber *stock;
@property (nonatomic, copy) NSString *dishName; // 菜品名
@property (nonatomic, strong) NSNumber *rateOfAllDishes; // 点选率
@property (nonatomic, copy) NSString *picture;//菜品图片
@end
