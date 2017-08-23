//
//  JHBoss_PayMessageView.h
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//短信购买视图

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHBoss_PayMessageItem;

typedef void(^PayMessageBlcok)(JHBoss_PayMessageItem *item);

@interface JHBoss_PayMessageView : UIView

@property (nonatomic, strong) JHBoss_PayMessageItem *payItem;

@property (nonatomic, copy) PayMessageBlcok messageBlock;

@end

NS_ASSUME_NONNULL_END
