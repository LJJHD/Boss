//
//  Constant.h
//  JinghanLife
//
//  Created by 晶汉mac on 2016/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#ifndef Constant_h
#define Constant_h
#import "AFNetworking.h"

//判断是否是第一次启动
#define DEF_JHISFIRSTLAUNCH   [[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]


/**
 * 屏幕宽高
 */
#define DEF_HEIGHT                      [UIScreen mainScreen].bounds.size.height
#define DEF_WIDTH                       [UIScreen mainScreen].bounds.size.width
#define DEF_NAVIGATIONBAR_HEIGHT        64
#define DEF_TABBAR_HEIGHT               49
//去除导航栏后的高度
#define DEF_CONTENT_INTABBAR_HEIGHT     ([UIScreen mainScreen].bounds.size.height - 64)

/**
 * 适配  根据不同设备等比计算宽/高
 */
#define DEF_RESIZE_UI(float)                   ((float)/375.0f*DEF_WIDTH)
#define DEF_RESIZE_UI_Landscape(float)         ((float)/375.0f*DEF_HEIGHT)
#define DEF_RESIZE_FRAME(frame)                CGRectMake(DEF_RESIZE_UI (frame.origin.x), DEF_RESIZE_UI (frame.origin.y), DEF_RESIZE_UI (frame.size.width), DEF_RESIZE_UI (frame.size.height))
#define JHTabBarButtonImageRatio 0.7


/**
 * 根据RGB获取color
 */

//RGB
#define DEF_COLOR_RGB(r,g,b)                        colorWithRGBValue(r, g, b)

//RGB  A
#define DEF_COLOR_RGB_A(r,g,b,a)                    colorWithRGBValue_alpha(r, g, b, a)

//16进制
#define DEF_COLORFROMRGB(rgbValue)                  colorWithRGBValue_Hex_alpha(rgbValue, 1)

//16进制  A
#define DEF_COLORFROMRGB_A(rgbValue,alphaValue)     colorWithRGBValue_Hex_alpha(rgbValue, alphaValue)

/**
 * 获取iphone
 */
#define DEF_DEVICE_Iphone6p              (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)
#define DEF_DEVICE_Iphone6               (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)
#define DEF_DEVICE_Iphone5               (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define DEF_DEVICE_Iphone4               (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)


//DEBUG调试
#ifdef DEBUG
#define DPLog(format, ...) printf("类名: <%p %s:(%d) > 方法名: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else
#define DPLog(...) {}
#endif



/**
 * 字符串去左右空格
 */
#define DEF_DROP_WHITESPACE(x) [x stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]


/**
 *创建controller
 */
#define DEF_VIEW_CONTROLLER_INIT(controllerName) [[NSClassFromString(controllerName) alloc] init]


/**
 * 字体 适配
 */
#define SizeScale           (DEF_DEVICE_Iphone6p ? 1.5 : 1)
#define DEF_SET_FONT(x)     [UIFont systemFontOfSize:x]
#define DEF_SET_BOLDFONT(x) [UIFont boldSystemFontOfSize:x]


/**
 * 设置图片
 */
#define DEF_IMAGENAME(name)         [UIImage imageNamed:name]
#define DEF_BUNDLE_IMAGE(name,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:type]]


/**
 * 获取AppDelegate
 */
#define DEF_APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define DEF_Window    (UIApplication.sharedApplication.keyWindow)

/**
 * NSUserDefault
 */
#define DEF_USERDEFAULT [NSUserDefaults standardUserDefaults]


/**
 * 所有类型转化成String(防止出现nill值显示在UI)
 */
#define DEF_OBJECT_TO_STIRNG(object) ((object && object != (id)[NSNull null])?([object isKindOfClass:[NSString class]]?object:[NSString stringWithFormat:@"%@",object]):@"")


/**
 * app应用商店url
 */
#define CM_APP_ID @"1057512037"
#define CM_GRADE_URL DEF_IOS7?[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",CM_APP_ID]:[NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",CM_APP_ID]

/**
 * 搜索 历史记录 identify
 */
#define commodityManagerIdentify @"orderSearchIdentify"
/**
 * 当前店铺存储标识
 */
#define currentShopIdentify @"currentShopIdentify"


/**
 * 餐厅搜索
 */

#define restaurantIdentify @"restaurantIdentify"


/**
 友盟AppKey
 */
#define UMAppKey @"59365037717c197a7b00141b"


/**
 * 获取版本号
 */
#define DEF_APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define  DEF_StoredAppVersion  @"JHStoredAppVersion"

#define paramUserID @"userID"
#define paramRoomID @"roomID"
#define paramName @"name"
#define paramId @"id"
#define paramAvatarURL @"avatarURL"
#define sparamType @"type"
#define paramLocalID @"localID"
#define paramMessage @"message"
#define paramMessageID @"messageID"
#define paramMessageIDs @"messageIDs"
#define paramTOKEN @"TOKEN"
#define paramCreated @"created"
#define paramFile @"file"
#define paramThumb @"thumb"
#define paramSize @"size"
#define paramMimeType @"mimeType"
#define paramResponseObject @"responseObject"
#define paramLocation @"location"
#define paramLat @"lat"
#define paramLng @"lng"
#define paramAddress @"address"

//mime Types
#define kAppImageJPG @"image/jpeg"
#define kAppImagePNG @"image/png"
#define kAppImageGIF @"image/gif"
#define kAppVideoMP4 @"video/mp4"
#define kAppAudioWAV @"audio/wav"
#define kAppAudioMP3 @"audio/mp3"

static inline BOOL AppIsOnline(){
    return !JHISOFFLINE;
}

#define kJH_ChatAudioDirectoryName @"JH_ChatAudio"

#define PwdErrorMaxCount 5

static NSInteger pwdErrorCount = PwdErrorMaxCount;

#endif /* Constant_h */
