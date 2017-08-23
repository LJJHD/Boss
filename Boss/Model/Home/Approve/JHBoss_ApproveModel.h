//
//  JHBoss_ApproveModel.h
//  Boss
//
//  Created by sftoday on 2017/5/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ApproveType) {
    ApproveTypeLeave = 1, // 请假申请
    ApproveTypeDiscount, // 折扣／免单／挂帐申请
};

@interface JHBoss_ApproveModel : NSObject

@property (nonatomic, strong) NSNumber *approvalState; // 审批状态
@property (nonatomic, assign) ApproveType approvalType; // 审批类别 1 请假申请 2 折扣／免单／挂帐申请
@property (nonatomic, copy) NSString *leaveStart; // 请假开始时间
@property (nonatomic, copy) NSString *leaveEnd; // 请假结束时间
@property (nonatomic, copy) NSString *applyProject; // 申请项目
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *restaurantName; // 所属店铺
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, copy) NSString *submitDate; // 申请时间
@property (nonatomic, strong) NSNumber *staffId;
@property (nonatomic, copy) NSString *staffName; // 员工姓名
@property (nonatomic, copy) NSString *leaveDays; // 请假天数
@property (nonatomic, strong) NSNumber *approvalId; // 审批id
@property (nonatomic, strong) NSNumber *restaurantId; // 餐厅id

@end
