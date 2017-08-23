//
//  UIColor+RGBColor.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGBColor)
#pragma mark - C style
/**
 * 16 进制色值 + alpha值
 */
UIColor* colorWithRGBValue_Hex_alpha(long rgbValue,CGFloat alpha);

/**
 * 16 进制色值 ，alpha值 == 1
 */
UIColor* colorWithRGBValue_Hex(long rgbValue);

/**
 * 10 进制色值 + alpha值
 */
UIColor* colorWithRGBValue_alpha(int r,int g,int b,CGFloat alpha);

/**
 * 10 进制色值 ，alpha值 == 1
 */
UIColor* colorWithRGBValue(int r,int g,int b);

#pragma mark - OC style
/**
 * 16 进制色值 + alpha值
 */
+ (UIColor *)colorWithRGBValue_Hex:(long)rgbValue alphe:(CGFloat)alpha;

/**
 * 16 进制色值 ，alpha值 == 1
 */
+ (UIColor *)colorWithRGBValue_Hex:(long)rgbValue;

/**
 * 10 进制色值 + alpha值
 */
+ (UIColor *)colorWithRGBValue:(int)r g:(int)g b:(int)b alpha:(CGFloat)alpha;

/**
 * 10 进制色值 ，alpha值 == 1
 */
+ (UIColor *)colorWithRGBValue:(int)r g:(int)g b:(int)b;

@end
