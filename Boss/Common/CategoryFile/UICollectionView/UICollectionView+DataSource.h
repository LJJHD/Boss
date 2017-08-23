//
//  UICollectionView+DataSource.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (DataSource)
 
@property (assign, nonatomic, readonly) NSInteger JHNumberOfSections;
@property (copy, nonatomic, readonly) NSInteger(^numberOfRowInSection)(NSInteger section);

@property (copy, nonatomic, readonly) CGSize(^sizeForItem)(Class aClass,NSIndexPath *indexPath,CGSize(^configureBlock)());

@property (copy, nonatomic, readonly) id(^paramAtIndexPath)(NSIndexPath *indexPath);

/**
 * 使用 section 数来创建 datasource，datasource 是一个字典，管理每个section，每个 section 中用一个数组来管理
 * 会根据 section 来创建相应数量的 array 加入管理。
 */
- (void)setupWithSections:(int)numberOfSection;

/**
 * 创建一个新的 secion 来存储数据
 */
- (void)addParamToNewSection:(NSArray *)params;

/**
 * 将数据加入已有的 section 中
 */
- (void)addParam:(NSArray *)params intoExistSection:(NSInteger)section;

/**
 缓存并计算 cell 的 size，一般情况下，cell 需要重载 sizeWithParam 方法，各个 cell 自己计算size，
 但是，考虑到在实际情况中，可能在 cell 里计算不方便，所以提供 block ，进行动态计算。
 */
- (CGSize)sizeForItem:(Class)aCellClass atIndexPath:(NSIndexPath *)indexPath configureBlock:(CGSize (^)(void))configure;

- (CGSize)sizeForItem:(Class)aCellClass atIndexPath:(NSIndexPath *)indexPath;


@end
