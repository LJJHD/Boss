//
//  UIButton+Layout.m
//  YLButton
//
//  Created by HelloYeah on 2016/12/5.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "UIButton+Layout.h"
#import "NSObject+Swizzling.h"
#import <objc/runtime.h>

@interface UIButton ()

@end

@implementation UIButton (Layout)

#pragma mark - ************* 通过运行时动态添加关联 ******************
//定义关联的Key
static const char * kTitleRectKey = "yl_titleRectKey";
- (CGRect)titleRect {
    return [objc_getAssociatedObject(self, kTitleRectKey) CGRectValue];
}

- (void)setTitleRect:(CGRect)rect {
    objc_setAssociatedObject(self, kTitleRectKey, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN);
}

//定义关联的Key
static const char * kImageRectKey = "yl_imageRectKey";
- (CGRect)imageRect {
    NSValue * rectValue = objc_getAssociatedObject(self, kImageRectKey);
    return [rectValue CGRectValue];
}

- (void)setImageRect:(CGRect)rect {
    objc_setAssociatedObject(self, kImageRectKey, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN);
}

#pragma mark - ************* 通过运行时动态替换方法 ******************
+ (void)load {
    [NSObject swizzlingClass:self fromSEL:@selector(titleRectForContentRect:) toSEL:@selector(override_titleRectForContentRect:)];
    [NSObject swizzlingClass:self fromSEL:@selector(imageRectForContentRect:) toSEL:@selector(override_imageRectForContentRect:)];
}
      
- (CGRect)override_titleRectForContentRect:(CGRect)contentRect {
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }
    return [self override_titleRectForContentRect:contentRect];
}

- (CGRect)override_imageRectForContentRect:(CGRect)contentRect {
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [self override_imageRectForContentRect:contentRect];
}

- (void)setTitleRect:(CGRect )titleRect ImageRect:(CGRect )imageRect {
    self.titleRect = titleRect;
    self.imageRect = imageRect;
}

/*
- (void)verticalImageAndTitle:(CGFloat)spacing
{
    self.titleLabel.backgroundColor = [UIColor greenColor];
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
//    CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
//     CGSize textSize = [self.titleLabel.text sizeWithAttributes:<#(nullable NSDictionary<NSString *,id> *)#>];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}
*/
@end
