//
//  JHBoss_PayMethodFooterView.h
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//支付方法底部视图

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChooseMethodType) {

    kChooseMethodType_TOP_UP,   //充值
    kChooseMethodType_Employees //员工
    
};

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickPayFootViewBlock)(NSInteger tag, CGFloat payCount);

@interface JHBoss_PayMethodFooterView : UIView

@property (nonatomic, assign) CGFloat payCount;

@property (nonatomic, assign) NSInteger payID;

@property (nonatomic, assign) ChooseMethodType methodType;

@property (nonatomic, copy) clickPayFootViewBlock footViewBlock;

@end

NS_ASSUME_NONNULL_END
