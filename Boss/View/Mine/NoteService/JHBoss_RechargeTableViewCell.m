//
//  JHBoss_RechargeTableViewCell.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_RechargeTableViewCell.h"

@interface JHBoss_RechargeTableViewCell ()

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *displayLabel;

@end

@implementation JHBoss_RechargeTableViewCell

#pragma mark - Private Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    
    return self;
}

- (void)createUI {
    
    [self.contentView addSubview:self.displayLabel];
    
    [self.displayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@15);
        make.width.equalTo(@20).priorityLow(250);
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(30);
    }];
    
    
    [self.contentView addSubview:self.countLabel];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.displayLabel);
        make.width.equalTo(@20).priorityLow(250);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.displayLabel.mas_bottom).offset(5);
    }];
    
}

#pragma mark - Getter And Setter 

- (void)setRechargeDetail:(NSString *)rechargeDetail {
    
    _rechargeDetail      = rechargeDetail;
    
    self.countLabel.text = [NSString stringWithFormat:@"¥ %@",DEF_OBJECT_TO_STIRNG(rechargeDetail)];
    
}

- (UILabel *)countLabel {
    
    if (!_countLabel) {
        
        _countLabel      = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:30];
        _countLabel.textColor     = [UIColor colorWithRGBValue:150 g:88 b:0];
        _countLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _countLabel;
}

- (UILabel *)displayLabel {

    if (!_displayLabel) {
        _displayLabel      = [[UILabel alloc] init];
        _displayLabel.text = @"钱包余额(元)";
        _displayLabel.font = [UIFont systemFontOfSize:12];
        _displayLabel.textColor     = [UIColor colorWithRGBValue:161 g:161 b:161];
        _displayLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _displayLabel;
}

@end
