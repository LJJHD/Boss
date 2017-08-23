//
//  JHBoss_OrderAndCommentListTableViewCell.h
//  Boss
//
//  Created by jinghankeji on 2017/6/21.
//  Copyright © 2017年 jinghan. All rights reserved.
// 差评列表

#import <UIKit/UIKit.h>
#import "JHBoss_BadEvaluateModel.h"
#define kLabelLinkTypeCustomer @"customer"
#define kLabelLinkTypeShop @"shop"
#define kLabelLinkTypeDish @"dish"
#define kLabelLinkTypeValuation @"valuation"
@class JHBoss_NotificationReminderTableViewCell;

@protocol JHBoss_NotificationReminderTableViewCellDelegate <NSObject>
@optional
/// 点击了 Label 的链接
- (void)cell:(JHBoss_NotificationReminderTableViewCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
@end

@interface JHBoss_OrderAndCommentListTableViewCell : UITableViewCell
@property (nonatomic, strong) JHBoss_BadEvaluateModel *model;
@property (nonatomic, weak) id<JHBoss_NotificationReminderTableViewCellDelegate> delegate;

@end
