//
//  UIColor+RGBColor.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UIColor+RGBColor.h"

@implementation UIColor (RGBColor)

UIColor* colorWithRGBValue_Hex_alpha(long rgbValue,CGFloat alpha){
    return [UIColor colorWithRGBValue_Hex:rgbValue alphe:alpha];
}

UIColor* colorWithRGBValue_Hex(long rgbValue){
    return colorWithRGBValue_Hex_alpha(rgbValue, 1.0);
}

UIColor* colorWithRGBValue_alpha(int r,int g,int b,CGFloat alpha){
    return [UIColor colorWithRGBValue:r g:g b:b alpha:alpha];
}

UIColor* colorWithRGBValue(int r,int g,int b){
    return colorWithRGBValue_alpha(r, g, b, 1.0);
}

#pragma mark - OC style
/**
 * 16 进制色值 + alpha值
 */
+ (UIColor *)colorWithRGBValue_Hex:(long)rgbValue alphe:(CGFloat)alpha{
    return [self colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0
                           green:((rgbValue & 0xFF00) >> 8)/255.0
                            blue:(rgbValue & 0xFF)/255.0
                           alpha:alpha];
}

/**
 * 16 进制色值 ，alpha值 == 1
 */
+ (UIColor *)colorWithRGBValue_Hex:(long)rgbValue{
    return [self colorWithRGBValue_Hex:rgbValue alphe:1.0];
}

/**
 * 10 进制色值 + alpha值
 */
+ (UIColor *)colorWithRGBValue:(int)r g:(int)g b:(int)b alpha:(CGFloat)alpha{
    return [self colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:alpha];
}

/**
 * 10 进制色值 ，alpha值 == 1
 */
+ (UIColor *)colorWithRGBValue:(int)r g:(int)g b:(int)b{
    return [self colorWithRGBValue:r g:g b:b alpha:1.0];
}


@end
