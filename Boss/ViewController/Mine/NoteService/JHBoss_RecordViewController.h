//
//  JHBoss_RecordViewController.h
//  Boss
//
//  Created by SeaDragon on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//记录通用控制器

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,JHBoss_recordType) {

    JHBoss_recordType_consum,//钱包消费记录
    JHBoss_recordType_recharge,//钱包充值记录
    JHBoss_recordType_noteRecord//短信消费记录
};

NS_ASSUME_NONNULL_BEGIN

@interface JHBoss_RecordViewController : UIViewController

//标题
@property (nonatomic, copy) NSString *recordTittle;
//类型
@property (nonatomic, assign) JHBoss_recordType recordType;
//商户ID
@property (nonatomic, copy) NSString *merchanId;
@end

NS_ASSUME_NONNULL_END
