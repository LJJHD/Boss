//
//  JHBoss_TurnoverTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/6/20.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_TurnoverTableViewCell.h"

@interface JHBoss_TurnoverTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@end

@implementation JHBoss_TurnoverTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setGeneralModel:(JHBoss_MerchatBusinessDataModel *)generalModel{

    _generalModel = generalModel;
   
    if (generalModel.sales.doubleValue/100 >= 1000000) {
        self.titleLB.text = [[[@"营业额" stringByAppendingString:@"("] stringByAppendingString:@"万元"] stringByAppendingString:@")"];
        self.moneyLB.text = [NSString stringWithFormat:@"%g", (generalModel.sales.doubleValue/100)/10000];//转成万元
        
    }else{
        
        self.titleLB.text = [[[@"营业额" stringByAppendingString:@"("] stringByAppendingString:@"元"] stringByAppendingString:@")"];
        self.moneyLB.text = [NSString stringWithFormat:@"%g", generalModel.sales.doubleValue/100];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
