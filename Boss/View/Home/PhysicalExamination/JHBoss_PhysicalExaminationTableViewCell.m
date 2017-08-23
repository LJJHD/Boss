//
//  JHBoss_PhysicalExaminationTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PhysicalExaminationTableViewCell.h"

@interface JHBoss_PhysicalExaminationTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLB;
@property (nonatomic, strong) UIImageView *customImageView;
@property (nonatomic, strong) UIView *lineView;

@end


@implementation JHBoss_PhysicalExaminationTableViewCell

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
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.backgroundColor = DEF_COLOR_B48645;
    _iconImageView.layer.cornerRadius = 4.5;
    _iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(9, 9));
    }];
    
    _textLB = [[UILabel alloc] init];
    _textLB.font = DEF_SET_FONT(15);
    _textLB.textColor = DEF_COLOR_6E6E6E;
    [self.contentView addSubview:self.textLB];
    [_textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(11);
        make.centerY.equalTo(self);
    }];
    
    _customImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.customImageView];
    [_customImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-25);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.contentView addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}


#pragma mark - setter/getter

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.textLB.text = title;
}

- (void)setStartAnimation:(BOOL)startAnimation
{
    _startAnimation = startAnimation;
    if (startAnimation) {
        self.iconImageView.backgroundColor = DEF_COLOR_CDA265;
        self.textLB.textColor = DEF_COLOR_A1A1A1;
        self.customImageView.image = DEF_IMAGENAME(@"1.1.5.1_icon_loading");
        
        CABasicAnimation * rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
        rotationAnimation.duration = 0.5;
        rotationAnimation.repeatCount = MAXFLOAT;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [self.customImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    } else {
        self.iconImageView.backgroundColor = DEF_COLOR_CDA265;
        self.textLB.textColor = DEF_COLOR_6E6E6E;
        self.customImageView.image = DEF_IMAGENAME(@"1.1.5.1_icon_done");
    }
}

@end
