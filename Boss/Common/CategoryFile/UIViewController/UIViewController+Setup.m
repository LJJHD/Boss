//
//  UIViewController+Setup.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UIViewController+Setup.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>
#import "JHNavigationBar.h"
#import "UMMobClick/MobClick.h"

@interface UIViewController()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic, readwrite) JHNavigationBar * navBar;
@end

static const void * kNavBarKey = &kNavBarKey;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation UIViewController (Setup)

+ (void)load{
    [NSObject swizzlingClass:self fromSEL:@selector(viewDidLoad) toSEL:@selector(override_viewDidLoad)];
    [NSObject swizzlingClass:self fromSEL:@selector(viewWillAppear:) toSEL:@selector(override_viewWillAppear:)];
    [NSObject swizzlingClass:self fromSEL:@selector(viewWillDisappear:) toSEL:@selector(override_viewWillDisappear:)];
}

- (void)override_viewDidLoad{
    NSString * className = NSStringFromClass(self.class);

    [self override_viewDidLoad];
    
    //后面添加，应为CRM项目添加为了前缀
    NSRange range = [className rangeOfString:@"_" options:NSLiteralSearch];
    if (!range.length) {
        return;
    }
    NSString * CRMHeadCharater = [className substringWithRange:NSMakeRange(0, range.location + range.length)];

    if ([CRMHeadCharater isEqualToString:@"JHCRM_"] || [CRMHeadCharater isEqualToString:@"JHBoss_"]){

        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.backgroundColor = DEF_COLOR_F5F5F5;
        
        
        if ([self respondsToSelector:@selector(disableAutomaticSetNavBar)] && [self disableAutomaticSetNavBar] == YES) {
            
        }else{
            self.navBar = [[JHNavigationBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
            [self.view addSubview:self.navBar];
            self.navBar.backgroundColor = DEF_COLOR_CDA265;
            [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.offset(0);
                make.width.offset(DEF_WIDTH);
                make.top.offset(0);
                make.height.offset(64);
            }];
            @weakify(self);
            [[self.navBar.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton * leftBtn) {
                @strongify(self);
                if ([self respondsToSelector:@selector(onClickLeftNavButton:)]) {
                    [self onClickLeftNavButton:leftBtn];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
            [[self.navBar.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton * rightBtn) {
                @strongify(self);
                if ([self respondsToSelector:@selector(onClickRightNavButton:)]) {
                    [self onClickRightNavButton:rightBtn];
                }
            }];
            [self.navBar updateBackgroundColor:DEF_COLOR_CDA265];
            if (self.navigationController.viewControllers.count > 1) {
                [self.navBar.leftBtn setImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)override_viewWillAppear:(BOOL)animated {
    [self override_viewWillAppear:animated];
    NSString * className = NSStringFromClass(self.class);
    [MobClick beginLogPageView:className];
}

- (void)override_viewWillDisappear:(BOOL)animated
{
    NSString * className = NSStringFromClass(self.class);
    [MobClick endLogPageView:className];
    [self override_viewWillDisappear:animated];
}

#pragma mark setter & getter

- (void)setNavBar:(JHNavigationBar *)navBar{
    objc_setAssociatedObject(self, kNavBarKey, navBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JHNavigationBar *)navBar{
    
    return (JHNavigationBar *)objc_getAssociatedObject(self, kNavBarKey);
}

- (UIButton *)leftNavButton{
    return self.navBar.leftBtn;
}

- (UIButton *)rightNavButton{
    return self.navBar.rightBtn;
}
- (UILabel*)titleLabel
{
    return  self.navBar.titleLabel;
}

- (NSString*)jhtitle{
   return  self.titleLabel.text;
}
- (void)setJhtitle:(NSString *)jhtitle
{
    self.titleLabel.text = jhtitle;
}
/**
 修改状态栏颜色
 要修改某个vc的话重写此方法就行le
 **/
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
