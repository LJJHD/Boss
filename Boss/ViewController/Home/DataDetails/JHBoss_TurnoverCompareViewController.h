//
//  JHBoss_TurnoverCompareViewController.h
//  Boss
//
//  Created by jinghankeji on 2017/6/28.
//  Copyright © 2017年 jinghan. All rights reserved.
//营业额同比环比

#import <UIKit/UIKit.h>
#import "JHBoss_RestaurantModel.h"
@interface JHBoss_TurnoverCompareViewController : UIViewController
@property (nonatomic, copy) NSMutableArray<JHBoss_RestaurantModel *> *restArr;//餐厅数组

@end
