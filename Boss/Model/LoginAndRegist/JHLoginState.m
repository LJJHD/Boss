//
//  JHLoginState.m
//  SuppliersCRM
//
//  Created by jinghankeji on 2017/4/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHLoginState.h"
#import "UMMobClick/MobClick.h"

@implementation JHLoginState
+ (BOOL)isLogin{
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"JH_LOGIN"];
    return login.intValue;
}

+ (void)setLogined{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"JH_LOGIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setLoginOuted{
    [MobClick profileSignOff];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"JH_LOGIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



+(int)isOpenGesturePassword:(NSString *)account{

//    NSString *keyStr = [account stringByAppendingString:@"gestureStaute"];
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"gestureStaute"];
    
    return login.intValue;
}


+(void)setGesturePassword:(NSString *)account{

//    if (account.length <= 0) {
//        
//        [JHUtility showToastWithMessage:@"请设置存储账号"];
//        return;
//    }
//     NSString *keyStr = [account stringByAppendingString:@"gestureStaute"];
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"gestureStaute"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+(void)closeGesturePassword:(NSString *)account{

//    if (account.length <= 0) {
//        
//        [JHUtility showToastWithMessage:@"请设置存储账号"];
//        return;
//    }
//     NSString *keyStr = [account stringByAppendingString:@"gestureStaute"];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"gestureStaute"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void)cleanGesturePassword:(NSString *)account{

//    NSString *keyStr = [account stringByAppendingString:@"gestureStaute"];
    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"gestureStaute"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void)saveGesturePassword:(NSString *)account passWord:(NSString *)passWord{

//    NSString *keyStr = [account stringByAppendingString:@"gesturePassWord"];
    [[NSUserDefaults standardUserDefaults] setObject:passWord forKey:@"gesturePassWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(NSString *)getGesturePassword:(NSString *)account{

//    NSString *keyStr = [account stringByAppendingString:@"gesturePassWord"];
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"gesturePassWord"];
}



@end
