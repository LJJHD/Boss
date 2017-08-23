//
//  UICollectionViewCell+CellHeight.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (CellHeight)

/**
 * override by collectionViewCell subClasses
 */
+ (CGFloat)cellHeightWithParam:(id)param;
@end
