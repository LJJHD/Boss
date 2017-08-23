//
//  UIFont+JHBoss_FontFit.m
//  Boss
//
//  Created by jinghankeji on 2017/7/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#define MyUIScreen  375 // UI设计原型图的手机尺寸宽度(6s), 6p的--414

// 这里设置iPhone6放大的字号数（现在是缩小2号，也就是iPhone6上字号为17，在iPhone4s和iPhone5上字体为15时，）
#define IPHONE5_INCREMENT 1.5

// 这里设置iPhone6Plus放大的字号数（现在是放大1号，也就是iPhone6上字号为17，在iPhone6P上字体为18时）
#define IPHONE6PLUS_INCREMENT 1.0

#import "UIFont+JHBoss_FontFit.h"

@implementation UIFont (JHBoss_FontFit)

+(void)load{

    //获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    
    //获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    
    //交换方法
    method_exchangeImplementations(newMethod, method);

}

//在6p上字体扩大1.5倍
//+(UIFont *)adjustFont:(CGFloat)fontSize{
//    
//    UIFont *newFont = nil;
//    if (DEF_DEVICE_Iphone6p){
//        newFont = [UIFont adjustFont:fontSize * 1.5];
//    }else{
//        newFont = [UIFont adjustFont:fontSize];
//    }
//    return newFont;
//}

//以6s为基准（因为一般UI设计是以6s尺寸为基准设计的）的字体。在5s和6P上会根据屏幕尺寸，字体大小会相应的扩大和缩小
//+ (UIFont *)adjustFont:(CGFloat)fontSize {
//    UIFont *newFont = nil;
//    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width/MyUIScreen];
//    return newFont;
//}

//以6s为基准（因为一般UI设计是以6s尺寸为基准设计的）的字体。在5s和6P上会根据屏幕尺寸，字体大小会相应的扩大和缩小
//在6s上字号是17,在6P是上字号扩大到18号（字号扩大1个字号），在4s和5s上字号缩小到15号字（字号缩小2个字号）
+(UIFont *)adjustFont:(CGFloat)fontSize{

    UIFont *newFont = nil;
    if (DEF_DEVICE_Iphone5 || DEF_DEVICE_Iphone4){
        newFont = [UIFont adjustFont:fontSize - IPHONE5_INCREMENT];
    }else if (DEF_DEVICE_Iphone6p){
        newFont = [UIFont adjustFont:fontSize + IPHONE6PLUS_INCREMENT];
    }else{
        newFont = [UIFont adjustFont:fontSize];
    }
    return newFont;
}


@end
