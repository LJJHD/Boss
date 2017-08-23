//
//  JHBoss_AllStaffRangkingViewController.h
//  Boss
//
//  Created by jinghankeji on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_RestaurantModel.h"

@interface JHBoss_AllStaffRangkingViewController : UIViewController
@property (nonatomic, copy) NSString *restId;//餐厅id
@property (nonatomic, copy) NSMutableArray<JHBoss_RestaurantModel *> *restArr;//餐厅数组
@end
