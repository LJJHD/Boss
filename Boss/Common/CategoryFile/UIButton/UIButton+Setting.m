//
//  UIButton+Setting.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UIButton+Setting.h"

@implementation UIButton (Setting)
- (void)setTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateDisabled];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateFocused];
}

- (void)setimage:(NSString *)imageName{
    UIImage * image = [UIImage imageNamed:imageName];
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateHighlighted];
    [self setImage:image forState:UIControlStateDisabled];
    [self setImage:image forState:UIControlStateSelected];
    [self setImage:image forState:UIControlStateFocused];
}

@end
