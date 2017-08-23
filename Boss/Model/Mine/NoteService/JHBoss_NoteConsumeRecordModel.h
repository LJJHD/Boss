//
//  JHBoss_NoteConsumeRecordModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface MerchantMessageList :NSObject
@property (nonatomic , copy) NSString              * messageTypeName;//短信类型名
@property (nonatomic , strong) NSNumber            *  consumeAmount;//消费金额
@property (nonatomic , strong) NSNumber            *  ID;
@property (nonatomic , strong) NSNumber            *  messageType;
@property (nonatomic , strong) NSNumber            *  pageEndTime;
@property (nonatomic , strong) NSNumber            * consumeMessageAmount;//消费短信条数
@property (nonatomic , copy) NSString              * merchantId;//餐厅id
@property (nonatomic , copy) NSString              * merchantName;//餐厅名字

@end

@interface JHBoss_NoteConsumeRecordModel : JHBaseModel
@property (nonatomic , strong) NSNumber             * consumeTotalAmountOneMonth;
@property (nonatomic , strong) NSArray<MerchantMessageList *>              * merchantMessageList;
@property (nonatomic , copy) NSString              * queryDate;//时间
@end
