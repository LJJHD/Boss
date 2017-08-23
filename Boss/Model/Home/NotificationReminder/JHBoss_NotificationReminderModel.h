//
//  JHBoss_NotificationReminderModel.h
//  Boss
//
//  Created by sftoday on 2017/5/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, NotificationReminderType) {
    NotificationReminderTypeRestReceivedNegative = 1,//商户差评
    NotificationReminderTypeWiterReceivedNegative,//服务员差评
    NotificationReminderTypeOrderAbnormal,//订单异常
    NotificationReminderTypeNoNote,//短信余额不足
};


@interface JHBoss_NotificationReminderModel : NSObject

@property (nonatomic, strong) NSNumber *time; // 通知时间
@property (nonatomic, copy) NSString *title; // 通知title
@property (nonatomic, copy) NSString *staffName; // 员工名
@property (nonatomic, copy) NSString *memberId; // 会员id
@property (nonatomic, copy) NSString *keyWord; // 订阅的关键字
@property (nonatomic, copy) NSString *orderNumber; // 订单号
@property (nonatomic, copy) NSString *reportType; // 报表推送类型 日报／月报
@property (nonatomic, assign) NotificationReminderType type; // 通知类型
@property (nonatomic, copy) NSString *restaurantName; // 餐厅名
@property (nonatomic, strong) NSNumber *Id; // 通知id
@property (nonatomic, strong) NSNumber *level; // 左边颜色条纹等级
@property (nonatomic, strong) NSNumber *dishesId; // 菜品id
@property (nonatomic, strong) NSNumber *staffId; // 员工id
@property (nonatomic, strong) NSNumber *dataId; // 数据id
@property (nonatomic, strong) NSNumber *restaurantId; // 餐厅id
@property (nonatomic, copy) NSString *dataTitle; // 数据名
@property (nonatomic, copy) NSString *memberName; // 会员名
@property (nonatomic, copy) NSString *reason; // 原因
@property (nonatomic, copy) NSString *dishesName; // 菜品名
@property (nonatomic, copy) NSString *phoneNumber; // 电话
@property (nonatomic, strong) NSNumber *readStatus; // 消息是否已读  0 未读  1已读

@end
