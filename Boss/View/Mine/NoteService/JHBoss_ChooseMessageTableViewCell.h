//
//  JHBoss_ChooseMessageTableViewCell.h
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//短信选择视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHBoss_PayMessageItem;
@class JHBoss_ChooseMessageTableViewCell;

@protocol JHBoss_ChooseMessageTableViewCellDelegate <NSObject>

- (void)chooseMessageTableViewCellDelegate:(JHBoss_ChooseMessageTableViewCell *)chooseCell payItem:(JHBoss_PayMessageItem *)item indexPath:(NSIndexPath *)index;

@end

@interface JHBoss_ChooseMessageTableViewCell : UITableViewCell

@property (nonatomic, assign) id <JHBoss_ChooseMessageTableViewCellDelegate>delegate;

@property (nonatomic, strong) NSMutableArray *dataSources;

- (void)showDetailWithPayMessageItemArray:(NSMutableArray *)itemArray indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
