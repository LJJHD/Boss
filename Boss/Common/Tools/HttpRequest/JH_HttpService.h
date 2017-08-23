//
//  JH_HttpService.h
//  JinghanLife
//
//  Created by 晶汉mac on 2017/2/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JH_HttpService : NSObject
/**普通请求url**/
@property (nonatomic,strong) NSString *baseServerUrl;
/**聊天url**/
@property (nonatomic,strong) NSString *baseIMServerUrl;
/**登录忘记密码请求url**/
@property (nonatomic,strong) NSString *baseLoginServerUrl;
/**图片上传url**/
@property (nonatomic,strong) NSString *baseUploadPictureServerUrl;
/**请求广告url**/
@property (nonatomic,strong) NSString *baseAdServerUrl;
/**打赏金额列表url**/
@property (nonatomic,strong) NSString *baseRewardMoneyServerUrl;
/**微信统一下单url**/
@property (nonatomic,strong) NSString *basePayOrderServerUrl;
/**阿里统一下单url**/
@property (nonatomic,strong) NSString *baseAlipayOrderServerUrl;
/**钱包充值和购买短信url**/
@property (nonatomic,strong) NSString *baseWalletOrBuyNoteServerUrl;
+ (JH_HttpService*)shareInstance;
@end
