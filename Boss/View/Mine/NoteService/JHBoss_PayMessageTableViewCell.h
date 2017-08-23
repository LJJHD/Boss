//
//  JHBoss_PayMessageTableViewCell.h
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//短信支付

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHBoss_PayMessageTableViewCell;

@protocol JHBoss_PayMessageTableViewCellDelegate <NSObject>

- (void)payMessageTableViewCell:(JHBoss_PayMessageTableViewCell *)messageCell;

@end

@interface JHBoss_PayMessageTableViewCell : UITableViewCell

@property (nonatomic, assign) id <JHBoss_PayMessageTableViewCellDelegate>delegate;

- (void)showMessageCount:(NSString *)messageCount moneyCount:(NSString *)moneyCount;

@end

NS_ASSUME_NONNULL_END
