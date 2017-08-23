//
//  JHBoss_NewsListTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_NewsListTableViewCell.h"

@interface JHBoss_NewsListTableViewCell  ()
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *contenImageView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation JHBoss_NewsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _newsTitleLab.textColor = DEF_COLOR_6E6E6E;
    _timeLab.textColor = DEF_COLOR_A1A1A1;
    _contentLab.textColor = DEF_COLOR_A1A1A1;
    _lineView.backgroundColor = DEF_COLOR_ECECEC;
    _contenImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
