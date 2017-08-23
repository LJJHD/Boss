//
//  JHBoss_SwitchTextFieldTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_SwitchTextFieldTableViewCell.h"

@interface JHBoss_SwitchTextFieldTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *textLB;
@property (nonatomic, strong) UIButton *tipBtn;
@property (nonatomic, strong) UIView *lineView;
@end


@implementation JHBoss_SwitchTextFieldTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

//设置UI
-(void)setUI
{
    
    
    _textLB = [[UILabel alloc] init];
    _textLB.font = DEF_SET_FONT(15);
    _textLB.textColor = DEF_COLOR_6E6E6E;
    [self.contentView addSubview:self.textLB];
    
    _tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tipBtn.hidden = YES;
    _tipBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 10, 15, 10);
    [_tipBtn setimage:@"5.2.4_icon_question"];
    [self.contentView addSubview:self.tipBtn];
    
    _descTF = [[UITextField alloc] init];
    _descTF.font = DEF_SET_FONT(15);
    _descTF.textColor = DEF_COLOR_A1A1A1;
    _descTF.enabled = _enableTextField;
    _descTF.delegate = self;
    _descTF.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.descTF];
    
    
    _switchSW = [[UISwitch alloc] init];
    
    [self.contentView addSubview:self.switchSW];
    
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.contentView addSubview:self.lineView];
    
    
    [self layoutSubviews];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textFieldEndEditBlock) {
        self.textFieldEndEditBlock(textField.text);
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    @weakify(self);
    
    [_textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(25);
        make.centerY.equalTo(self);
        make.width.mas_lessThanOrEqualTo(40);
    }];
    
    [_tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.textLB.mas_right);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(34, 44));
    }];
    
    [_descTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.tipBtn.mas_right).with.offset(6);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(44);
    }];
    
    [_switchSW mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self);
    }];
    
    [_descTF mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.switchSW.mas_left);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _textLB.text = title;
}

- (void)setDescTitle:(NSString *)descTitle
{
    _descTitle = descTitle;
    _descTF.text = descTitle;
}

- (void)setShowTipBtn:(BOOL)showTipBtn
{
    _showTipBtn = showTipBtn;
    _tipBtn.hidden = !showTipBtn;
}

- (void)setEnableTextField:(BOOL)enableTextField
{
    _enableTextField = enableTextField;
    _descTF.enabled = enableTextField;
}

@end
