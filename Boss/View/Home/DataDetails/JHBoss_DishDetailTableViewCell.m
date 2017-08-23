//
//  JHBoss_DishDetailTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_DishDetailTableViewCell.h"

@interface JHBoss_DishDetailTableViewCell ()

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *DataLB;
@property (nonatomic, strong) UILabel *compareLB;
@property (nonatomic, strong) UILabel *compareDataLB;

@end


@implementation JHBoss_DishDetailTableViewCell

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
    
    _titleLB.text = @"售出份数";
}


#pragma mark - setter/getter

- (void)setModel:(JHBoss_DishDetailModel *)model
{
    _model = model;
    self.DataLB.text = model.data;
   
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    if (JHBoss_NoteService == self.enterIntoType) {
        
        self.titleLB.text = @"钱包余额(元)";
    }
    
}

-(void)setMoney:(NSString *)money{

    _money = money;
    if (JHBoss_NoteService == self.enterIntoType) {
        _DataLB.font = DEF_SET_FONT(36);
        _DataLB.textColor = DEF_COLOR_965800;
       self.DataLB.text = [NSString stringWithFormat:@"￥%g", self.money.doubleValue/100.0];
    }

}

@end
