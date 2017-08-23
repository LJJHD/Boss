//
//  JHBoss_recordTableViewCell.h
//  Boss
//
//  Created by SeaDragon on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//记录cell

#import <UIKit/UIKit.h>
#import "JHBoss_RecordModel.h"
#import "JHBoss_NoteConsumeRecordModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBoss_recordTableViewCell : UITableViewCell

@property (nullable, nonatomic, strong) Records *recordModel;
@property (nonatomic, strong) MerchantMessageList *noteConRecordModel;
@property (nonatomic, copy) NSString *warningStr;//没有消费或充值记录的时候显示
@end

NS_ASSUME_NONNULL_END
