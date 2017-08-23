//
//  JH_HttpService.m
//  JinghanLife
//
//  Created by 晶汉mac on 2017/2/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JH_HttpService.h"

@implementation JH_HttpService

+ (JH_HttpService*)shareInstance
{
    static JH_HttpService *__service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __service = [[JH_HttpService alloc] init];
    });
    return __service;
}

//基本请求
+(NSString*)initBaseServer
{
    NSString *string = @"";
    switch (jH_Service_Environment) {
        case JH_Service_Environment_Online://线上环境
            string = @"http://boss.jinghanit.com:8083";
            break;
        case JH_Service_Environment_Https:
            string = @"https://192.168.2.200:8440";
            break;
        case JH_Service_Environment_ABTest:
            string = @"http://192.168.2.9:9090";
            break;
        case JH_Service_Environment_Test://测试环境
            string = @"http://192.168.2.11:9090";
            break;
        case JH_Service_Environment_Dev:
            //
            string = @"http://192.168.2.6:9090";
        default:
            break;
    }
        return string;
}
//登录相关
+(NSString *)initBaseUserServer{
    NSString *string = @"";
    switch (jH_Service_Environment) {
        case JH_Service_Environment_Online://线上环境
            string = @"https://account.jinghanit.com";
            break;
        case JH_Service_Environment_Https:
            string = @"";
            break;
        case JH_Service_Environment_ABTest:
            string = @"http://192.168.2.9:9081";
            break;
        case JH_Service_Environment_Test:
           
            string = @"http://192.168.2.11:9081";
            break;
        case JH_Service_Environment_Dev:
          
            string = @"http://192.168.2.6:9082";
        default:
            break;
    }
    return string;
}
//上传图片
+(NSString *)initUploadPictureServer{
    NSString *string = @"";
    switch (jH_Service_Environment) {
        case JH_Service_Environment_Online://线上环境
            string = @"https://file.jinghanit.com";
            break;
        case JH_Service_Environment_Https:
            string = @"";
            break;
        case JH_Service_Environment_ABTest:
            string = @"http://192.168.2.9:9080";
            break;
        case JH_Service_Environment_Test://测试环境
            string = @"http://192.168.2.9:9080";
            break;
        case JH_Service_Environment_Dev:
            string = @"http://192.168.2.9:9080";
            break;
        default:
            break;
    }

    return string;
}
//请求广告
+(NSString *)initAdServer{
    NSString *string = @"";
    switch (jH_Service_Environment) {
        case JH_Service_Environment_Online://线上环境
            string = @"http://bs.jinghanit.com:8081";
            break;
        case JH_Service_Environment_Https:
            string = @"";
            break;
        case JH_Service_Environment_ABTest:
            string = @"http://bs.jinghanit.com:8081";
            break;
        case JH_Service_Environment_Test://测试环境
            string = @"http://192.168.2.10:9091";
            break;
        case JH_Service_Environment_Dev:
            string = @"http://192.168.2.148:8088";
            break;
        default:
            break;
    }
    
    return string;
}

//请求打赏金额列表
+(NSString *)initRewardMoneyListServer{
    NSString *string = @"";
    switch (jH_Service_Environment) {
        case JH_Service_Environment_Online://线上环境
            string = @"https://reward.jinghanit.com";
            break;
        case JH_Service_Environment_Https:
            string = @"https://reward.jinghanit.com";
            break;
        case JH_Service_Environment_ABTest:
            string = @"http://192.168.2.9:9093";
            break;
        case JH_Service_Environment_Test://测试环境
            //9
            string = @"http://192.168.2.11:9093";
            break;
        case JH_Service_Environment_Dev:
            string = @"http://192.168.2.6:9093";
            break;
        default:
            break;
    }
    
    return string;
}

//微信预支付接口
+(NSString *)initPayOrderListServer{
    NSString *string = @"";
    switch (jH_Service_Environment) {
        case JH_Service_Environment_Online://线上环境
            string = @"https://pay.jinghanit.com";
            break;
        case JH_Service_Environment_Https:
            string = @"";
            break;
        case JH_Service_Environment_ABTest:
            string = @"http://192.168.2.9:9089";
            break;
        case JH_Service_Environment_Test://测试环境
            string = @"http://192.168.2.11:9089";
            break;
        case JH_Service_Environment_Dev:
            string = @"http://192.168.2.6:9089";
            break;
        default:
            break;
    }
    
    return string;
}

//阿里统一支付接口
+(NSString *)initAlipayServer{
    NSString *string = @"";
    switch (jH_Service_Environment) {
        case JH_Service_Environment_Online://线上环境
            string = @"https://pay.jinghanit.com";
            break;
        case JH_Service_Environment_Https:
            string = @"";
            break;
        case JH_Service_Environment_ABTest:
            string = @"http://192.168.2.9:9089";
            break;
        case JH_Service_Environment_Test://测试环境
            string = @"http://192.168.2.11:9089";
            break;
        case JH_Service_Environment_Dev:
            //6  9089   203:80
            string = @"http://192.168.2.6:9089";
            break;
        default:
            break;
    }
    
    return string;
}

//钱包充值和购买短信订单号接口
+(NSString *)initWalletOrBuyNoteServer{
    NSString *string = @"";
    switch (jH_Service_Environment) {
        case JH_Service_Environment_Online://线上环境
            string = @"https://merchant.jinghanit.com";
            break;
        case JH_Service_Environment_Https:
            string = @"";
            break;
        case JH_Service_Environment_ABTest:
            string = @"http://192.168.2.9:9084";
            break;
        case JH_Service_Environment_Test://测试环境
            string = @"http://192.168.2.11:9084";
            break;
        case JH_Service_Environment_Dev:
            string = @"http://192.168.2.6:9084";
            break;
        default:
            break;
    }
    
    return string;
}



//IM
+(NSString*)initJHIMBaseServer
{
    NSString *string = @"";
    switch (jH_Service_Environment) {
        case JH_Service_Environment_Online://线上环境
            string = @"http://192.168.2.19:8440";
            break;
        case JH_Service_Environment_Https:
            string = @"https://192.168.2.200:8440";
            break;
        case JH_Service_Environment_Test://测试环境
            string = @"http://192.168.2.200:8443";
            break;
        case JH_Service_Environment_Dev:
            string = @"http://192.168.2.114:8042";
            break;
        default:
            break;
    }
    return string;
}

- (NSString*)baseIMServerUrl
{
    return nil;
}

- (NSString*)baseServerUrl
{
    NSString *string = [NSString stringWithFormat:@"%@",[JH_HttpService initBaseServer]];
    return string;
}

-(NSString *)baseLoginServerUrl
{
    NSString *string = [NSString stringWithFormat:@"%@",[JH_HttpService initBaseUserServer]];
    return string;
}

-(NSString *)baseUploadPictureServerUrl
{
    NSString *string = [NSString stringWithFormat:@"%@",[JH_HttpService initUploadPictureServer]];
    return string;
}

-(NSString *)baseAdServerUrl{

    NSString *string = [NSString stringWithFormat:@"%@",[JH_HttpService initAdServer]];
    return string;
}

-(NSString *)baseRewardMoneyServerUrl{

    NSString *string = [NSString stringWithFormat:@"%@",[JH_HttpService initRewardMoneyListServer]];
    return string;
}

-(NSString *)basePayOrderServerUrl{

    NSString *string = [NSString stringWithFormat:@"%@",[JH_HttpService initPayOrderListServer]];
    return string;
}

-(NSString *)baseAlipayOrderServerUrl{

    NSString *string = [NSString stringWithFormat:@"%@",[JH_HttpService initAlipayServer]];
    return string;
}


-(NSString *)baseWalletOrBuyNoteServerUrl{

    NSString *string = [NSString stringWithFormat:@"%@",[JH_HttpService initWalletOrBuyNoteServer]];
    return string;
}

+ (NSString *)servicePrefix
{
    NSString *string = @"/jinghan-vendor/vendor";
    return string;
}

+ (NSString *)serviceVersion
{
    return @"/v1";
}
@end
