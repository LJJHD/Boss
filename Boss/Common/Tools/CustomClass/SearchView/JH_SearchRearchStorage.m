//
//  JH_SearchRearchStorage.m
//  SuppliersCRM
//
//  Created by jinghankeji on 2017/3/24.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JH_SearchRearchStorage.h"
#import <YYCache.h>

@interface JH_SearchRearchStorage ()<NSCoding>
@property (nonatomic, strong) YYCache *yyCache;
@property (nonatomic, copy) NSString *identify;//存储标识
@property (nonatomic, assign) NSUInteger maxNum;//最大存储数
@property (nonatomic, strong) NSMutableArray *storageDataArr;
@end

@implementation JH_SearchRearchStorage
- (void)setStorageValue:(NSMutableArray *)storageValue forIdentify:(NSString *)identify maxNumStorage:(NSUInteger)maxNum{
    _storageDataArr = storageValue;
    
    if (storageValue.count > maxNum) {
        
        [storageValue removeObjectsInRange:NSMakeRange(0, 1)];
        
    }else if (storageValue.count <= 0){
    
        return;
    }
    
    [self.yyCache setObject:storageValue forKey:identify];

}

- (void)getStorageValueForIdentify:(NSString *)identify result:(void(^)(NSMutableArray * result))resultBlock{

    _identify = identify;
    
    [self.yyCache objectForKey:identify withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
       
        
        resultBlock((NSMutableArray *)object);
      
    }];
    
}

- (void)removeAllStorageForIdentify:(NSString *)identify{

    _identify = identify;
    
    [self.yyCache removeObjectForKey:identify withBlock:^(NSString * _Nonnull key) {
        
        
    }];


}


-(YYCache *)yyCache{

    if (!_yyCache) {
        _yyCache = [YYCache cacheWithName:_identify];
    }

    return _yyCache;
}
@end
