//
//  JHBoss_PayResultAlertView.h
//  Boss
//
//  Created by jinghankeji on 2017/7/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHBoss_PayResultAlertView : UIView
@property (nonatomic, copy) void(^sureHandler)();
-(instancetype)initWithTitle:(NSString *)title image:(NSString *)image btnTitle:(NSString *)btnTitle;
-(void)show;

@end
