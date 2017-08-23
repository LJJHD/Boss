//
//  JHBoss_VersionUpdate.m
//  Boss
//
//  Created by jinghankeji on 2017/8/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_VersionUpdate.h"

@implementation JHBoss_VersionUpdate
+(void)checkAppStoreVersion:(BOOL)isNeedReportNoNewVersion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        
        NSString *newVersion;
        NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/cn/lookup?id=1245583445"];//1112420290
        
        //通过url获取数据
        NSString *jsonResponseString =   [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"通过appStore获取的数据是：%@",jsonResponseString);
        if (!jsonResponseString) {
            return ;
        }
        //解析json数据为数据字典
        NSDictionary *loginAuthenticationResponse = [self dictionaryFromJsonFormatOriginalData:jsonResponseString];
        
        //版本更新信息
        NSString* releaseNote = nil;
        //从数据字典中检出版本号数据
        NSArray *configData = [loginAuthenticationResponse valueForKey:@"results"];
        for(id config in configData)
        {
            newVersion = [config valueForKey:@"version"];
            
            releaseNote = DEF_OBJECT_TO_STIRNG(config[@"releaseNotes"]);
        }
        
        NSLog(@"通过appStore获取的版本号是：%@",newVersion);
        
        //获取本地软件的版本号
        NSString *localVersion = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        //        NSString *msg = [NSString stringWithFormat:@"你当前的版本是V%@，发现新版本V%@，是否下载新版本？",localVersion, newVersion];
        
        //对比发现的新版本和本地的版本
        if ( [newVersion compare:localVersion] == NSOrderedDescending )
        {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                               
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                }];
                
                UIAlertAction *sure = [UIAlertAction actionWithTitle:@"前往更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    //前往AppStore更新
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E6%99%B6%E8%8B%B1%E8%81%94%E7%9B%9F/id1245583445?mt=8"]];
                }];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本!" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:cancel];
                [alert addAction:sure];
                
                UIViewController *vc;
                UIWindow *window = [[UIApplication sharedApplication].delegate window];
                
                vc = window.rootViewController;
                [vc presentViewController:alert animated:YES completion:nil];
                
            });
            
            
        }
        
    });
}


//将json 格式的原始数据转解析成数据字典
+(NSMutableDictionary *)dictionaryFromJsonFormatOriginalData:(NSString *)str
{
    //    SBJsonParser *sbJsonParser = [[SBJsonParser alloc]init];
    //    NSError *error = nil;
    
    //添加autorelease 解决 内存泄漏问题
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *tempDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return tempDictionary;
    
}@end
