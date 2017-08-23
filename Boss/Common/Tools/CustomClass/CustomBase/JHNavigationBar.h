//
//  JHNavigationBar.h
//  JinghanLife
//
//  Created by 晶汉mac on 2016/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHNavigationBar : UIView
/**导航栏左边按钮**/
@property(nonatomic,retain)UIButton *leftBtn;
/**导航title**/
@property(nonatomic,retain)UILabel *titleLabel;
/**导航栏右边按钮**/
@property(nonatomic,retain)UIButton *rightBtn;
/**背景图片**/
@property (nonatomic,strong) UIImageView    *backgroundImageView;
/**背景图片**/
@property (nonatomic,strong) UIImage    *backgroundImage;

@property (nonatomic,strong)UIView *overlay;

/**导航栏隐藏底部线**/
- (void)hideLineOfNavtionBar;

- (void)showLineOfNavtionBar;

/**导航栏颜色**/
- (void)updateBackgroundColor:(UIColor *)backgroundColor;
@end
