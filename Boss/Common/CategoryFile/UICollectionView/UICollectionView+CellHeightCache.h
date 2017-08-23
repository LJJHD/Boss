//
//  UICollectionView+CellHeightCache.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//
//
#import <UIKit/UIKit.h>

@interface UICollectionView (CellHeightCache)

@property (strong, nonatomic, readonly) NSCache * cellHeightCache;

- (CGFloat)heightForCell:(Class)aCellClass atIndexPath:(NSIndexPath *)indexPath;

@end
