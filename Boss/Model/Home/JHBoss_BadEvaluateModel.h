//
//  JHBoss_BadEvaluateModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_BadEvaluateModel : JHBaseModel
@property (nonatomic , copy) NSString              * dishName;//菜名
@property (nonatomic , assign) NSInteger              type;//类型 1店铺差评   2服务员差评
@property (nonatomic , copy) NSString              * commenter;//会员名
@property (nonatomic , copy) NSString              * desc;//评价内容
@property (nonatomic , copy) NSString              * mcntName;//店铺名
@property (nonatomic , strong) NSNumber            *  merchantId;

@property (nonatomic , copy) NSString              * waiter;//服务员名
@property (nonatomic , strong) NSNumber            * date;//时间
@property (nonatomic , copy) NSString            * orderNo;//订单号

@end
