//
//  JHBoss_MenuViewController.h
//  Boss
//
//  Created by jinghankeji on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_RestaurantModel.h"
@interface JHBoss_MenuViewController : UIViewController
@property (nonatomic, strong)NSMutableArray<JHBoss_RestaurantModel*> *allShopArr;//所有店铺数组
@property (nonatomic, assign) int currentSelectShop;//当前选中的店铺

@end
