//
//  JHBoss_PayMethodFooterView.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PayMethodFooterView.h"

@interface JHBoss_PayMethodFooterView ()

@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UIButton *questionButton;

@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation JHBoss_PayMethodFooterView

#pragma mark - Private Method

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    
    return self;
}

//创建视图
- (void)createUI {
    
    //支付
    [self addSubview:self.payButton];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@40);
        make.top.equalTo(self).offset(20);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    
    //问题
    [self addSubview:self.questionButton];
    
    [self.questionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.left.equalTo(self.payButton);
        make.top.equalTo(self.payButton.mas_bottom).offset(10);
    }];
    
    //描述
    [self addSubview:self.detailLabel];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.payButton);
        make.top.equalTo(self.questionButton);
        make.height.equalTo(@20).priorityLow();
        make.left.equalTo(self.questionButton.mas_right).offset(10);
    }];
}

//回传信息
- (void)clickQuestionButton:(UIButton *)btn {
    
    //获取金额
    CGFloat payCount = [[[btn.currentTitle componentsSeparatedByString:@" "] lastObject] floatValue];
    
    if (self.footViewBlock) {
        //单位为: 分
        self.footViewBlock(btn.tag,payCount*100);
    }
    
}

#pragma mark - Getter And Setter

- (void)setPayCount:(CGFloat)payCount {
    
    _payCount = payCount;
    
    switch (self.methodType) {
        case kChooseMethodType_TOP_UP:
        {
            [self.payButton setTitle:[NSString stringWithFormat:@"确认充值: ¥ %g",payCount]];

        }
            break;
            
        case kChooseMethodType_Employees:
        {
            [self.payButton setTitle:[NSString stringWithFormat:@"确认打赏: ¥ %g",payCount]];

        }
            break;
    }
    
}

- (void)setMethodType:(ChooseMethodType)methodType {

    _methodType = methodType;
    
    switch (methodType) {
        case kChooseMethodType_TOP_UP:
        {
            self.detailLabel.hidden    = NO;
            self.questionButton.hidden = NO;
        }
            break;
            
        case kChooseMethodType_Employees:
        {
            self.detailLabel.hidden    = YES;
            self.questionButton.hidden = YES;
        }
            break;
    }
}

- (UIButton *)payButton {
    
    if (!_payButton) {
        
        _payButton      = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.tag  = 200;
        _payButton.layer.cornerRadius  = 20;
        _payButton.layer.masksToBounds = YES;
        [_payButton setBackgroundColor:[UIColor colorWithRGBValue:205 g:162 b:101]];
        [_payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [_payButton addTarget:self action:@selector(clickQuestionButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _payButton;
}

- (UIButton *)questionButton {
    
    if (!_questionButton) {
        _questionButton     = [UIButton buttonWithType:UIButtonTypeCustom];
        _questionButton.tag = 100;
        [_questionButton setBackgroundImage:[UIImage imageNamed:@"0.2_icon_question"] forState:UIControlStateNormal];
        [_questionButton addTarget:self action:@selector(clickQuestionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
 
    return _questionButton;
}

- (UILabel *)detailLabel {
    
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font          = [UIFont systemFontOfSize:13];
        _detailLabel.text          = @"您的'晶汉钱包'资金可用于购买短信,会员,营销活动等";
        _detailLabel.textColor     = [UIColor colorWithRGBValue:161 g:161 b:161];
        _detailLabel.numberOfLines = 0;
    }
    
    return _detailLabel;
}

@end
