//
//  JHBoss_PayMethodHelper.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PayMethodHelper.h"

#import "JHBoss_PayMehtodItem.h"
#import <WXApi.h>
@implementation JHBoss_PayMethodHelper

- (NSMutableArray *)fetchPayMethodDataSourcesWithoutZFB:(BOOL)zfb {
    
    JHBoss_PayMehtodItem *cachatPayItem = CreatePayMethodItem(@"微信支付",
                                                              @"推荐安装微信5.0及以上版本",
                                                              @"icon_me_wallet_recharge_wechat",
                                                              @"icon_me_wallet_default",
                                                              @"1.1.5.1_icon_done",
                                                              YES);
    
    JHBoss_PayMehtodItem *payItem       = CreatePayMethodItem(@"支付宝支付",
                                                              @"推荐有支付宝账户用户使用",
                                                              @"icon_me_wallet_recharge_alipay",
                                                              @"icon_me_wallet_default",
                                                              @"1.1.5.1_icon_done",
                                                              NO);
    
    JHBoss_PayMehtodItem *alipayItemSelected       = CreatePayMethodItem(@"支付宝支付",
                                                              @"推荐有支付宝账户用户使用",
                                                              @"icon_me_wallet_recharge_alipay",
                                                              @"icon_me_wallet_default",
                                                              @"1.1.5.1_icon_done",
                                                              YES);
    
    JHBoss_PayMehtodItem *cachatPayItemTwo = CreatePayMethodItem(@"微信支付",
                                                                 @"推荐安装微信5.0及以上版本",
                                                                 @"icon_me_wallet_recharge_wechat",
                                                                 @"icon_me_wallet_default",
                                                                 @"1.1.5.1_icon_done",
                                                                 YES);
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:0];
    
    if (zfb) {
        [tmpArr addObjectsFromArray:@[cachatPayItemTwo]];
    } else if ( [JHBoss_UserWarpper shareInstance].isInstallWX) {
        [tmpArr addObjectsFromArray:@[cachatPayItem,payItem]];
    }else{
         [tmpArr addObjectsFromArray:@[alipayItemSelected]];
    }
    
    return tmpArr;
}

@end
