//
//  JHBoss_AllStaffRangkingTableViewCell.h
//  Boss
//
//  Created by jinghankeji on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_StaffRankingModel.h"
@interface JHBoss_AllStaffRangkingTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *numberLB;//序号
@property (nonatomic, strong) JHBoss_StaffRankingModel *model;
@end
