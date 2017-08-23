//
//  JHBoss_AllStaffRangkingHeaderView.m
//  Boss
//
//  Created by jinghankeji on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_AllStaffRangkingHeaderView.h"

@implementation JHBoss_AllStaffRangkingHeaderView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI{

    @weakify(self)
    UILabel *noLB = [[UILabel alloc] init];
    noLB.font = DEF_SET_FONT(12);
    noLB.textColor = DEF_COLOR_A1A1A1;
    noLB.text = @"序号";
    noLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:noLB];
    [noLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
//        make.left.mas_equalTo(MYDIMESCALE(15));
        make.left.equalTo(self);
        make.centerY.mas_equalTo(0);
    }];
    
    UILabel *dishNameLB = [[UILabel alloc] init];
    dishNameLB.font = DEF_SET_FONT(12);
    dishNameLB.textColor = DEF_COLOR_A1A1A1;
    dishNameLB.text = @"姓名";
    dishNameLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:dishNameLB];
    [dishNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(MYDIMESCALE(50));
        make.left.equalTo(noLB.mas_right);
        make.centerY.mas_equalTo(0);
        make.width.equalTo(noLB);
    }];
    
    UIButton *saleNoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saleNoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [saleNoBtn setTitle:@"差评数"];
    saleNoBtn.titleLabel.font = DEF_SET_FONT(12);
    [saleNoBtn setTitleColor:DEF_COLOR_A1A1A1 forState:UIControlStateNormal];
    [self addSubview:saleNoBtn];
    [saleNoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(MYDIMESCALE(106));
        make.left.equalTo(dishNameLB.mas_right);
        make.centerY.mas_equalTo(0);
        make.width.equalTo(dishNameLB);
//        make.size.mas_equalTo(CGSizeMake(40, 12));
    }];
    
    /*
    UIButton *profitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    profitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [profitBtn setTitle:@"服务响应"];
    profitBtn.titleLabel.font = DEF_SET_FONT(12);
    [profitBtn setTitleColor:DEF_COLOR_A1A1A1 forState:UIControlStateNormal];
    [self addSubview:profitBtn];
    [profitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(0);
    }];
    */
    
    UIButton *goodEvaluationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goodEvaluationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [goodEvaluationBtn setTitle:@"打赏次数"];
    goodEvaluationBtn.titleLabel.font = DEF_SET_FONT(12);
    [goodEvaluationBtn setTitleColor:DEF_COLOR_A1A1A1 forState:UIControlStateNormal];
    [self addSubview:goodEvaluationBtn];
    [goodEvaluationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(MYDIMESCALE(-95));
        make.left.equalTo(saleNoBtn.mas_right);
        make.centerY.mas_equalTo(0);
        make.width.equalTo(saleNoBtn);
    }];
    
    UILabel *compareLB = [[UILabel alloc] init];
    compareLB.font = DEF_SET_FONT(12);
    compareLB.textColor = DEF_COLOR_A1A1A1;
    compareLB.text = @"人均消费";
    compareLB.textAlignment = NSTextAlignmentCenter;
    [self addSubview:compareLB];
    [compareLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(MYDIMESCALE(-30.5));
        make.left.equalTo(goodEvaluationBtn.mas_right);
        make.right.equalTo(self.mas_right).offset(-26);
        make.width.equalTo(goodEvaluationBtn);
        make.centerY.mas_equalTo(0);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = DEF_COLOR_LINEVIEW;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];

//    UIView *bottomLine = [[UIView alloc] init];
//    bottomLine.backgroundColor = DEF_COLOR_CDA265;
//    [self addSubview:bottomLine];
//    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-MYDIMESCALE(105));
//        make.bottom.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(28, 3));
//    }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
