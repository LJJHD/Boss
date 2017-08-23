//
//  JHBoss_WalletBalanceModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_WalletBalanceModel : JHBaseModel
@property (nonatomic , strong) NSNumber             * delFlag;
@property (nonatomic , strong) NSNumber             * accountStatus;
@property (nonatomic , strong) NSNumber             * ID;
@property (nonatomic , strong) NSNumber             * merchantId;
@property (nonatomic , strong) NSNumber             * remainderAmount;//短信余额
@property (nonatomic , strong) NSNumber             * sendedAmount;//已发送短信条数
@property (nonatomic , strong) NSNumber             * balance;//钱包余额
@end
