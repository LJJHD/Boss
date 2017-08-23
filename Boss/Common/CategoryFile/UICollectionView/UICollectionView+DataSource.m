//
//  UICollectionView+DataSource.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UICollectionView+DataSource.h"
#import <objc/runtime.h>

@interface UICollectionView()
@property (strong, nonatomic) NSMutableDictionary * JHDataSource;
@property (strong, nonatomic) UICollectionViewCell * sizeCalculatCell;
@end

static void * kJHDataSourceKey = &kJHDataSourceKey;
static void * kJHSizeCalculatCellKey;

@implementation UICollectionView (DataSource)

- (void)setupWithSections:(int)numberOfSection{
    self.JHDataSource = [NSMutableDictionary dictionaryWithCapacity:numberOfSection];
    for (NSInteger index = 0; index < numberOfSection; index++) {
        [self.JHDataSource setObject:[NSMutableArray array] forKey:[@(index)stringValue]];
    }
}

- (void)addParamToNewSection:(NSArray *)params{
    NSMutableArray * paramArray = [NSMutableArray arrayWithArray:params];
    [self.JHDataSource setObject:paramArray forKey:[@(self.numberOfSections + 1) stringValue]];
}

- (void)addParam:(NSArray *)params intoExistSection:(NSInteger)section{
    NSMutableArray * paramsArray = [self.JHDataSource objectForKey:[@(section) stringValue]];
    NSAssert(isObjNotEmpty(paramsArray), @"No such section");
    [paramsArray addObjectsFromArray:params];
}

#pragma mark - private method

- (CGSize)sizeForItem:(Class)aCellClass atIndexPath:(NSIndexPath *)indexPath configureBlock:(CGSize (^)(void))configure{
    if (![self.sizeCalculatCell isMemberOfClass:aCellClass]) {
        self.sizeCalculatCell = [aCellClass alloc];
    }
    NSAssert([self.sizeCalculatCell isKindOfClass:[UICollectionViewCell class]], @"must be a UICollectionViewCell or sub Class");
    NSValue * sizeForCell = [self.cellSizeCache objectForKey:indexPath.JHKeyPath];
    if (isObjEmpty(sizeForCell)) {
        sizeForCell = [NSValue valueWithCGSize:CGSizeMake(44, 44)];
        if (configure != nil) {
            sizeForCell = [NSValue valueWithCGSize:configure()];
        }else if ([self.sizeCalculatCell respondsToSelector:@selector(sizeWithParam:)]) {
            sizeForCell = [self.sizeCalculatCell sizeWithParam:self.paramAtIndexPath(indexPath)];
        }
        [self.cellSizeCache setObject:sizeForCell forKey:indexPath.JHKeyPath];
    }
    return [sizeForCell CGSizeValue];
}

- (CGSize)sizeForItem:(Class)aCellClass atIndexPath:(NSIndexPath *)indexPath{
    return [self sizeForItem:aCellClass atIndexPath:indexPath configureBlock:nil];
}

#pragma mark - setter / getter
- (NSMutableDictionary *)JHDataSource{
    return (NSMutableDictionary *)objc_getAssociatedObject(self, kJHDataSourceKey);
}

- (void)setJHDataSource:(NSMutableDictionary *)JHDataSource{
    objc_setAssociatedObject(self, kJHDataSourceKey, JHDataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)JHNumberOfSections{
    return self.JHDataSource.allKeys.count;
}

- (NSInteger (^)(NSInteger))numberOfRowInSection{
    return ^(NSInteger section){
        NSMutableArray * paramArray = [self.JHDataSource objectForKey:[@(section) stringValue]];
        return (NSInteger)paramArray.count;
    };
}

- (UICollectionViewCell *)sizeCalculatCell{
    return objc_getAssociatedObject(self, kJHSizeCalculatCellKey);
}

- (void)setSizeCalculatCell:(UICollectionViewCell *)sizeCalculatCell{
    objc_setAssociatedObject(self, kJHSizeCalculatCellKey, sizeCalculatCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize (^)(__unsafe_unretained Class, NSIndexPath *, CGSize (^)()))sizeForItem{
    return ^(Class aCellClass,NSIndexPath * indexPath,CGSize(^configure)()){
        return [self sizeForItem:aCellClass atIndexPath:indexPath configureBlock:configure];
    };
}

- (id(^)(NSIndexPath *))paramAtIndexPath{
    return ^(NSIndexPath * indexPath){
        NSMutableArray * paramArray = [self.JHDataSource objectForKey:[@(indexPath.section) stringValue]];
        if (paramArray != nil && paramArray.count > indexPath.row) {
            return paramArray[indexPath.row];
        }
        return (id)nil;
    };
}

@end
