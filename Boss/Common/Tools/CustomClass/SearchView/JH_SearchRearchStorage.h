//
//  JH_SearchRearchStorage.h
//  SuppliersCRM
//
//  Created by jinghankeji on 2017/3/24.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JH_SearchRearchStorage : NSObject


- (void)setStorageValue:(NSMutableArray *)storageValue forIdentify:(NSString *)identify maxNumStorage:(NSUInteger)maxNum;

- (void)getStorageValueForIdentify:(NSString *)identify result:(void(^)(NSMutableArray * result))resultBlock;
//清空缓存记录
- (void)removeAllStorageForIdentify:(NSString *)identify;
@end
