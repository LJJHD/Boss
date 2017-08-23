//
//  JHUserInfoData.m
//  JinghanLife
//
//  Created by 晶汉mac on 2017/2/23.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHUserInfoData.h"
#import <YYCache/YYCache.h>
@interface JHUserInfoData ()
@property (nonatomic, strong) YYCache *yyCache;
@property (nonatomic, copy) NSString *identify;//存储标识
@end

@implementation JHUserInfoData

-(YYCache *)yyCache{
    
    if (!_yyCache) {
        _yyCache = [YYCache cacheWithName:_identify];
    }
    
    return _yyCache;
}


- (void)saveInfoWithData:(NSDictionary*)dic identify:(NSString *)identify{
    

    _identify = identify;
    if (isObjNotEmpty(dic)) {
        
        [self.yyCache setObject:dic forKey:identify];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"token"] forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:dic[@"createTime"] forKey:@"createTime"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)getUserInfoIdentify:(NSString *)identify result:(void(^)(NSDictionary * result))resultBlock
{
     _identify = identify;
    
    [self.yyCache objectForKey:identify withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        
        
        resultBlock((NSMutableDictionary *)object);
        
    }];
    
}
-(void)removeInfoIdentify:(NSString *)identify{

    _identify = identify;
    [self.yyCache removeObjectForKey:identify withBlock:^(NSString * _Nonnull key) {
        
    }];

}


-(void)saveAccount:(NSString *)account{

    [[NSUserDefaults standardUserDefaults] setObject:account forKey:@"userAccount"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(NSString *)account{
    
   NSString *acc =  [[NSUserDefaults standardUserDefaults]objectForKey:@"userAccount"];
    return acc;
}

-(NSString *)createTime{

    NSString *createTime = [[NSUserDefaults standardUserDefaults]objectForKey:@"createTime"];
    return createTime;
}



+(void)saveCurrentSelectRestInfo:(NSDictionary *)restInfo{

    [[NSUserDefaults standardUserDefaults] setObject:restInfo forKey:@"currentRestInfo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSDictionary *)getCurrentSelectRestInfo{

  NSDictionary *dic =  [[NSUserDefaults standardUserDefaults]objectForKey:@"currentRestInfo"];
    return dic;
}

@end
