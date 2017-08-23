//
//  JHBoss_ExaminationResultTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ExaminationResultTableViewCell.h"

@interface JHBoss_ExaminationResultTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *descLB;
@property (nonatomic, strong) UIImageView *customImageView;

@property (nonatomic, strong) UIView *lineView;

@end


@implementation JHBoss_ExaminationResultTableViewCell

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
    _iconImageView.layer.cornerRadius = 4;
    _iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(18);
        make.size.mas_equalTo(CGSizeMake(34, 34));
    }];
    
    _titleLB = [[UILabel alloc] init];
    _titleLB.font = DEF_SET_FONT(16);
    _titleLB.textColor = DEF_COLOR_6E6E6E;
    [self.contentView addSubview:self.titleLB];
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(18);
        make.top.mas_equalTo(18.5);
    }];
    
    _descLB = [[UILabel alloc] init];
    _descLB.font = DEF_SET_FONT(12);
    _descLB.textColor = DEF_COLOR_A1A1A1;
    [self.contentView addSubview:self.descLB];
    [_descLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.titleLB);
        make.bottom.mas_equalTo(-18.5);
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
    
    // todo
    self.iconImageView.image = DEF_IMAGENAME(@"1.1.5.2_icon_binding");
    self.titleLB.text = @"账号绑定";
    self.descLB.text = @"您还未绑定微信和邮箱";
}

- (void)setModel:(JHBoss_PhysicalExaminationItemModel *)model
{
    _model = model;
    NSString *iconUrl = JH_loadPictureIP;
    iconUrl = [iconUrl stringByAppendingString:DEF_OBJECT_TO_STIRNG(model.icon)];
    if ([model.name isEqualToString:@"安全设置"]) {
        
        self.iconImageView.image = DEF_IMAGENAME(@"1.1.5.2_icon_safety");

    }else{
    
     [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:DEF_IMAGENAME(@"1.1.5.2_icon_binding")];

    }
       self.titleLB.text = model.name;
    self.descLB.text = model.prompt;
}

@end
