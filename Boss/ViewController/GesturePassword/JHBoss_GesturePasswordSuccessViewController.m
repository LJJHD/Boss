//
//  JHBoss_GesturePasswordSuccessViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_GesturePasswordSuccessViewController.h"
#import "JHTabBarController.h"
#import "JHBaseNavigationController.h"
@interface JHBoss_GesturePasswordSuccessViewController ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *tipLB;
@property (nonatomic, strong) NSMutableArray *imagesArr;//存放image

@end


@implementation JHBoss_GesturePasswordSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    @weakify(self);
    
    /*
    _tipLB = [[UILabel alloc] init];
    _tipLB.text = @"设置成功！";
    _tipLB.textColor = DEF_COLOR_CDA265;
    _tipLB.font = DEF_SET_FONT(17);
    [self.view addSubview:self.tipLB];
    [self.tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(64);
    }];
    */
    
    
    UIImageView *backView = [[UIImageView alloc]initWithImage:DEF_IMAGENAME(@"0.3_bg_bg")];
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.and.top.bottom.mas_equalTo(0);
    }];
    
    
    _imagesArr = [NSMutableArray array];
    
    for (int i = 1; i <= 13; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bosss-shoushi-%d",i]];
        [_imagesArr addObject:image];
    }

    
    _iconImageView = [[UIImageView alloc] initWithImage:DEF_IMAGENAME(@"5.1.5_icon_logo")];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.animationDuration = 0.8;
    _iconImageView.animationImages = self.imagesArr;
    [self.view addSubview:self.iconImageView];

    [_iconImageView startAnimating];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(160, 160));
    }];
    
    [self performSelector:@selector(setRootVC) withObject:self afterDelay:0.8];
}

-(void)setRootVC{


    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    JHTabBarController * rootVc = [[JHTabBarController alloc]init];
    JHBaseNavigationController *nav= [[JHBaseNavigationController alloc]initWithRootViewController:rootVc];
    nav.navigationBarHidden = YES;
    window.rootViewController  = nav;
}




- (BOOL)disableAutomaticSetNavBar
{
    return YES;
}

@end
