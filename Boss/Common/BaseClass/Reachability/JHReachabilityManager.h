//
//  JHReachabilityManager.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Reachability/Reachability.h>

@interface JHReachabilityManager : Reachability
+ (instancetype)shareManager;
+ (void)setup;

@end
