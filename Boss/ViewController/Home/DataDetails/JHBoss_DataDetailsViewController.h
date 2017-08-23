//
//  JHBoss_DataDetailsViewController.h
//  Boss
//
//  Created by sftoday on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//
//异常提醒VC 
#import <UIKit/UIKit.h>
#import "JHBoss_RestaurantModel.h"

@interface JHBoss_DataDetailsViewController : UIViewController
@property (nonatomic, copy) NSMutableArray<JHBoss_RestaurantModel *> *restArr;//餐厅数组
@property (nonatomic, copy) NSString *BegainSelectedDate;//选中的开始日期
@property (nonatomic, copy) NSString *EndSelectedDate;//选中的结束日期
@end
