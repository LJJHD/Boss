//
//  JHBossGiveStaffMoneyView.h
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_rewardMoneyListModel.h"
@interface JHBossGiveStaffMoneyView : UIView
@property (nonatomic, copy) void (^payBlock)(NSString *);
@property (nonatomic, strong) NSMutableArray<JHBoss_rewardMoneyListModel*> *rewardMoneyArr;

@end
