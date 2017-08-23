//
//  JHBoss_PayMethodTableViewCell.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PayMethodTableViewCell.h"

#import "JHBoss_PayMehtodItem.h"

@interface JHBoss_PayMethodTableViewCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subTitleLbl;

@property (nonatomic, strong) UIImageView *rightImageView;

@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation JHBoss_PayMethodTableViewCell

#pragma mark - Private Method
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    //右边标志
    [self.contentView addSubview:self.rightImageView];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(25);
        make.height.equalTo(self.contentView).multipliedBy(0.5);
        make.width.equalTo(self.contentView.mas_height).multipliedBy(0.5);
    }];
    
    //主题
    [self.contentView addSubview:self.titleLbl];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20).priorityLow(250);
        make.top.equalTo(self.rightImageView).offset(-5);
        make.height.equalTo(self.contentView).multipliedBy(0.3);
        make.left.equalTo(self.rightImageView.mas_right).offset(10);
    }];
    
    //副标题
    [self.contentView addSubview:self.subTitleLbl];
    
    [self.subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.left.equalTo(self.titleLbl);
        make.width.equalTo(@20).priorityLow(250);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(5);
    }];
    
    //选择按钮
    [self.contentView addSubview:self.selectButton];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.rightImageView);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    
}

- (void)clickPayButton:(UIButton *)btn {

    btn.selected = !btn.selected;
    
}

#pragma mark - Gettter And Setter 

//赋值
- (void)setPayItem:(JHBoss_PayMehtodItem *)payItem {
    
    _payItem = payItem;
    
    self.titleLbl.text        = payItem.title;
    self.subTitleLbl.text     = payItem.subTitle;
    self.rightImageView.image = [UIImage imageNamed:payItem.rightImagePath];
    
    [self.selectButton setBackgroundImage:[UIImage imageNamed:payItem.leftImagePath] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:payItem.leftHightPath] forState:UIControlStateSelected];

    self.selectButton.selected = payItem.hight;
}

- (UILabel *)titleLbl {
    
    if (!_titleLbl) {
        _titleLbl               = [[UILabel alloc] init];
        _titleLbl.font          = [UIFont systemFontOfSize:15];
        _titleLbl.textColor     = [UIColor blackColor];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
    }
    
    return _titleLbl;
}

- (UILabel *)subTitleLbl {
    
    if (!_subTitleLbl) {
        _subTitleLbl = [[UILabel alloc] init];
        _subTitleLbl.textColor = [UIColor colorWithRGBValue:161 g:161 b:161];
        _subTitleLbl.font = [UIFont systemFontOfSize:10];
    }
    
    return _subTitleLbl;
}

- (UIImageView *)rightImageView {
    
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return _rightImageView;
}

- (UIButton *)selectButton {

    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.userInteractionEnabled = NO;
//        [_selectButton addTarget:self action:@selector(clickPayButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _selectButton;
}

@end
