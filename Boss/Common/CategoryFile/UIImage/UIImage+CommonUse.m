//
//  UIImage+CommonUse.m
//  Boss
//
//  Created by jinghankeji on 2017/3/11.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UIImage+CommonUse.h"

@implementation UIImage (CommonUse)

+(UIImage *)imageFromColor:(UIColor *)color size:(CGRect)rect{

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
