//
//  JHBoss_DishesRangkingTableViewCell.h
//  Boss
//
//  Created by jinghankeji on 2017/6/20.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_DishModel.h"
#import "JHBoss_AllRestRangkingModel.h"
typedef NS_ENUM(NSUInteger,dishsOrStaffRangkingType) {

    enterIntoType_dishs,//菜品排行
    enterIntoType_restRangking,//分店排行

};

@interface JHBoss_DishesRangkingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rangkingImage;
@property (nonatomic, strong) JHBoss_DishModel *dishModel;
@property (nonatomic, strong) JHBoss_AllRestRangkingModel *restRangkingModel;
@property (nonatomic, assign) dishsOrStaffRangkingType  rangkingType;
@end
