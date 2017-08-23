//
//  JHTabBar.m
//  JinghanLife
//
//  Created by 晶汉mac on 2016/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHTabBar.h"


@interface JHTabBar()

@end

@implementation JHTabBar

- (NSMutableArray *)tabBarButtons
{
    if (!_tabBarButtons) {
        self.tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = DEF_COLOR_333339;
        self.clipsToBounds = NO;
    }
    return self;
}

/**
 *  添加一个选项卡按钮
 *
 *  @param item 选项卡按钮对应的模型数据(标题\图标\选中的图标)
 */
- (void)addTabBarButton:(UITabBarItem *)item
{
    
    JHTabBarButton *button = [[JHTabBarButton alloc] init];
    button.item = item;
    if ([item.title isEqualToString:@""]) {
        
    }
    
    [button addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchDown];
    button.tag = self.tabBarButtons.count;
    [self addSubview:button];
    
    [self.tabBarButtons addObject:button];
    
    // 默认让最前面的按钮选中
    if (self.tabBarButtons.count == 1) {
        
        [self tabBarButtonClick:button];
        
    }
    
}

/**
 *  点击选项卡按钮
 */
- (void)tabBarButtonClick:(JHTabBarButton *)button
{
    
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectButtonFrom:to:)]) {
        NSInteger from = self.selectedTabBarButton.tag;
        NSInteger to = button.tag;
        [self.delegate tabBar:self didSelectButtonFrom:from to:to];
    }
    
    self.selectedTabBarButton.selected = NO;
    button.selected = YES;
    self.selectedTabBarButton = button;
}

/**
 *  布局子控件
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setupTabBarButtonFrame];
}

/**
 *  设置选项卡按钮的位置和尺寸(包括按钮内部的title和image)
 */
- (void)setupTabBarButtonFrame
{
    NSInteger count = self.tabBarButtons.count;
    
    CGFloat buttonW = self.width / count;
    
    CGFloat buttonH = self.height;
    
    for (int i = 0; i < count; i++)
    {
        JHTabBarButton *button = self.tabBarButtons[i];
       
        button.width = buttonW;
        
        button.height = buttonH;
        
        CGFloat imageW = 22;
        
        CGFloat imageH = 22;
        
        [button setImageRect:CGRectMake(0, 0, imageW, imageH)];
        
        button.x = buttonW * i;
        button.y = 0;
    }
}

@end
