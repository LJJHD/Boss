//
//  JHBoss_EmployeesRewardCell.m
//  Boss
//
//  Created by SeaDragon on 2017/7/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_EmployeesRewardCell.h"

@implementation JHBoss_EmployeesRewardCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.iconImageView.layer.cornerRadius  = 30;
    self.iconImageView.layer.masksToBounds = YES;
    
}


- (void)showDetailWithNickName:(NSString *)name iconStr:(NSString *)iconStr {

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr]
                          placeholderImage:[UIImage imageNamed:@"2.2.2_icon_zhanweitu"]];
    
    self.nickNameLbl.text = name;
    
}
@end
