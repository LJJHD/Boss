//
//  JHBoss_ChoiceRestView.h
//  Boss
//
//  Created by jinghankeji on 2017/6/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <MyLayout/MyLayout.h>

@interface JHBoss_ChoiceRestView : UIView
@property (nonatomic, copy) NSString *restImageStr;
@property (nonatomic, copy) NSString *restName;
@property (nonatomic, copy) NSString *selectTime;
@property (nonatomic, copy) NSString *hideLBStr;

@property (nonatomic, strong) UIView *restNameBackView;
@property (nonatomic, strong) UIView *selectTimeBackView;//日期
@property (nonatomic, strong) UIView *hideBackgroundView;
@property (nonatomic, strong) UILabel *restTimeLB;//餐厅后缀时间

@property (nonatomic, copy) void(^choiceRestHandler)();
@property (nonatomic, copy) void(^selectTimeHandler)();
@end
