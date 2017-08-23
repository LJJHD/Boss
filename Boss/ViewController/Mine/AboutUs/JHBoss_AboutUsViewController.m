//
//  JHBoss_AboutUsViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_AboutUsViewController.h"

@interface JHBoss_AboutUsViewController ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *verLB;
@property (nonatomic, strong) UILabel *urlLB;
@property (nonatomic, strong) UILabel *nameLB;

@end

@implementation JHBoss_AboutUsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    @weakify(self);
    
    self.jhtitle = @"关于晶汉";
    
    _verLB = [[UILabel alloc] init];
    _verLB.text = [@"V " stringByAppendingString: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    _verLB.textColor = DEF_COLOR_333339;
    _verLB.font = DEF_SET_FONT(15);
    [self.view addSubview:self.verLB];
    [self.verLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(64);
    }];
    
    _iconImageView = [[UIImageView alloc] initWithImage:DEF_IMAGENAME(@"5.1.5_icon_logo")];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.verLB.mas_top).with.offset(-50);
        make.centerX.equalTo(self.verLB);
        make.size.mas_equalTo(CGSizeMake(144, 144));
    }];
    
    _urlLB = [[UILabel alloc] init];
    _urlLB.text = @"www.jinghanit.com";
    _urlLB.textColor = DEF_COLOR_A1A1A1;
    _urlLB.font = DEF_SET_FONT(13);
    [self.view addSubview:self.urlLB];
    [self.urlLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-88.5);
    }];
    
    _nameLB = [[UILabel alloc] init];
    _nameLB.text = @"上海晶汉信息科技有限公司";
    _nameLB.textColor = DEF_COLOR_A1A1A1;
    _nameLB.font = DEF_SET_FONT(13);
    [self.view addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.urlLB.mas_bottom).with.offset(5);
    }];
}

@end
