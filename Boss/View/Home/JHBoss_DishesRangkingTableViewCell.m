//
//  JHBoss_DishesRangkingTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/6/20.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_DishesRangkingTableViewCell.h"

@interface JHBoss_DishesRangkingTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *middleLeftLab;
@property (weak, nonatomic) IBOutlet UILabel *middleRightLab;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftLB;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightLB;
@property (weak, nonatomic) IBOutlet UIImageView *rangkingImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rewardMoneyImageV;

@end

@implementation JHBoss_DishesRangkingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   }
-(void)setDishModel:(JHBoss_DishModel *)dishModel{
    _dishModel = dishModel;
    
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:dishModel.picture] placeholderImage:DEF_IMAGENAME(@"2.1.2.2_icon_zhanweitu")];
    _titleLB.text = dishModel.dishName;
    _middleRightLab.hidden = YES;
    
    NSMutableAttributedString *middLeftStr = [[NSMutableAttributedString alloc]initWithString:@"销量 "];
    [middLeftStr appendAttributedString:[JHUtility getAttributedStringWithString:[dishModel.dishSaleNum stringValue] ? [dishModel.dishSaleNum stringValue] : @"0" font:13 textColor:DEF_COLOR_B48645]];
    _middleLeftLab.attributedText = middLeftStr;
    
    //有数据后需要修改
//    NSMutableAttributedString *middRightStr = [[NSMutableAttributedString alloc]initWithString:@"销售额 "];
//    [middRightStr appendAttributedString:[JHUtility getAttributedStringWithString:[dishModel.number stringValue] ? [dishModel.number stringValue] : @"0" font:13 textColor:DEF_COLOR_B48645]];
//    _middleRightLab.attributedText = middRightStr;
    
    
    NSMutableAttributedString *bottomLeftStr = [[NSMutableAttributedString alloc]initWithString:@"点赞 "];
    [bottomLeftStr appendAttributedString:[JHUtility getAttributedStringWithString:[dishModel.highOpinionNum stringValue] ? [dishModel.highOpinionNum stringValue] : @"0" font:13 textColor:DEF_COLOR_B48645]];
    _bottomLeftLB.attributedText = bottomLeftStr;
    
    
    NSMutableAttributedString *bottomRightStr = [[NSMutableAttributedString alloc]initWithString:@"点选率 "];
    [bottomRightStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%g%%",[dishModel.rateOfAllDishes doubleValue]*100] font:13 textColor:DEF_COLOR_B48645]];
    _bottomRightLB.attributedText = bottomRightStr;

   
}

-(void)setRangkingType:(dishsOrStaffRangkingType)rangkingType{

    if (self.rangkingType == enterIntoType_restRangking) {
        self.rewardMoneyImageV.hidden = NO;
       
    }
}

-(void)setRestRangkingModel:(JHBoss_AllRestRangkingModel *)restRangkingModel{

    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:restRangkingModel.picUrl] placeholderImage:DEF_IMAGENAME(@"1.2_icon_zhanweitu")];
    
    _titleLB.text = restRangkingModel.merchantName;
    
    NSMutableAttributedString *middLeftStr = [[NSMutableAttributedString alloc]initWithString:@"营业额 "];
    double sale = [restRangkingModel.sales doubleValue]/100.0;
    [middLeftStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%g",sale]  font:13 textColor:DEF_COLOR_B48645]];
    _middleLeftLab.attributedText = middLeftStr;
    
    //有数据后需要修改
    NSMutableAttributedString *middRightStr = [[NSMutableAttributedString alloc]initWithString:@"客流量 "];
    [middRightStr appendAttributedString:[JHUtility getAttributedStringWithString:[restRangkingModel.passengerFlow stringValue]  font:13 textColor:DEF_COLOR_B48645]];
    _middleRightLab.attributedText = middRightStr;
    
    
    NSMutableAttributedString *bottomLeftStr = [[NSMutableAttributedString alloc]initWithString:@"客单价 "];
     double perPassergerPrice = [restRangkingModel.perPassergerPrice doubleValue]/100.0;
    [bottomLeftStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%.2f",perPassergerPrice] font:13 textColor:DEF_COLOR_B48645]];
    _bottomLeftLB.attributedText = bottomLeftStr;
    
    
    NSMutableAttributedString *bottomRightStr = [[NSMutableAttributedString alloc]initWithString:@"翻台率 "];
    [bottomRightStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%g%%",restRangkingModel.rateOfTable.doubleValue*100]   font:13 textColor:DEF_COLOR_B48645]];
    _bottomRightLB.attributedText = bottomRightStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
