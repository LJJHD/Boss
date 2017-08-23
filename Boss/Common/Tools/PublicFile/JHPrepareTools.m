//
//  JHPrepareTools.m
//  JinghanLife
//
//  Created by 晶汉mac on 2017/1/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHPrepareTools.h"

@implementation JHPrepareTools
//版本逻辑更新
+(void)updateAppVersionDetermin
{
    
}


//判断第一次启动
+ (void)initFirstLaunchWithKey:(NSString*)key{
    
    [JHPrepareTools updateAppVersionDeterminWithKey:key withVersionKey:key];
    
    NSNumber* everLanuched = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (everLanuched.boolValue)
    {
        NSLog(@"first launch");
    }
    else
    {
        NSLog(@"second launch");
    }
}

//版本覆盖安装逻辑
+(void)updateAppVersionDeterminWithKey:(NSString*)key withVersionKey:(NSString*)versionKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *bundleVersion = DEF_APP_VERSION;
    
    NSString* preVersion = [defaults objectForKey:[NSString stringWithFormat:@"%@_version",versionKey]];
    
    if( preVersion == nil )//原有版本号取不到，两种可能，一.全新安装，二。以上版本号覆盖旧版本
    {
        [defaults setObject:bundleVersion forKey:[NSString stringWithFormat:@"%@_version",versionKey]];//updating preVersion to latest one
        
    }
    else//覆盖老版本安装
    {
        
        [defaults setObject:bundleVersion forKey:[NSString stringWithFormat:@"%@_version",versionKey]];
        
        if ( [bundleVersion compare:preVersion] > 0 )
        {
            //
            NSLog(@"覆盖升级安装");
            
            [defaults removeObjectForKey:key];
            
        }
        else
        {
            
        }
        
    }
    
    [defaults synchronize];
    
}



@end
