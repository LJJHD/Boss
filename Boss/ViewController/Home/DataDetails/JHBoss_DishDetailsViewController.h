//
//  JHBoss_DishDetailsViewController.h
//  Boss
//
//  Created by sftoday on 2017/5/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_DishModel.h"
#import "JHBoss_RestaurantModel.h"
@interface JHBoss_DishDetailsViewController : UIViewController
@property (nonatomic, copy) NSMutableArray<JHBoss_RestaurantModel *> *restArr;//餐厅数组
@property (nonatomic, copy) NSString *restaurantId;
@property (nonatomic, copy) NSString *restName;
@property (nonatomic, strong) JHBoss_DishModel *dishModel;
@property (nonatomic, copy) NSString *BegainSelectedDate;//选中的开始日期
@property (nonatomic, copy) NSString *EndSelectedDate;//选中的结束日期
@end
