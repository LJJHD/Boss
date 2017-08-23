//
//  UIImage+Blur.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blur)
- (UIImage *)blurWithRadius:(CGFloat)blurRadius
                  tintColor:(UIColor *)tintColor
      saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                  maskImage:(UIImage *)maskImage;
@end
