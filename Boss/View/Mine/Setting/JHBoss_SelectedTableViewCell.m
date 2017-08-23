//
//  JHBoss_SelectedTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_SelectedTableViewCell.h"

@interface JHBoss_SelectedTableViewCell ()

@property (nonatomic, strong) UILabel *textLB;
@property (nonatomic, strong) UIImageView *customImageView;
@property (nonatomic, strong) UIView *lineView;

@end


@implementation JHBoss_SelectedTableViewCell

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
    _shouldShowCheckBox = YES;
    
    _textLB = [[UILabel alloc] init];
    _textLB.font = DEF_SET_FONT(15);
    _textLB.textColor = DEF_COLOR_6E6E6E;
    [self.contentView addSubview:self.textLB];
    
    _customImageView = [[UIImageView alloc] init];
    _customImageView.image = DEF_IMAGENAME(@"5.2.4.1_icon_checkBox");
    [self.contentView addSubview:self.customImageView];
    
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.contentView addSubview:self.lineView];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    @weakify(self);
    
    [_textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(25);
        make.centerY.equalTo(self);
    }];
    
    [_customImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-25);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(11);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _textLB.text = title;
}

- (void)setShouldShowCheckBox:(BOOL)shouldShowCheckBox
{
    _shouldShowCheckBox = shouldShowCheckBox;
    self.customImageView.hidden = !shouldShowCheckBox;
}

- (void)setState:(BOOL)state block:(BOOL)block
{
    _state = state;
    if (self.shouldShowCheckBox) {
        self.textLB.textColor = state ? DEF_COLOR_CDA265 : DEF_COLOR_6E6E6E;
        self.customImageView.hidden = !state;
        if (block) {
            if (self.selectedBlock) {
                self.selectedBlock(state);
            }
        }
    } else {
        self.textLB.textColor = state ? DEF_COLOR_CDA265 : DEF_COLOR_6E6E6E;
    }
}

@end
