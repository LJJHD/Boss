//
//  JHCache.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHCache.h"
#import "JHNetworkingConfiguration.h"
#import "NSDictionary+JHNetworkingMethods.h"

@interface JHCache()

@property (strong, nonatomic) NSCache * cache;

@end

@implementation JHCache

#pragma mark - life cycle
+ (instancetype)sharedInstance{
    static JHCache * sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JHCache alloc]init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                            methodName:(NSString *)methodName
                         requestParams:(NSDictionary *)requestParams{
    return [NSString stringWithFormat:@"%@%@%@",serviceIdentifier,methodName,[requestParams JH_transformedUrlParamsArraySignature:NO]];
}

- (NSData *)fetchCachedDataWithServiceIdentifier:(NSString *)serviceIdentifier
                                      methodName:(NSString *)methodName
                                   requestParams:(NSDictionary *)requestParams{
    return [self fetchCachedDataWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)saveCacheWithData:(NSData *)cachedData
        serviceIdentifier:(NSString *)serviceIdentifier
               methodName:(NSString *)methodName
            requestParams:(NSDictionary *)requestParams{
    [self saveCacheWithData:cachedData key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (void)deleteCacheWithServiceIdentifier:(NSString *)serviceIdentifier
                              methodName:(NSString *)methodName
                           requestParams:(NSDictionary *)requestParams{
    [self deleteCacheWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:requestParams]];
}

- (NSData *)fetchCachedDataWithKey:(NSString *)key
{
    JHCachedObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject.isOutdated || cachedObject.isEmpty) {
        return nil;
    } else {
        return cachedObject.content;
    }
}

- (void)saveCacheWithData:(NSData *)cachedData key:(NSString *)key{
    JHCachedObject *cachedObject = [self.cache objectForKey:key];
    if (cachedObject == nil) {
        cachedObject = [[JHCachedObject alloc] init];
    }
    [cachedObject updateContent:cachedData];
    [self.cache setObject:cachedObject forKey:key];
}

- (void)deleteCacheWithKey:(NSString *)key{
    [self.cache removeObjectForKey:key];
}

- (void)clean{
    [self.cache removeAllObjects];
}

#pragma mark - setter / getter
- (NSCache *)cache{
    if (isObjEmpty(_cache)) {
        _cache = [[NSCache alloc]init];
        _cache.countLimit = kJHCacheCountLimit;
    }
    return _cache;
}

@end
