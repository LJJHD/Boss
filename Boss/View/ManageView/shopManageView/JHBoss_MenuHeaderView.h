//
//  JHBoss_MenuHeaderView.h
//  Boss
//
//  Created by jinghankeji on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_MenuSectionModel.h"
#import "JHBoss_DishesListModel.h"
typedef void(^CallBackBlock)(BOOL);

@interface JHBoss_MenuHeaderView : UITableViewHeaderFooterView
@property (nonatomic,strong) JHBoss_MenuSectionModel *model;
@property (nonatomic,strong) CallBackBlock block;

@property (nonatomic, strong) JHBoss_DishesListModel *dishesModel;
@end
