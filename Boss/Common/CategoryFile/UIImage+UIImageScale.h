//
//  UIImage+UIImageScale.h
//  YHOUSE
//
//  Created by FENG on 14-5-8.
//  Copyright (c) 2014年 FENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageScale)
/**
 *  截取子image
 *
 *  @param rect 大小
 *
 *  @return 截取后的image
 */
-(UIImage*)getSubImage:(CGRect)rect;

/**
 *  缩放image
 *
 *  @param size 大小
 *
 *  @return 缩放后的图片
 */
-(UIImage*)scaleToSize:(CGSize)size;

@end
