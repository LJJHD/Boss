//
//  JHBoss_PayResultCheckout.h
//  Boss
//
//  Created by jinghankeji on 2017/7/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_PayResultCheckout : JHBaseModel

/**
 校验阿里支付
 
 @param payResult 支付宝返回的签名结果
 @param checkResut 校验结果
 */
+(void)checkoutAlipayResult:(NSString *)payResult checkResut:(void(^)(BOOL))checkResut;

/**
 校验微信支付

 @param payResult 微信订单信息
 @param checkResut 校验结果
 */
+(void)checkoutWXPayResult:(NSDictionary *)payResult checkResut:(void(^)(BOOL))checkResut;
@end
