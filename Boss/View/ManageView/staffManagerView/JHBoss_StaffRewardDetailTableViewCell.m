//
//  JHBoss_StaffRewardDetailTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffRewardDetailTableViewCell.h"

@interface JHBoss_StaffRewardDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation JHBoss_StaffRewardDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setGratuityListModel:(GratuityList *)gratuityListModel{

    _gratuityListModel = gratuityListModel;
    
    _nameLab.text = DEF_OBJECT_TO_STIRNG(gratuityListModel.person);
    _moneyLab.text = [NSString stringWithFormat:@"%g元",(double)(gratuityListModel.amount/100.0)];
    _timeLab.text = DEF_OBJECT_TO_STIRNG(gratuityListModel.time);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
