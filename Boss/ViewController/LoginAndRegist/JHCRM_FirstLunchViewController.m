
//
//  JH_FitstLunchViewController.m
//  JinghanLife
//
//  Created by 晶汉mac on 2017/2/24.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHCRM_FirstLunchViewController.h"
#import "JHCRM_LoginViewController.h"
#import "JHBaseNavigationController.h"
#import "JHTabBarController.h"
#import "JH_GuideViewController.h"
#import "JHUserInfoData.h"
#import "JHLoginState.h"
#import "JHBoss_GestureLoginViewController.h"
@interface JHCRM_FirstLunchViewController ()

@end

@implementation JHCRM_FirstLunchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self setRootVC];
}
- (void)setRootVC{
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    window.rootViewController = nil;
    
    UIViewController *rootVc = nil;
    
    if ([JHLoginState isLogin])//判断登录
    {
        
         JHUserInfoData *userInfoData = [JHUserInfoData new];
        NSString *accountStr = [userInfoData account];
        int gestureStaute = [JHLoginState isOpenGesturePassword:accountStr];
        
        if ( gestureStaute == 2 ) {
            
             rootVc = [[JHBoss_GestureLoginViewController alloc]init];
            
        }else if(gestureStaute == 1) {
            
            rootVc = [[JHTabBarController alloc]init];
            
        }else {
            
            rootVc = [[JHBoss_GestureLoginViewController alloc]init];
            
        }

    }else
    {
        rootVc = [[JHCRM_LoginViewController alloc] init];
    }
    
    JHBaseNavigationController *nav= [[JHBaseNavigationController alloc]initWithRootViewController:rootVc];
    nav.navigationBarHidden = YES;
    window.rootViewController  = nav;
    

    [JHPrepareTools initFirstLaunchWithKey:@"firstLaunch"];//判断第一次登录
    
    if (DEF_JHISFIRSTLAUNCH)//加载引导页，写在设置rootvc之后
    {
        
        if (DEF_DEVICE_Iphone4)
        {
            [JH_GuideViewController showWithImageNameArray:@[@"guidepage_1_640*960",@"guidepage_2_640*960",@"guidepage_3_640*960"]];

        }else
        {//5 6 6p 都用6的尺寸，三个屏幕的宽高比大约等于0.56，基本相等
            [JH_GuideViewController showWithImageNameArray:@[@"guidepage_1_750*1334",@"guidepage_2_750*1334",@"guidepage_3_750*1334"]];

        }
    }else{
        
        
    }

}




@end
