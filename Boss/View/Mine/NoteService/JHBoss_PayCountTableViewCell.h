//
//  JHBoss_PayCountTableViewCell.h
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//支付数量cell

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^choosePayCountBlock)(CGFloat payCount, NSInteger payID);

@interface JHBoss_PayCountTableViewCell : UITableViewCell

@property (nonatomic, copy) choosePayCountBlock payCountBlock;

//调用显示
- (void)showPayCountWithDataSource:(NSMutableArray *)payArray;

@end

NS_ASSUME_NONNULL_END
