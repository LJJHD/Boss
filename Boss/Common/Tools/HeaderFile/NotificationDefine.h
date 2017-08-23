//
//  NotificationDefine.h
//  JinghanLife
//
//  Created by 晶汉mac on 2016/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#ifndef NotificationDefine_h
#define NotificationDefine_h









//**********************第三方*************************

/**
 *  Share Key
 */
#define APPKEY_SHARE @"1a7189362ea70"

/**
 *  新浪微博 Key
 */
#define APPKEY_SHARE_SINA @"3211375198"
#define APPSECRET_SHARE_SINA @"4afe07e245a62bfcabccf8d42b105c07"
#define REDIRECTURL_SHARE_SINA @"http://sns.whalecloud.com/sina2/callback"

/**
 *  QQ    Key  1104947680
 *  Z1p84mwfeCDp6jrg
 */
#define APPKEY_SHARE_QQ @"1193111521"
#define APPSECRET_SHARE_QQ @"W2b3Os0uTbbkIWUK"

/**
 *  微信   Key  wxf2610a69bd039fd9
 *  d4624c36b6795d1d99dcf0547af5443d
 */
#define APPKEY_SHARE_WX  @"wxf2610a69bd039fd9"
#define APPSECRET_SHARE_WX @"d4624c36b6795d1d99dcf0547af5443d"


/**
 *  百度地图key
 */
#define APPKEY_BAIDUMAP @"KffW4x7fR93KeewQDmjfPfr8"

/**
 *   融云Key
 */
#define APPKEY_RONGYUN @"e0x9wycfe02kq"
#define APPSCRET_RONGYUN @"Yy8vK8PG0Q"

/**
 *   alipay scheme
 */
#define  alipay_scheme @"待填写"


/**
 *   JPush
 */
#define JPushKey @"9924bdb81b5f25dce04c4b7a"

/**
 发送图片通知
 **/
#define UploadOneImageSuccessNotification @"UploadOneImageSuccessNotification"//发送一张图片成功
#define ChoseOneImageNotification @"ChoseOneImageNotification"//选择一张图片回调
/**
 选择位置的通知
 **/
#define ImChoseLocationNotification @"ImChoseLocationNotification"//选择位置通知

/**
 请求餐厅列表通知
 **/
#define loadRestListNotifiction @"loadRestListNotifiction"

/**
 alipay 支付校验通知
 **/
#define alipayChectoutNotifiction @"alipayChectoutNotifiction"
/**
 wxpay 支付校验通知
 **/
#define WXPayChectoutNotifiction @"WXPayChectoutNotifiction"


/**
 筛选栏 的高度和 间距

 @return 
 */
#define kALPHA_SPACE  35
#define kDEF_HEIGHT   127

/**
 员工排序和菜品排序员工筛选栏的高度

 @return 
 */
#define staffRangkingHeight 175

#endif /* NotificationDefine_h */
