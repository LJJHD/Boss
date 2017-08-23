//
//  JHBoss_StaffOrDishsRangkingView.h
//  Boss
//
//  Created by jinghankeji on 2017/7/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHBoss_StaffOrDishsRangkingView : UIView
@property (nonatomic, copy) NSString *restImageStr;
@property (nonatomic, copy) NSString *restName;
@property (nonatomic, copy) NSString *selectTime;
@property (nonatomic, copy) NSString *hideLBStr;
@property (nonatomic, copy) NSString *rangkingLbStr;

@property (nonatomic, strong) UIView *restNameBackView;
@property (nonatomic, strong) UIView *selectTimeBackView;//日期
@property (nonatomic, strong) UIView *rangkingBackgroundView;//排序

@property (nonatomic, strong) UILabel *restTimeLB;//餐厅后缀时间

@property (nonatomic, copy) void(^choiceRestHandler)();//选择餐厅
@property (nonatomic, copy) void(^selectTimeHandler)();//选择时间
@property (nonatomic, copy) void(^rangkingHandler)();//员工排序和菜品排序使用
@end
