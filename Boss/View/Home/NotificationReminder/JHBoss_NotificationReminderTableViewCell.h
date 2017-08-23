//
//  JHBoss_NotificationReminderTableViewCell.h
//  Boss
//
//  Created by sftoday on 2017/5/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_NotificationReminderModel.h"

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


@interface JHBoss_NotificationReminderTableViewCell : UITableViewCell

@property (nonatomic, assign) NotificationReminderType notificationReminderType;
@property (nonatomic, strong) JHBoss_NotificationReminderModel *model;
@property (nonatomic, weak) id<JHBoss_NotificationReminderTableViewCellDelegate> delegate;

@end
