//
//  JHBoss_StaffEvaluateTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffEvaluateTableViewCell.h"

@interface JHBoss_StaffEvaluateTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end

@implementation JHBoss_StaffEvaluateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



-(void)setEvaluationListModel:(JHBoss_MoreStaffEvaluateListModel *)EvaluationListModel{

    _nameLab.text = DEF_OBJECT_TO_STIRNG(EvaluationListModel.waiter);
    NSString *timeStr = DEF_OBJECT_TO_STIRNG(EvaluationListModel.time);
    _timeLab.text = [NSString dateStr:timeStr format:@"YYYY年MM月dd日 HH:mm:ss"];
    _contentLab.text = DEF_OBJECT_TO_STIRNG(EvaluationListModel.content);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
