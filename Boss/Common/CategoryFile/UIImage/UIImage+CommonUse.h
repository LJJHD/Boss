//
//  UIImage+CommonUse.h
//  Boss
//
//  Created by jinghankeji on 2017/3/11.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CommonUse)
//给定颜色和大小绘制图片
+(UIImage *)imageFromColor:(UIColor *)color size:(CGRect )rect;
@end
