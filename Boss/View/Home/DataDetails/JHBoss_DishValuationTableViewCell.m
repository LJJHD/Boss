//
//  JHBoss_DishValuationTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_DishValuationTableViewCell.h"

@interface JHBoss_DishValuationTableViewCell ()

@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UILabel *detailLB;
@property (nonatomic, strong) UIView *lineView;

@end


@implementation JHBoss_DishValuationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    @weakify(self);
    
    _nameLB = [[UILabel alloc] init];
    _nameLB.font = DEF_SET_FONT(12);
    _nameLB.textColor = DEF_COLOR_CDA265;
    [self.contentView addSubview:self.nameLB];
    [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(8);
    }];
    
    _timeLB = [[UILabel alloc] init];
    _timeLB.font = DEF_SET_FONT(12);
    _timeLB.textColor = DEF_COLOR_CDA265;
    [self.contentView addSubview:self.timeLB];
    [_timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-25);
        make.top.equalTo(self.nameLB);
    }];
    
    _detailLB = [[UILabel alloc] init];
    _detailLB.font = DEF_SET_FONT(13);
    _detailLB.textColor = DEF_COLOR_333339;
    _detailLB.numberOfLines = 0;
    _detailLB.preferredMaxLayoutWidth = DEF_WIDTH - 50;
    [self.contentView addSubview:self.detailLB];
    [_detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(25);
        make.top.equalTo(self.nameLB.mas_bottom).with.offset(12);
        make.bottom.equalTo(self).with.offset(-18);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.contentView addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setModel:(JHBoss_DishCommentModel *)model
{
    _model = model;
    self.nameLB.text = model.commenter;
    self.timeLB.text = [model.time stringFromTimeIntervalWithFormat:@"MM月dd日 HH:mm"];
    self.detailLB.text = model.content;
}

@end
