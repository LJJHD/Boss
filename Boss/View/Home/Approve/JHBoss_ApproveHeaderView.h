//
//  JHBoss_ApproveHeaderView.h
//  Boss
//
//  Created by sftoday on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuButton;

@protocol JHBoss_ApproveHeaderViewDelegate <NSObject>

@required
- (void)didSelectMenuBtn:(MenuButton *)menuButton;

@end


@interface JHBoss_ApproveHeaderView : UIView
@property (nonatomic, assign) BOOL isShowBottonLine;//是否显示最下面的横线
@property (nonatomic, assign) float leftSpace;//最左边间距
@property (nonatomic, assign) float rightSpace;//最右边间距

#pragma mark -- 颜色相关--
@property (nonatomic, strong) UIColor *itemColor;//默认字体颜色
@property (nonatomic, strong) UIColor *selectItemColor;//选中字体颜色
@property (nonatomic, assign) float itemFont;//默认字体颜色
@property (nonatomic, assign) float selectItemFont;//选中字体颜色
@property (nonatomic, strong) UIColor *ItemBackgroundColor;//背景颜色

@property (nonatomic, strong) UIColor *ViewBackgroundColor;//背景颜色
@property (nonatomic, strong) UIColor *bottomLineColor;//最下面的横线颜色

@property (nonatomic, copy)   NSMutableArray *itemArray;
@property (nonatomic, strong) NSNumber *tabIndex;
@property (nonatomic, weak) id<JHBoss_ApproveHeaderViewDelegate> delegate;
-(void)showApproveHeaderView;
@end


@interface MenuButton : UIButton
@property (nonatomic, assign) NSInteger index;
@end
