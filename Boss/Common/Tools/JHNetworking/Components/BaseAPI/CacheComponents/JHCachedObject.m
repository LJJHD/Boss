//
//  JHCachedObject.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHCachedObject.h"
#import "JHNetworkingConfiguration.h"

@interface JHCachedObject()

@property (nonatomic, copy, readwrite) NSData *content;
@property (nonatomic, copy, readwrite) NSDate *lastUpdateTime;

@end

@implementation JHCachedObject

#pragma mark  - life cycle
- (instancetype)initWithContent:(NSData *)content{
    if (self = [super init]) {
        self.content = content;
    }
    return self;
}

#pragma mark - public methods
- (void)updateContent:(NSData *)content{
    self.content = content;
}

#pragma mark - setter / getter
- (BOOL)isEmpty{
    return isObjEmpty(self.content);
}

- (BOOL)isOutdated{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > kJHCacheOutdateTimeSeconds;
}

- (void)setContent:(NSData *)content{
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}

@end
