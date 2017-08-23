//
//  JHBoss_DishesViewController.h
//  Boss
//
//  Created by sftoday on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_RestaurantModel.h"
@interface JHBoss_DishesViewController : UIViewController
@property (nonatomic, copy) NSMutableArray<JHBoss_RestaurantModel *> *restArr;//餐厅数组
@property (nonatomic, copy) NSString *BegainSelectedDate;//选中的开始日期
@property (nonatomic, copy) NSString *EndSelectedDate;//选中的结束日期
@property (nonatomic, assign) NSInteger restaurantId; // 现在所选餐厅id;

@end
