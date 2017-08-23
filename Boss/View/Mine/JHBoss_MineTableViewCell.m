//
//  JHBoss_MineTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_MineTableViewCell.h"

@interface JHBoss_MineTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLB;
@property (nonatomic, strong) UIImageView *customImageView;
@property (nonatomic, strong) UIView *lineView;

@end


@implementation JHBoss_MineTableViewCell

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
    @weakify(self);
    
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(20);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    _textLB = [[UILabel alloc] init];
    _textLB.font = DEF_SET_FONT(15);
    _textLB.textColor = DEF_COLOR_6E6E6E;
    [self.contentView addSubview:self.textLB];
    [_textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(50);
        make.centerY.equalTo(self);
    }];
    
    _customImageView = [[UIImageView alloc] init];
    _customImageView.image = DEF_IMAGENAME(@"1.1_btn_dropdown");
    [self.contentView addSubview:self.customImageView];
    [_customImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(10);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.contentView addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];

}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    switch (tag) {
        case 1000:
            self.iconImageView.image = DEF_IMAGENAME(@"5.1_icon_gerenziliao");
            self.textLB.text = @"个人资料";
            break;
        case 1001:
            self.iconImageView.image = DEF_IMAGENAME(@"5.1_icon_yijianjianyi");
            self.textLB.text = @"意见建议";
            break;
        case 1002:
            self.iconImageView.image = DEF_IMAGENAME(@"5.1_icon_shiyongtiaokuan");
            self.textLB.text = @"使用条款";
            break;
        case 1003:
            self.iconImageView.image = DEF_IMAGENAME(@"5.1_icon_guanyjinghan");
            self.textLB.text = @"关于晶汉";
            break;
            
        default:
            break;
    }
}

@end
