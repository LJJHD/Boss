//
//  JHBoss_IconTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_IconTableViewCell.h"

@interface JHBoss_IconTableViewCell ()

@property (nonatomic, strong) UIImageView *customImageView;

@end


@implementation JHBoss_IconTableViewCell

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
    _iconImageView.image = DEF_IMAGENAME(@"1.1_btn_dropdown");
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.layer.cornerRadius = 30;
    _iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(25);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
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
}

@end
