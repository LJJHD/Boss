//
//  JHBoss_OrderListModel.h
//  Boss
//
//  Created by jinghankeji on 2017/5/15.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface CommentList :JHBaseModel
@property (nonatomic , copy) NSString              * content;//评价内容
@property (nonatomic , copy) NSString              * time;//评价时间
@property (nonatomic , strong) NSNumber            *  ID;
@property (nonatomic , copy) NSString              * commenter;//评论者
@property (nonatomic , strong) NSNumber            *  commenterId;//评论ID
@property (nonatomic , strong) NSNumber            *  starType;//星
@property (nonatomic , strong) NSNumber            *  type;//1商户评价  2服务员评价
@property (nonatomic , copy)   NSString            *   photo;//头像

@end

@interface dishesList : JHBaseModel
@property (nonatomic , copy) NSString              * name;//菜品名
@property (nonatomic , assign) NSInteger              ID;//菜品id
@property (nonatomic , assign) NSInteger              count;//已点菜数量
@property (nonatomic , assign) NSInteger              price;//菜价
@end


@interface WaiterList :JHBaseModel
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * picture;

@end


@interface JHBoss_OrderListModel : JHBaseModel
@property (nonatomic , assign) NSInteger              ID;//订单id
@property (nonatomic , assign) NSInteger              state;//1 待支付  2 账单支付中  3支付成功  4支付失败
@property (nonatomic , copy) NSString              * openTime;
@property (nonatomic , strong) NSArray<dishesList *>              * dishesList;//点的菜
@property (nonatomic , copy) NSString              * cashier;
@property (nonatomic , copy) NSArray<WaiterList *> * waiterList;//服务员列表
@property (nonatomic , copy) NSArray<CommentList *> * commentList;//评价列表
@property (nonatomic , copy) NSString              * consumedMoney;//消费金额
@property (nonatomic , copy) NSString              * memberLevel;
@property (nonatomic , copy) NSString              * payTime;
@property (nonatomic , assign) NSInteger              peopleNum;
@property (nonatomic , copy) NSString              * memberId;
@property (nonatomic , copy) NSString              * tableNumber;
@property (nonatomic , copy) NSString              * number;//订单号
@property (nonatomic , strong) NSNumber            * realPay;//实际支付金额
@property (nonatomic , strong) NSNumber            * decrease;//减免金额
@property (nonatomic , strong) NSNumber            * discount;//折扣
@property (nonatomic , copy) NSString              * restName;//餐厅名

@end
