//
//  UICollectionView+RegistNib.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (RegistNib)
- (void)registerNibWithClass:(Class)aCellClass;

- (void)registerClassWithClass:(Class)aCellClass;

@end
