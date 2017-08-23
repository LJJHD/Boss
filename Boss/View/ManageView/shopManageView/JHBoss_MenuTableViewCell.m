//
//  JHBoss_MenuTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_MenuTableViewCell.h"

@interface JHBoss_MenuTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *foodIconimageV;
@property (weak, nonatomic) IBOutlet UILabel *foodNameLab;
@property (weak, nonatomic) IBOutlet UILabel *foodPricLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foodNameCenterConsstraint;
@end

@implementation JHBoss_MenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _foodIconimageV.layer.masksToBounds = YES;
    _foodNameLab.textColor = DEF_COLOR_333339;
    _foodPricLab.textColor = DEF_COLOR_A1A1A1;
}

-(void)setDishesList:(DishesList *)dishesList{

    _dishesList = dishesList;
    
    [_foodIconimageV sd_setImageWithURL:[NSURL URLWithString:dishesList.picture] placeholderImage:DEF_IMAGENAME(@"2.1.2.2_icon_zhanweitu")];
    
    _foodNameLab.text = dishesList.name;
    NSString * price = [NSString stringWithFormat:@"%.2lf",dishesList.price/100.0];
    NSString * memberPrice = [NSString stringWithFormat:@"%.2lf",dishesList.memberPrice/100.0];
    
    if (DEF_WIDTH <= 320) {
        self.foodNameCenterConsstraint.constant = -16;
        _foodPricLab.font = [UIFont systemFontOfSize:12];
        _foodPricLab.text = [NSString stringWithFormat:@"售价: ￥%@   会员价: ￥%@\n库存: %ld",[self isPureInt:price],[self isPureInt:memberPrice],dishesList.stock];
    }else{
    
    _foodPricLab.text = [NSString stringWithFormat:@"售价: ￥%@   会员价: ￥%@   库存: %ld",[self isPureInt:price],[self isPureInt:memberPrice],dishesList.stock];
    }
    
   
}

//判断是否为整形：
- (NSString *)isPureInt:(NSString*)string{
    NSArray *priceArr = [string componentsSeparatedByString:@"."];
    NSString *intPrice = priceArr.firstObject;
    NSString *flotPrice = priceArr.lastObject;

    int appointPrice =  [flotPrice intValue];
    
    if (appointPrice > 1) {
        return string;
    }
    return intPrice;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
