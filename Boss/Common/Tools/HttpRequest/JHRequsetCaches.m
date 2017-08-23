//
//  JHRequsetCaches.m
//  JinghanLife
//
//  Created by 晶汉mac on 2017/2/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHRequsetCaches.h"
#import <YYCache.h>
#define JHREQUESTCACHE  @"JHREQUESTCACHE"

typedef void(^RequsetSuccess)(id object);


@interface JHRequsetCaches ()
@property (nonatomic,strong) YYDiskCache  *diskCache;
@end

@implementation JHRequsetCaches
+ (JHRequsetCaches*)shareInstance
{
    static JHRequsetCaches *__requestCaches = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __requestCaches = [[JHRequsetCaches alloc] init];
        [__requestCaches initCacheObj];
    });
    return __requestCaches;
}
- (void)initCacheObj
{
    NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [cacheFolder stringByAppendingPathComponent:JHREQUESTCACHE];
    self.diskCache = [[YYDiskCache alloc] initWithPath:path];
}
+ (void)saveDataWith:(id)data withKey:(NSString*)key
{

    [[self shareInstance].diskCache setObject:data forKey:key withBlock:^{
        
    }];
}
+ (id)getCachesDataWithKey:(NSString*)key
{
    return  [[self shareInstance].diskCache objectForKey:key];
}
+ (void)removeObjectForkey:(NSString*)key
{
    [[self shareInstance].diskCache removeObjectForKey:key];
}
+ (void)removeAllObject
{
    [[self shareInstance].diskCache removeAllObjects];
}
@end
