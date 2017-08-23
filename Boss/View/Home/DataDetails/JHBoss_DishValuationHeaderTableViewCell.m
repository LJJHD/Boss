//
//  JHBoss_DishValuationHeaderTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_DishValuationHeaderTableViewCell.h"

@interface JHBoss_DishValuationHeaderTableViewCell ()

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIView *lineView;

@end


@implementation JHBoss_DishValuationHeaderTableViewCell

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
        make.left.equalTo(self.mas_left).with.offset(25);
        make.top.mas_equalTo(11);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.contentView addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setCountOfValuations:(NSString *)countOfValuations
{
    _countOfValuations = countOfValuations;
    
    self.titleLB.text = [NSString stringWithFormat:@"菜品评价(%@)", countOfValuations];
    NSMutableAttributedString *itemAttributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLB.text];
    [itemAttributedString addAttribute:NSForegroundColorAttributeName value:DEF_COLOR_CDA265 range:NSMakeRange(5, countOfValuations.length)];
    self.titleLB.attributedText = itemAttributedString;
}

@end
