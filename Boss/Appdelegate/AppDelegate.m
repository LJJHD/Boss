 //
//  AppDelegate.m
//  JinghanLife
//
//  Created by 晶汉mac on 2016/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "AppDelegate.h"
#import "JHTabBarController.h"
#import "JHBaseNavigationController.h"
#import "JHMapManager.h"
#import "JHReachabilityManager.h"
#import "JHCRM_LoginViewController.h"
#import "JHCRM_FirstLunchViewController.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "JHBoss_NotificationReminderViewController.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import "JHBoss_DataDetailsViewController.h"
#import "JHBoss_MenuOrderDetailViewController.h"
#import "JHBoss_ApproveViewController.h"
#import "JHBoss_AboutUsViewController.h"
#import "JHBoss_HomeViewController.h"
#import <AlipaySDK/AlipaySDK.h>

#import "JHBoss_PayResultCheckout.h"
@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>
@property (nonatomic, strong) NSDictionary *noticeDic;//通知内容
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //配置第三方账号平台
 //   [SocialShareManager setup];
//    //检测网络连接状态
    [JHReachabilityManager setup];
//    //注册百度地图
 //   [JHMapManager setup];
    
    //注册微信支付    wxc41a15524a4e435b
    [WXApi registerApp:@"wx77a67cc72ff2c0ba"];
    
    // 友盟统计
    [self UMsetup];
    
    // 注册推送
    [self setupJPushOptions:launchOptions];
    
    //屏幕适配
    [MyDimeScale setUITemplateSize:CGSizeMake(375, 667)];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
  
        
    //悬浮窗调试
#ifdef DEBUG

    id debugClass = NSClassFromString(@"UIDebuggingInformationOverlay");
    [debugClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
    
#else
    
#endif
    
      [self.window makeKeyAndVisible];
    [self configRootViewController];
    
    
    // 注册推送
    [self setupJPushOptions:launchOptions];
    //清空角标
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    
   
    // 友盟统计获取测试设备信息（集成测试时使用）
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    /*
    */
       
    return YES;
}

- (void)configRootViewController{
    
    
    JHCRM_FirstLunchViewController *firstVc = [[JHCRM_FirstLunchViewController alloc] init];
    
    self.window.rootViewController  = firstVc;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    
    manager.enable = YES;
    
    manager.shouldResignOnTouchOutside = YES;
    
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    
    manager.enableAutoToolbar = NO;
}

-(void)setupJPushOptions:(NSDictionary *)launchOptions{

    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];

    //运行环境
    int isProduction;
    
#ifdef DEBUG
    
    isProduction = 0;
#else
    isProduction = 1;
#endif
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey channel:@"AppStore" apsForProduction:isProduction];
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
//  iOS 10 及以上版本Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    DPLog(@"userInfo1===%@",userInfo);
     UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    /*
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    */
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
         [self didReceiveNotificationHandler:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 及以上版本Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
     DPLog(@"userInfo1===%@",userInfo);
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    /*
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    */
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [self didReceiveNotificationHandler:userInfo];
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

//ios 7 及以上版本
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
// Required, iOS 7 Support
 DPLog(@"userInfo&& 7 ===%@",userInfo);
    [self didReceiveNotificationHandler:userInfo];
  
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}


-(void)didReceiveNotificationHandler:(NSDictionary *)userInfo{
 
    _noticeDic = userInfo;
    //重置jpush 的角标数
    [JPUSHService resetBadge];
    
    NSNumber * badge = userInfo[@"aps"][@"badge"];
    
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:([badge integerValue] - 1)];
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if (state == UIApplicationStateInactive)
    {//应用在后台
        //在此处处理跳转页面
        [self handlePushMessage:userInfo];

    }
    else
    {
        //在此处处理一般推送
        [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteNotifaciotn" object:nil userInfo:userInfo];
    }
}

- (void)handlePushMessage:(NSDictionary*)userInfo
{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"isBackground", nil];
    
    [newDic setObject:self.noticeDic forKey:@"userInfo"];
    
     id objectVc = self.window.rootViewController;
    
    if (objectVc && [objectVc isKindOfClass:[UINavigationController class]])
    {
        
        UINavigationController  *navVC = objectVc;
        
       id vc = navVC.viewControllers.firstObject;
        if (vc && [vc isKindOfClass:[JHTabBarController class]])
        {
            
            JHTabBarController *tabVC = vc;
            
            if ([tabVC.viewControllers.firstObject isKindOfClass:[JHBoss_HomeViewController class]])
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteNotifaciotn" object:nil userInfo:newDic];
            }else{
                [self performSelector:@selector(handlePushMessage:) withObject:self afterDelay:0];
            }
        }else{
            
            [self performSelector:@selector(handlePushMessage:) withObject:self afterDelay:0];
        }
    }else{
        //延迟一秒再走
        [self performSelector:@selector(handlePushMessage:) withObject:self afterDelay:0];
    }

}

- (void)UMsetup
{
    
    UMConfigInstance.appKey = UMAppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick setAppVersion:[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    UMConfigInstance.eSType = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        @weakify(self);
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"appdelegate-result = %@",resultDic);
            [JHBoss_PayResultCheckout checkoutAlipayResult:resultDic[@"resultStatus"] checkResut:^(BOOL isSucc) {
                @strongify(self);
                [self payResultNotificationIsSucc:isSucc];
            }];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            DPLog(@"%@",result);
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        
        return YES;
    }
    
    //微信支付回调
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"app-result = %@",resultDic);
            @weakify(self);
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"appdelegate-result = %@",resultDic);
                [JHBoss_PayResultCheckout checkoutAlipayResult:resultDic[@"resultStatus"] checkResut:^(BOOL isSucc) {
                    @strongify(self);
                    [self payResultNotificationIsSucc:isSucc];
                }];
            }];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
           
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
        return YES;
    }
    //微信支付回调
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

//发送支付结果通知
-(void)payResultNotificationIsSucc:(BOOL)isSucc{

    [[NSNotificationCenter defaultCenter]postNotificationName:alipayChectoutNotifiction object:nil userInfo:@{@"isSucc":@(isSucc)}];
}

// 支持目前所有iOS系统
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    /**
     * 微信支付回调
     */
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
