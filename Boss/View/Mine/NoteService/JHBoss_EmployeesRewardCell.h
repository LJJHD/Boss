//
//  JHBoss_EmployeesRewardCell.h
//  Boss
//
//  Created by SeaDragon on 2017/7/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHBoss_EmployeesRewardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nickNameLbl;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

- (void)showDetailWithNickName:(NSString *)name iconStr:(NSString *)iconStr;

@end
