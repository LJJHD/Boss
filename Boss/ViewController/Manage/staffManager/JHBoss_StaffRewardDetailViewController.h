//
//  JHBoss_StaffRewardDetailViewController.h
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//
//员工打赏明细
#import <UIKit/UIKit.h>
#import "JHBoss_StaffDetailModel.h"
@interface JHBoss_StaffRewardDetailViewController : UIViewController
@property (nonatomic, strong) JHBoss_StaffDetailModel *staffDetailModel;
@property (nonatomic, copy)   NSString *restId;
@end
