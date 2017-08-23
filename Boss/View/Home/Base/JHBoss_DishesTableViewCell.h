//
//  JHBoss_DishesTableViewCell.h
//  Boss
//
//  Created by sftoday on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_DishModel.h"

@interface JHBoss_DishesTableViewCell : UITableViewCell

@property (nonatomic, strong) JHBoss_DishModel *model;
@property (nonatomic, assign) NSInteger sortNum; // 序号

@end
