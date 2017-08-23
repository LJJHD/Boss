//
//  UICollectionView+CellSizeCache.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UICollectionView+CellSizeCache.h"
#import <objc/runtime.h>

@interface UICollectionView()

@property (strong, nonatomic, readwrite) NSCache * cellSizeCache;

@end

static const void * kCellSizeCacheKey;

@implementation UICollectionView (CellSizeCache)

- (NSCache *)cellSizeCache{
    NSCache * cache = (NSCache *)objc_getAssociatedObject(self, kCellSizeCacheKey);
    if (isObjEmpty(cache)) {
        cache = [[NSCache alloc]init];
        cache.countLimit = 40;
        self.cellSizeCache = cache;
    }
    return cache;
}

- (void)setCellSizeCache:(NSCache *)cellSizeCache{
    objc_setAssociatedObject(self, kCellSizeCacheKey, cellSizeCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
