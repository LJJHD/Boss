//
//  JHBoss_StaffRewardDetailHeaderView.m
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffRewardDetailHeaderView.h"

@interface JHBoss_StaffRewardDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *rewardNumLab;

@property (weak, nonatomic) IBOutlet UILabel *rewardMoneyLab;
@end

@implementation JHBoss_StaffRewardDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"JHBoss_StaffRewardDetailHeaderView" owner:self options:nil]objectAtIndex:0];
    }

    return self;
}

-(void)setStaffGratuityListModel:(JHBoss_StaffGratuityListModel *)StaffGratuityListModel{

    _StaffGratuityListModel = StaffGratuityListModel;
    
    _rewardNumLab.text = [NSString stringWithFormat:@"已被打赏了%ld次",StaffGratuityListModel.number];
    
    _rewardMoneyLab.text = [NSString stringWithFormat:@"%g元",(double)StaffGratuityListModel.money/100.0];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
