//
//  JHBoss_PageViewController.h
//  Boss
//
//  Created by sftoday on 2017/4/11.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHBoss_PageViewController;

@protocol PageViewControllerScrollDelegate <NSObject>
@optional
/**
 *  滚动切换视图返回当前页
 *
 *  @param pageViewController 当前控制器
 *  @param currentIndex       当前显示页面
 */
- (void)pageViewController:(JHBoss_PageViewController *)pageViewController currentIndex:(NSInteger)currentIndex;
/**
 *  滚动切换视图返回当前滚动偏移量
 *
 *  @param pageViewController 当前控制器
 *  @param currentOffset      当前偏移量
 */
- (void)pageViewController:(JHBoss_PageViewController *)pageViewController currentOffset:(CGFloat)currentOffset;

@end


@interface JHBoss_PageViewController : UIViewController

@property (nonatomic , strong) NSMutableArray *viewControllers; //需要显示的vc数组
@property (nonatomic , strong) UIPageViewController *pageController; //提供pageVc供外部使用
@property (nonatomic , assign) BOOL pageScrollEnabled; //是否允许pageVc滚动 默认是NO
@property (nonatomic , weak) id<PageViewControllerScrollDelegate> delegate; //返回当前显示页面和偏移量的代理


/**
 切换当前控制器

 @param index 控制器索引
 @param animated 是否执行动画
 */
-(void)setCurrentViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated;

@end
