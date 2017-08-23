//
//  UICollectionView+RegistNib.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UICollectionView+RegistNib.h"

@implementation UICollectionView (RegistNib)

- (void)registerNibWithClass:(Class)aCellClass{
    UINib * nib = [UINib nibWithNibName:NSStringFromClass(aCellClass) bundle:[NSBundle mainBundle]];
    [self registerNib:nib forCellWithReuseIdentifier:[aCellClass description]];
}

- (void)registerClassWithClass:(Class)aCellClass{
    [self registerClass:aCellClass forCellWithReuseIdentifier:[aCellClass description]];
}

@end
