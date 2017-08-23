//
//  JHBoss_GeneralCollectionViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_GeneralCollectionViewCell.h"

@interface JHBoss_GeneralCollectionViewCell ()

@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UILabel *titleLB;

@end


@implementation JHBoss_GeneralCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    @weakify(self);
    
    _imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _imageBtn.size = CGSizeMake(40, 40);
    _imageBtn.userInteractionEnabled = NO;
    [self addSubview:_imageBtn];
    [_imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(0);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _titleLB = [[UILabel alloc] init];
    _titleLB.font = DEF_SET_FONT(13);
    _titleLB.textColor = DEF_COLOR_B48645;
    [self addSubview:_titleLB];
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.mas_bottom);
        make.centerX.equalTo(self);
    }];
    
}


#pragma mark - setter/getter

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self.imageBtn setImage:image forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLB.text = title;
}

- (void)setModel:(JHBoss_GeneralCollectionModel *)model
{
    _model = model;
    self.titleLB.text = model.title;
    self.imageBtn.badgeValue = model.noticeCount.integerValue ? model.noticeCount.stringValue : nil;
    self.imageBtn.badgeOriginX = 28;
}

@end
