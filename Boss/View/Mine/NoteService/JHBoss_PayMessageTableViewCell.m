//
//  JHBoss_PayMessageTableViewCell.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PayMessageTableViewCell.h"

@interface JHBoss_PayMessageTableViewCell ()

@property (nonatomic, strong) UIButton *payButton;

@property (nonatomic, strong) UILabel *topLbl;
@property (nonatomic, strong) UILabel *lineLbl;
@property (nonatomic, strong) UILabel *messageCountLbl;
@property (nonatomic, strong) UILabel *residueMessageLbl;

@property (nonatomic, strong) UIImageView *leftImageView;

@end

@implementation JHBoss_PayMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    
    return self;
}

#pragma mark - Private Method

- (void)createUI {
    //描述
    [self.contentView addSubview:self.topLbl];
    
    [self.topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@20).priorityLow(250);
        make.top.equalTo(self.contentView).offset(20);
        make.left.equalTo(self.contentView).offset(25);
    }];
    
    //短信数量
    [self.contentView addSubview:self.messageCountLbl];
    
    [self.messageCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.equalTo(self.topLbl);
        make.width.equalTo(@20).priorityLow(250);
        make.top.equalTo(self.topLbl.mas_bottom).offset(5);
    }];
    
    //线条
    [self.contentView addSubview:self.lineLbl];
    
    [self.lineLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.25);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.top.equalTo(self.messageCountLbl.mas_bottom).offset(10);
    }];
    
    //剩余短信数量描述
    [self.contentView addSubview:self.residueMessageLbl];
    
    [self.residueMessageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLbl);
        make.width.equalTo(@20).priorityLow(250);
        make.height.equalTo(@30);
        make.top.equalTo(self.lineLbl.mas_bottom).offset(10);
        
    }];
    
    //左边图片
    [self.contentView addSubview:self.leftImageView];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@12);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.residueMessageLbl);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    //支付按钮
    [self.contentView addSubview:self.payButton];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20).priorityLow(250);
        make.centerY.equalTo(self.residueMessageLbl);
        make.height.equalTo(self.residueMessageLbl);
        make.right.equalTo(self.leftImageView.mas_left).offset(-10);
    }];

}

//回调代理
- (void)clickPayButton:(UIButton *)btn {
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(payMessageTableViewCell:)]) {
        [self.delegate payMessageTableViewCell:self];
    }
    
}

#pragma mark - Public Method
//赋值操作
- (void)showMessageCount:(NSString *)messageCount moneyCount:(NSString *)moneyCount {
    
    self.messageCountLbl.text = DEF_OBJECT_TO_STIRNG(messageCount);
    
    [self.payButton setTitle:[NSString stringWithFormat:@"%@ 元",DEF_OBJECT_TO_STIRNG(moneyCount)]];
    
}

#pragma mark - Setter And Getter
- (UIButton *)payButton {
    
    if (!_payButton) {
        
        _payButton                 = [UIButton buttonWithType:UIButtonTypeCustom];
        _payButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_payButton setTintColor:[UIColor colorWithRGBValue:161 g:161 b:161]];
        [_payButton setTitleColor:[UIColor colorWithRGBValue:161 g:161 b:161] forState:UIControlStateNormal];
        [_payButton addTarget:self action:@selector(clickPayButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _payButton;
}

- (UILabel *)topLbl {
    
    if (!_topLbl) {
        
        _topLbl           = [[UILabel alloc] init];
        _topLbl.text      = @"短信剩余(条)";
        _topLbl.font      = [UIFont systemFontOfSize:12];
        _topLbl.textColor = [UIColor colorWithRGBValue:161 g:161 b:161];
        
    }
    
    return _topLbl;
}

- (UILabel *)lineLbl {
    
    if (!_lineLbl) {
        _lineLbl                 = [[UILabel alloc] init];
        _lineLbl.backgroundColor = [UIColor colorWithRGBValue:161 g:161 b:161];
    }
    
    return _lineLbl;
}

- (UILabel *)messageCountLbl {
    
    if (!_messageCountLbl) {
        
        _messageCountLbl           = [[UILabel alloc] init];
        _messageCountLbl.font      = [UIFont systemFontOfSize:35];
        _messageCountLbl.textColor = [UIColor colorWithRGBValue:150 g:88 b:0];
        
    }
    
    return _messageCountLbl;
}

- (UILabel *)residueMessageLbl {
    
    if (!_residueMessageLbl) {
        
        _residueMessageLbl           = [[UILabel alloc] init];
        _residueMessageLbl.text      = @"钱包余额";
        _residueMessageLbl.font      = [UIFont systemFontOfSize:15];
        _residueMessageLbl.textColor = [UIColor colorWithRGBValue:110 g:110 b:110];
        
    }
    
    return _residueMessageLbl;
}

- (UIImageView *)leftImageView {
    
    if (!_leftImageView) {
        
        _leftImageView       = [[UIImageView alloc] init];
        _leftImageView.image = [UIImage imageNamed:@"1.1_btn_dropdown"];
    }
    
    return _leftImageView;
}

@end
