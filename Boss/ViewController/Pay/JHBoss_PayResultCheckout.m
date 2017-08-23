//
//  JHBoss_PayResultCheckout.m
//  Boss
//
//  Created by jinghankeji on 2017/7/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//
 
#import "JHBoss_PayResultCheckout.h"

@implementation JHBoss_PayResultCheckout
//校验阿里支付
+(void)checkoutAlipayResult:(NSString *)payResult checkResut:(void(^)(BOOL))checkResut{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:payResult             forKey:@"resultJson"];//充值类型
    [JHHttpRequest postRequestWithParams:param
                                    path:JH_AlipayResultCheckout
                           isShowLoading:NO isNeedCache:NO
                                 success:^(id object) {
                                     
                                     NSDictionary *dic = object;
                                     
                                     if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
                                         
                                         checkResut(YES);
                                         
                                     }else{
                                         
                                         checkResut(NO);
                                     }
                                    
                                     
                                 } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
                                     checkResut(NO);
                                 }];
    
}

+(void)checkoutWXPayResult:(NSDictionary *)payResult checkResut:(void (^)(BOOL))checkResut{

    [JHHttpRequest postRequestWithParams:payResult
                                    path:JH_WXPayResultQueryURL
                           isShowLoading:NO isNeedCache:NO
                                 success:^(id object) {
                                     
                                     NSDictionary *dic = object;
                                     
                                     if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
                                         
                                         checkResut(YES);
                                         
                                     }else{
                                         
                                         checkResut(NO);
                                     }
                                     
                                     
                                 } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
                                     checkResut(NO);
                                 }];

}

@end
