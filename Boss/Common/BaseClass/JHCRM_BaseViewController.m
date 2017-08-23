//
//  JHBaseViewController.m
//  JinghanLife
//
//  Created by 晶汉mac on 2016/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHCRM_BaseViewController.h"

@interface JHCRM_BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation JHCRM_BaseViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self baseSetting];
}
//- (void)baseSetting
//{

//    //在self.view上添加子视图
//    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:view];
//
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.view.backgroundColor = DEF_COLOR_F5F5F5;
//    self.navBar = [[JHNavigationBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
//    [self.view addSubview:self.navBar];
//    self.navBar.backgroundImage = [UIImage imageNamed:@"nav_home"];
//
//    [self.navBar.leftBtn addTarget:self action:@selector(leftnavBarBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navBar.rightBtn addTarget:self action:@selector(rightnavBarBtnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    if (self.navigationController.viewControllers.count>1)
//    {
//        [self addLeftNavigationButtonImageName:@"icon_view_back"];
//    }
//    [self.navBar updateBackgroundColor:DEF_COLOR_CDA265];
//    
//}
//- (void)addLeftNavigationTitleButton:(NSString *)title
//{
//    CGFloat width = [self returnTitleWidth:title];
//
//    [self.navBar.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(@(10));
//        make.centerY.mas_equalTo(10);
//        make.width.mas_equalTo(width+1);
//        make.height.mas_equalTo(20);
//        
//    }];
//    
//    [self.navBar.leftBtn setTitle:title forState:UIControlStateNormal];
//
//}
//- (void)addRightNavigationTitleButton:(NSString *)title
//{
//    CGFloat width = [self returnTitleWidth:title];
//    
//    [self.navBar.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.mas_equalTo(@(-10));
//        make.centerY.mas_equalTo(10);
//        make.width.mas_equalTo(width+1);
//        make.height.mas_equalTo(20);
//        
//    }];
//    
//    [self.navBar.rightBtn setTitle:title forState:UIControlStateNormal];
//}
//- (void)addRightNavigationButtonImageName:(NSString *)imageName
//{
//    [self.navBar.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.trailing.mas_equalTo(@(-5));
//        make.centerY.mas_equalTo(8);
//        make.width.mas_equalTo(44);
//        make.height.mas_equalTo(44);
//        
//    }];
//    
//    [self.navBar.rightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//}
//- (void)addLeftNavigationButtonImageName:(NSString *)imageName
//{
//    [self.navBar.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.mas_equalTo(@(5));
//        make.centerY.mas_equalTo(8);
//        make.width.mas_equalTo(44);
//        make.height.mas_equalTo(44);
//        
//    }];
//    
//    [self.navBar.leftBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//}
//
//- (void)leftnavBarBtnClick:(UIButton*)left
//{
//    if (self.navigationController.viewControllers.count>1) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
//- (void)rightnavBarBtnBtnClick:(UIButton*)right
//{
//    
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}
//- (CGFloat)returnTitleWidth:(NSString *)title
//{
//    CGSize size = [JHUtility getTextWith:title withFont:14 withWidth:MAXFLOAT withHeight:MAXFLOAT];
//    return size.width;
//}
@end
