//
//  JHBoss_PayResultAlertView.m
//  Boss
//
//  Created by jinghankeji on 2017/7/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PayResultAlertView.h"

@interface JHBoss_PayResultAlertView ()
@property (nonatomic, copy)NSString *titleStr;
@property (nonatomic, copy)NSString *imageStr;
@property (nonatomic, copy)NSString *btnTitleStr;

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIView *backView;//白色的背景view
@property (nonatomic, strong) UIView *windowView;
@property (nonatomic, strong) UIView *topView;
@end

@implementation JHBoss_PayResultAlertView

-(instancetype)initWithTitle:(NSString *)title image:(NSString *)image btnTitle:(NSString *)btnTitle{

    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.backgroundColor = [UIColor colorWithRGBValue:0 g:0 b:0 alpha:0.4];
        _titleStr = title;
        _imageStr = image;
        _btnTitleStr = btnTitle;
        [self createUI];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove)];
        [self addGestureRecognizer:tap];

    }
    return self;
}
-(void)createUI{
    @weakify(self)
    self.backView = [UIView new];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = 12;
    self.backView.layer.masksToBounds = YES;
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(MYDIMESCALE(62.5));
        make.right.equalTo(self).offset(MYDIMESCALE(-62.6));
        make.height.mas_equalTo(MYDIMESCALE(130));
    }];
    
    
    _topView = [[UIView alloc]initWithFrame:CGRectZero];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:_topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.backView);
        make.left.equalTo(self.backView.mas_left);
        make.right.equalTo(self.backView.mas_right);
        make.height.mas_equalTo(MYDIMESCALE(84));
    }];
    

    self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.imageView.image = DEF_IMAGENAME(self.imageStr);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_topView addSubview:self.imageView];
    
    self.titleLB = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLB.text =self.titleStr;
    self.titleLB.font = [UIFont systemFontOfSize:15];
    self.titleLB.textColor = [UIColor colorWithRGBValue:51 g:51 b:57];
    [_topView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.centerX.equalTo(self.topView);
        make.centerY.equalTo(self.imageView.mas_centerY);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.topView).offset(MYDIMESCALE(8));
        make.right.equalTo(self.titleLB.mas_left).offset(MYDIMESCALE(-10));
        make.centerY.equalTo(self.topView);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];


    UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor colorWithRGBValue:215 g:215 b:215];
    [_topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self.topView);
        make.right.equalTo(self.topView);
        make.bottom.equalTo(self.topView);
    }];
    
    self.btn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.btn setTitle:self.btnTitleStr];
    [self.btn setTitleColor:[UIColor colorWithRGBValue:150 g:88 b:0] forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.backView);
        make.right.equalTo(self.backView);
        make.height.mas_equalTo(MYDIMESCALE(45));
        make.top.equalTo(self.topView.mas_bottom);
    }];
    
}

-(UIView *)windowView{

    if (!_windowView) {
        _windowView = [UIApplication sharedApplication].keyWindow;
    }
    return _windowView;
}

-(void)show{

    [self.windowView addSubview:self];
}

-(void)hide{

    if (self.sureHandler) {
        self.sureHandler();
    }
    [self removeFromSuperview];
}

-(void)remove{

    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
