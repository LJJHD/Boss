//
//  JHTabBar.h
//  JinghanLife
//
//  Created by 晶汉mac on 2016/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTabBarButton.h"
@class JHTabBar;
@protocol JHTabBarDelegate <NSObject>
@optional
/**
 点击子item的代理方法
 **/
- (void)tabBar:(JHTabBar *)tabBar didSelectButtonFrom:(NSInteger)from to:(NSInteger)to;


@end

@interface JHTabBar : UIView
/**
 *  添加一个选项卡按钮
 *
 *  @param item 选项卡按钮对应的模型数据(标题\图标\选中的图标)
 */
- (void)addTabBarButton:(UITabBarItem *)item;

- (void)tabBarButtonClick:(JHTabBarButton *)button;

@property (nonatomic, weak) JHTabBarButton *selectedTabBarButton;

@property (nonatomic, strong) NSMutableArray *tabBarButtons;

@property (nonatomic,strong) UIButton *homeBtnImageview;

@property (nonatomic, weak) id<JHTabBarDelegate> delegate;

@end

