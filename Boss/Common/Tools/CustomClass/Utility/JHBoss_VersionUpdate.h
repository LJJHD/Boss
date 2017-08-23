//
//  JHBoss_VersionUpdate.h
//  Boss
//
//  Created by jinghankeji on 2017/8/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHBoss_VersionUpdate : NSObject<UIAlertViewDelegate>
+(void)checkAppStoreVersion:(BOOL)isNeedReportNoNewVersion;
@end
