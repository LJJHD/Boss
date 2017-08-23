//
//  UICollectionViewCell+Size.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewCell (Size)

/**
 * override by collectionViewCell subClasses
 */
- (NSValue *)sizeWithParam:(id)param;
@end
