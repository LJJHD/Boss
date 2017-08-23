//
//  JHBoss_StaffRangkingTopFiveTableViewCell.h
//  Boss
//
//  Created by jinghankeji on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_StaffRankingModel.h"
@interface JHBoss_StaffRangkingTopFiveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rankingImageView;//排名

/**
 点击cell上的打赏按钮调用
 @param  indexPath  单前点击的cell
 */
@property (nonatomic, copy) void(^rewardHandler)(NSIndexPath *indexPath);
-(void)staffRankingModel:(JHBoss_StaffRankingModel *)model indexPath:(NSIndexPath *)indexPath;

@end
