//
//  JHBoss_OrderExceptionListModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_OrderExceptionListModel : JHBaseModel
@property (nonatomic , copy) NSString              * mcntName;//店名
@property (nonatomic , strong) NSNumber            *  merchantId;
@property (nonatomic , strong) NSNumber            *  exOrderDate;
@property (nonatomic , copy) NSString              * exOrderDesc;//内容
@property (nonatomic , copy) NSString              * exOrderNo;//订单号
@property (nonatomic , strong) NSNumber              * exOrderId;//订单id

@end
