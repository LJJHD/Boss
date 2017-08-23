////
////  UICollectionView+CellHeightCache.m
////  JinghanLife
////
////  Created by 方磊 on 2017/2/6.
////  Copyright © 2017年 jinghan. All rights reserved.
////
//
//#import "UICollectionView+CellHeightCache.h"
//#import "UICollectionViewCell+Size.h"
//#import <objc/runtime.h>
//#import <Foundation/Foundation.h>
//
//@interface UICollectionView()
//@property (strong, nonatomic, readwrite) NSCache * cellHeightCache;
//@end
//
//static const void * kCellHeightCacheKey = &kCellHeightCacheKey;
//
//@implementation UICollectionView (CellHeightCache)
//
//- (CGFloat)heightForCell:(Class)aCellClass atIndexPath:(NSIndexPath *)indexPath{
//    NSAssert([aCellClass isKindOfClass:[UICollectionViewCell class]], @"This is not a UICollectionViewCell sub class");
//    NSValue * sizeForCell = [self.cellHeightCache objectForKey:indexPath.JHKeyPath];
//    if (heightForCell == nil) {
//        heightForCell = @(44);
//        if ([aCellClass respondsToSelector:@selector(cellSizeWithParam:)]) {
//             [aCellClass performSelector:@selector(cellSizeWithParam:) withObject:self.paramAtIndexPath(indexPath)];
//        }
//        [self.cellHeightCache setObject:heightForCell forKey:indexPath.JHKeyPath];
//    }
//    return [heightForCell doubleValue];
//}
//
//- (NSCache *)cellHeightCache{
//    NSCache * cache = (NSCache *)objc_getAssociatedObject(self, kCellHeightCacheKey);
//    if (cache == nil) {
//        self.cellHeightCache = [[NSCache alloc]init];
//        self.cellHeightCache.countLimit = 40;
//    }
//    return cache;
//}
//
//- (void)setCellHeightCache:(NSCache *)cellHeightCache{
//    objc_setAssociatedObject(self, kCellHeightCacheKey, cellHeightCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//@end
