//
//  JHBoss_GeneralTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/2.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_GeneralTableViewCell.h"

@interface JHBoss_GeneralTableViewCell ()

@property (nonatomic, strong) UILabel *dataLB;
@property (nonatomic, strong) UILabel *descLB;
@property (nonatomic, strong) UILabel *percentLB;
@property (nonatomic, strong) UIImageView *customImageView;

@property (nonatomic, strong) UIView *lineView;

@end


@implementation JHBoss_GeneralTableViewCell

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
    
    _dataLB = [[UILabel alloc] init];
    _dataLB.font = DEF_SET_BOLDFONT(30);
    _dataLB.textColor = DEF_COLOR_333339;
    [self.contentView addSubview:self.dataLB];
    [_dataLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.mas_left).with.offset(30);
        make.centerY.equalTo(self);
    }];
    
    _descLB = [[UILabel alloc] init];
    _descLB.font = DEF_SET_FONT(13);
    _descLB.textColor = DEF_COLOR_A1A1A1;
    [self.contentView addSubview:self.descLB];
    [_descLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.center.equalTo(self);
    }];
    
    _percentLB = [[UILabel alloc] init];
    _percentLB.font = DEF_SET_FONT(13);
    _percentLB.textColor = DEF_COLOR_FF4747;
    [self.contentView addSubview:self.percentLB];
    [_percentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-42.5);
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

- (void)setModel:(JHBoss_GeneralModel *)model
{
    _model = model;
    _dataLB.text = model.data;
    _descLB.text = model.title;
    _percentLB.text = model.compare.doubleValue < 0 ? [NSString stringWithFormat:@"%g%%", model.compare.doubleValue] : [NSString stringWithFormat:@"+%g%%", model.compare.doubleValue];
    _percentLB.textColor = model.compare.doubleValue < 0 ? DEF_COLOR_6E6E6E : DEF_COLOR_FF4747;
}

@end
