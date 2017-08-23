//
//  JHBoss_ApproveTableViewCell.h
//  Boss
//
//  Created by sftoday on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_ApproveModel.h"

typedef void(^ApprovalDecisionBlock)(void);

@interface JHBoss_ApproveTableViewCell : UITableViewCell

@property (nonatomic, assign) ApproveType approveType;

@property (nonatomic, assign) NSInteger displayType;

@property (nonatomic, strong) JHBoss_ApproveModel *model;

@property (nonatomic, copy) ApprovalDecisionBlock leftAction; // 拒绝action
@property (nonatomic, copy) ApprovalDecisionBlock rightAction; // 同意action

@end
