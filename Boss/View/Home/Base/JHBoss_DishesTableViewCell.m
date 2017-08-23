//
//  JHBoss_DishesTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_DishesTableViewCell.h"

@interface JHBoss_DishesTableViewCell ()

@property (nonatomic, strong) UILabel *numberLB;
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) UILabel *goodNumLB;
@property (nonatomic, strong) UILabel *saleNumLB;
@property (nonatomic, strong) UILabel *percentLB;
@property (nonatomic, strong) UIImageView *customImageView;

@property (nonatomic, strong) UIView *lineView;
//v1.1
@property (nonatomic, strong) UILabel *salesValuesLB;//销量
@property (nonatomic, strong) UILabel *profitLB;//毛利

@end



@implementation JHBoss_DishesTableViewCell

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
    
    _numberLB = [[UILabel alloc] init];
    _numberLB.font = DEF_SET_FONT(13);
    _numberLB.textColor = DEF_COLOR_A1A1A1;
    [self.contentView addSubview:self.numberLB];
    [_numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.mas_left).with.offset(25);
        make.centerY.equalTo(self);
    }];
    
    _nameLB = [[UILabel alloc] init];
    _nameLB.font = DEF_SET_FONT(13);
    _nameLB.textColor = DEF_COLOR_333339;
    [self.contentView addSubview:self.nameLB];
    [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.mas_left).with.offset(65);
        make.centerY.equalTo(self);
    }];
    
    _saleNumLB = [[UILabel alloc] init];
    _saleNumLB.font = DEF_SET_FONT(13);
    _saleNumLB.textColor = DEF_COLOR_A1A1A1;
    [self.contentView addSubview:self.saleNumLB];
    [_saleNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
//        make.left.mas_equalTo(self).with.offset(MYDIMESCALE(160));
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self);
    }];
    
    // update nameLB
    [_nameLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.lessThanOrEqualTo(self.saleNumLB.mas_left).with.offset(-6);
    }];
    
//    _profitLB = [[UILabel alloc]init];
//    _profitLB.font = DEF_SET_FONT(13);
//    _profitLB.textColor = DEF_COLOR_A1A1A1;
//    _profitLB.text = @"68";
//    [self.contentView addSubview:self.profitLB];
//    [_profitLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.centerX.equalTo(self.contentView.mas_centerX).with.offset(MYDIMESCALE(10));
//        make.centerY.equalTo(self);
//    }];
    
    
    _goodImageView = [[UIImageView alloc] initWithImage:DEF_IMAGENAME(@"1.2_icon_like")];
    [self.contentView addSubview:self.goodImageView];
    [_goodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView.mas_right).with.offset(MYDIMESCALE(-130));
        make.size.mas_equalTo(CGSizeMake(12, 11));
        make.centerY.equalTo(self);
    }];
    
    
    
    _goodNumLB = [[UILabel alloc] init];
    _goodNumLB.font = DEF_SET_FONT(13);
    _goodNumLB.textColor = DEF_COLOR_A1A1A1;
    [self.contentView addSubview:self.goodNumLB];
    [_goodNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.goodImageView.mas_right).with.offset(3);
        make.centerY.equalTo(self);
    }];
    
    _percentLB = [[UILabel alloc] init];
    _percentLB.font = DEF_SET_FONT(13);
    _percentLB.textColor = DEF_COLOR_A1A1A1;
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

- (void)setModel:(JHBoss_DishModel *)model
{
    _model = model;
    _nameLB.text = model.dishName;
    _goodNumLB.text = model.highOpinionNum.stringValue;
    _saleNumLB.text = model.dishSaleNum.stringValue;
    _percentLB.text = [NSString stringWithFormat:@"%g%%",model.rateOfAllDishes.doubleValue *100];
}

- (void)setSortNum:(NSInteger)sortNum
{
    _sortNum = sortNum;
    _numberLB.text = [NSString stringWithFormat:@"%zd", sortNum];
}

@end
