//
//  UIViewController+Setup.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHNavigationBar;
@interface UIViewController (Setup)

@property (strong, nonatomic, readonly) JHNavigationBar * navBar;
@property (strong, nonatomic, readonly) UIButton * leftNavButton;
@property (strong, nonatomic, readonly) UIButton * rightNavButton;
@property (strong, nonatomic, readonly) UILabel * titleLabel;
@property (strong, nonatomic, readwrite) NSString *jhtitle;


/**
 *  点击左导航栏按钮
 */
- (void)onClickLeftNavButton:(UIButton *)leftNavButton;

/**
 * 点击右导航栏按钮
 */
- (void)onClickRightNavButton:(UIButton *)rightNavButton;

/**
 * 如果不需要自动添加 navbar，return yes
 */
- (BOOL)disableAutomaticSetNavBar;


@end
