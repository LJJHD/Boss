//
//  JHLoginState.h
//  SuppliersCRM
//
//  Created by jinghankeji on 2017/4/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHLoginState : JHBaseModel
// YES 用户已经登录了
// NO  用户没有登录
+ (BOOL)isLogin;

// 设置用户为登录状态
+ (void)setLogined;
// 设置用户为未登录状态
+ (void)setLoginOuted;


+ (int)isOpenGesturePassword:(NSString *)account;//是否打开手势密码 1 关闭  2 打开 3(输入密码4次错误) 不是这两个数字为未设置手势密码
+ (void)setGesturePassword:(NSString *)account;//设置手势密码状态
+ (void)closeGesturePassword:(NSString *)account;//关闭手势密码状态
+ (void)cleanGesturePassword:(NSString *)account;//把某个账号的手势密码清空，设置为没有设置手势密码的状态
+ (void)saveGesturePassword:(NSString *)account passWord:(NSString *)passWord;//保存手势密码
+ (NSString *)getGesturePassword:(NSString *)account;//获取手势密码
@end
