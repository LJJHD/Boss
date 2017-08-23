//
//  JHBoss_PushSettingModel.h
//  Boss
//
//  Created by sftoday on 2017/5/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JHBoss_PushTargetsSettingModel;
@class JHBoss_PushReportSettingModel;

@interface JHBoss_PushSettingModel : NSObject

@property (nonatomic, copy) NSString *pushTime; // 推送时间
@property (nonatomic, assign) BOOL state; // 是否接收报表
@property (nonatomic, copy) NSArray<JHBoss_PushTargetsSettingModel *> *pushTargets;
@property (nonatomic, copy) NSArray<JHBoss_PushReportSettingModel *> *subscribeReports;

@end


@interface JHBoss_PushTargetsSettingModel : NSObject

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, assign) BOOL state;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;

@end


@interface JHBoss_PushReportSettingModel : NSObject

@property (nonatomic, copy) NSString *reportName;
@property (nonatomic, assign) BOOL state;
@property (nonatomic, strong) NSNumber *reportId;

@end
