//
//  JHBaseNavigationController.m
//  JinghanLife
//
//  Created by 晶汉mac on 2016/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHBaseNavigationController.h"

@interface JHBaseNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation JHBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    // 获取系统自带滑动手势的target对象
//    id target = self.interactivePopGestureRecognizer.delegate;
//    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    // 设置手势代理，拦截手势触发
//    pan.delegate = self;
//    // 给导航控制器的view添加全屏滑动手势
//    [self.view addGestureRecognizer:pan];
//    // 禁止使用系统自带的滑动手势
//    self.interactivePopGestureRecognizer.enabled = NO;
    self.navigationBar.hidden = YES;
}

// 每次触发手势之前都会询问下代理，是否触发。用来拦截手势触发
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    // 只有非根控制器才有滑动返回功能，根控制器没有。
    if (self.childViewControllers.count == 1) {
        return NO;  
    }  
    return YES;
}
/*果当前控制器处于导航控制器中，
 则系统会调用导航控制器的preferredStatusBarStyle方法，而不会调用当前控制器，
 如果何让系统调当前控制器的preferredStatusBarStyle方法呢？
 在导航控制器中实现该方法，返回你希望调用的控制器给系统，
 如return self.topViewController; */

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.topViewController;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
