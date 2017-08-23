//
//  JHBoss_OrderDetailTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderDetailTableViewCell.h"

@interface JHBoss_OrderDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *foodNameLab;
@property (weak, nonatomic) IBOutlet UILabel *foodNumLab;
@property (weak, nonatomic) IBOutlet UILabel *foodPricLab;

@end

@implementation JHBoss_OrderDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDishesList:(dishesList *)dishesList{

    _dishesList = dishesList;
    
    _foodNameLab.text = DEF_OBJECT_TO_STIRNG(dishesList.name);
    
    _foodNumLab.text = [NSString stringWithFormat:@"X%ld",dishesList.count];

    NSString *priceStr =  [NSString stringWithFormat:@"%.2lf",dishesList.price / 100.0f];
    NSString *moneyType = @"￥";
    
    _foodPricLab.text = [moneyType stringByAppendingString:[self isPureInt:priceStr]];

}

//判断是否为整形：
- (NSString *)isPureInt:(NSString*)string{
    NSArray *priceArr = [string componentsSeparatedByString:@"."];
    NSString *intPrice = priceArr.firstObject;
    NSString *flotPrice = priceArr.lastObject;
    
    int appointPrice =  [flotPrice intValue];
    
    if (appointPrice >= 1) {
        return string;
    }
    
    return intPrice;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
