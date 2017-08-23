//
//  JHBoss_SwitchTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_SwitchTableViewCell.h"
#import "JHLoginState.h"
#import "JHUserInfoData.h"
@interface JHBoss_SwitchTableViewCell ()

@property (nonatomic, strong) UILabel *textLB;
@property (nonatomic, strong) UILabel *descLB;
@property (nonatomic, strong) UIButton *tipBtn;
@property (nonatomic, strong) UIView *lineView;
@end



@implementation JHBoss_SwitchTableViewCell

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
    @weakify(self);
    [[_tipBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.tipBlock) {
            self.tipBlock(x);
        }
    }];
    
    _descLB = [[UILabel alloc] init];
    _descLB.font = DEF_SET_FONT(15);
    _descLB.textColor = DEF_COLOR_A1A1A1;
    [self.contentView addSubview:self.descLB];
   

    _switchSW = [[UISwitch alloc] init];
  
    [self.contentView addSubview:self.switchSW];
       
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.contentView addSubview:self.lineView];
    
    [self.switchSW addTarget:self action:@selector(switchHanlder:) forControlEvents:UIControlEventValueChanged];
    
    
    [self layoutSubviews];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    @weakify(self);
    
    [_textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(25);
        make.centerY.equalTo(self);
    }];
    
    [_tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.textLB.mas_right);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(34, 44));
    }];
    
    [_descLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.tipBtn.mas_right).with.offset(6);
        make.centerY.equalTo(self);
    }];
    
    [_switchSW mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self);
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
    _descLB.text = descTitle;
}

- (void)setShowTipBtn:(BOOL)showTipBtn
{
    _showTipBtn = showTipBtn;
    _tipBtn.hidden = !showTipBtn;
}

-(void)switchHanlder:(UISwitch *)sender{

    if (self.switchHandler) {
        self.switchHandler(sender);
    }
}

@end
