//
//  JHBoss_DataDetailsTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_DataDetailsTableViewCell.h"

@interface JHBoss_DataDetailsTableViewCell ()

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *DataLB;
@property (nonatomic, strong) UILabel *compareLB;
@property (nonatomic, strong) UILabel *compareDataLB;

@end



@implementation JHBoss_DataDetailsTableViewCell

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
    
    _titleLB = [[UILabel alloc] init];
    _titleLB.font = DEF_SET_FONT(12);
    _titleLB.textColor = DEF_COLOR_A1A1A1;
    [self.contentView addSubview:self.titleLB];
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.mas_left).with.offset(30);
        make.top.mas_equalTo(15);
    }];
    
    _DataLB = [[UILabel alloc] init];
    _DataLB.font = DEF_SET_FONT(40);
    _DataLB.textColor = DEF_COLOR_333339;
    [self.contentView addSubview:self.DataLB];
    [_DataLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.mas_left).with.offset(30);
        make.top.equalTo(self.titleLB).with.offset(16);
    }];
    /*
    _compareDataLB = [[UILabel alloc] init];
    _compareDataLB.font = DEF_SET_FONT(13);
    _compareDataLB.textColor = DEF_COLOR_FF4747;
    [self.contentView addSubview:self.compareDataLB];
    [_compareDataLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.mas_right).with.offset(-30);
        make.centerY.equalTo(self);
    }];
    
    _compareLB = [[UILabel alloc] init];
    _compareLB.font = DEF_SET_FONT(13);
    _compareLB.textColor = DEF_COLOR_333339;
    [self.contentView addSubview:self.compareLB];
    [_compareLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.compareDataLB.mas_left).with.offset(-10);
        make.centerY.equalTo(self.compareDataLB);
    }];
    
    _compareLB.text = @"较昨天";
     */
}


#pragma mark - setter/getter

- (void)setModel:(JHBoss_TurnoverOrFlowOrPriceModel *)model
{
    _model = model;
    
    if (model.data.doubleValue/100 >= 1000000) {
        
        self.titleLB.text = [[[model.name stringByAppendingString:@"("] stringByAppendingString:@"万元"] stringByAppendingString:@")"];
        self.DataLB.text = [NSString stringWithFormat:@"%g", model.data.doubleValue/100/10000];//转成万元

    }else{
    
        self.titleLB.text = [[[model.name stringByAppendingString:@"("] stringByAppendingString:@"元"] stringByAppendingString:@")"];
        self.DataLB.text = [NSString stringWithFormat:@"%g", model.data.doubleValue/100];
    }
}

@end
