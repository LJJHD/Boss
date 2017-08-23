//
//  JHBoss_StaffRangkingTopFiveTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffRangkingTopFiveTableViewCell.h"

@interface JHBoss_StaffRangkingTopFiveTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *staffIconImageV;
@property (nonatomic, strong) NSIndexPath *indexPath;//记录cell indexPath
@property (weak, nonatomic) IBOutlet UILabel *staffNameLB;
@property (weak, nonatomic) IBOutlet UILabel *badEvaluateNumLB;//差评数
@property (weak, nonatomic) IBOutlet UILabel *rewardNumLB;//打赏次数
@property (weak, nonatomic) IBOutlet UILabel *serviceResponseTimeLB;//服务响应时间
@property (weak, nonatomic) IBOutlet UILabel *peopleMoneyLB;//人均消费
@property (weak, nonatomic) IBOutlet UIImageView *rewardImageView;//打赏图标
@end

@implementation JHBoss_StaffRangkingTopFiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _staffIconImageV.layer.cornerRadius = 30;
    _staffIconImageV.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rewardTap)];
    [self.rewardImageView addGestureRecognizer:tap];
}

-(void)staffRankingModel:(JHBoss_StaffRankingModel *)model indexPath:(NSIndexPath *)indexPath{

    _indexPath = indexPath;
    [self.staffIconImageV sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:DEF_IMAGENAME(@"2.2.2_icon_zhanweitu")];
    self.staffNameLB.text = DEF_OBJECT_TO_STIRNG(model.name);
    
    //差评数
    NSMutableAttributedString *badEvaStr = [[NSMutableAttributedString alloc]initWithString:@"差评数 "];
    [badEvaStr appendAttributedString:[JHUtility getAttributedStringWithString:[model.negativeCommentNum stringValue] font:13 textColor:DEF_COLOR_B48645]];
    self.badEvaluateNumLB.attributedText = badEvaStr;
    
    //打赏次数
    NSMutableAttributedString *rewardStr = [[NSMutableAttributedString alloc]initWithString:@"打赏次数 "];
    [rewardStr appendAttributedString:[JHUtility getAttributedStringWithString:[model.rewardNum stringValue] font:13 textColor:DEF_COLOR_B48645]];
    self.rewardNumLB.attributedText = rewardStr;
    
    //服务响应时间
//    NSMutableAttributedString *responseEvaStr = [[NSMutableAttributedString alloc]initWithString:@"服务响应 "];
//    [responseEvaStr appendAttributedString:[JHUtility getAttributedStringWithString:[model.serviceResponse stringValue] font:13 textColor:DEF_COLOR_B48645]];
//    [responseEvaStr appendAttributedString:[JHUtility getAttributedStringWithString:@"s" font:13 textColor:DEF_COLOR_B48645]];
//    self.serviceResponseTimeLB.attributedText = responseEvaStr;
    
    //人均消费
    NSMutableAttributedString *peopleMoneyStr = [[NSMutableAttributedString alloc]initWithString:@"人均消费 "];
    [peopleMoneyStr appendAttributedString:[JHUtility getAttributedStringWithString:@"￥" font:13 textColor:DEF_COLOR_B48645]];
    [peopleMoneyStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%g",model.perCapitaConsumption.doubleValue/100] font:13 textColor:DEF_COLOR_B48645]];
     self.serviceResponseTimeLB.attributedText = peopleMoneyStr;
    
    
}

-(void)rewardTap{

    if (self.rewardHandler) {
        self.rewardHandler(_indexPath);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
