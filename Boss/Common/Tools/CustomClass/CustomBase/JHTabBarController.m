//
//  JHTabBarController.m
//  JinghanLife
//
//  Created by 晶汉mac on 2016/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHTabBarController.h"
#import "JHTabBar.h"
#import "JHBoss_HomeViewController.h"
#import "JHBoss_ManagePageViewController.h"
#import "JHBoss_NewsListViewController.h"
#import "JHBoss_MineViewController.h"
//#import "BHBPopView.h"
@interface JHTabBarController ()<JHTabBarDelegate>
@property (nonatomic, strong) JHTabBar *customTabBar;

@end

@implementation JHTabBarController
                                                        
#pragma mark init方法内部调用

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self setupAllChildVCs];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubViews];
  
}
- (void)initSubViews
{
    [self.view addSubview:self.customTabBar];
    //改变tabbar 线条颜色
//    [self.tabBar setBackgroundImage:[self imageWithColor:DEF_COLOR_ECECEC size:CGSizeMake(DEF_WIDTH, 0.5)]];
//    [self.tabBar setShadowImage:[self imageWithColor:DEF_COLOR_ECECEC size:CGSizeMake(DEF_WIDTH, 0.5)]];
 
}
#pragma mark 初始化自己的所有子控制器
- (void)setupAllChildVCs
{
 
    JHBoss_HomeViewController *homePageVC = [[JHBoss_HomeViewController alloc] init];
    [self setupOneChildVC:homePageVC title:@"数据" imageName:@"tablebar_icon_data_default" selectedImageName:@"tablebar_icon_data_selected"];
    
    JHBoss_ManagePageViewController *managePageVC = [[JHBoss_ManagePageViewController alloc] init];
    [self setupOneChildVC:managePageVC title:@"管理" imageName:@"tablebar_icon_manage_default" selectedImageName:@"tablebar_icon_manage_selected"];
    
    
    JHBoss_NewsListViewController *inforVc = [[JHBoss_NewsListViewController alloc] init];
    [self setupOneChildVC:inforVc title:@"资讯" imageName:@"tablebar_icon_info_default" selectedImageName:@"tablebar_icon_info_selected"];
    
    JHBoss_MineViewController *mineVc1 = [[JHBoss_MineViewController alloc] init];
    [self setupOneChildVC:mineVc1 title:@"个人中心" imageName:@"tablebar_icon_personalcenter_default" selectedImageName:@"tablebar_icon_personalcenter_selected"];
    
}
#pragma mark 初始化一个子控制器

- (void)setupOneChildVC:(UIViewController *)child title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    
    
        child.title = title;
        
        child.tabBarItem.image = [UIImage imageNamed:imageName];
        
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        
        child.tabBarItem.selectedImage = selectedImage;
    
    [self addChildViewController:child];
    
    [self.customTabBar addTabBarButton:child.tabBarItem];
}

#pragma mark -XCTabBarDelegate
- (void)tabBar:(JHTabBar *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
}

- (void)setIsTabBarHidden:(BOOL)isTabBarHidden
{
    
    self.tabBar.hidden  = isTabBarHidden;
    self.customTabBar.hidden = isTabBarHidden;
    //self.rectImageView.hidden = isTabBarHidden;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 移除系统自动产生的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        // 私有API  UITabBarButton
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
}
- (JHTabBar *)customTabBar
{
    if (!_customTabBar)
    {
        _customTabBar = [[JHTabBar alloc] init];
        _customTabBar.frame = self.tabBar.frame;
        _customTabBar.delegate = self;
        
    }
    return _customTabBar;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <=0 || size.height <=0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO, 0);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
