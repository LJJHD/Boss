//
//  JHTabBarButton.m
//  JinghanLife
//
//  Created by 晶汉mac on 2016/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHTabBarButton.h"

@implementation JHTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        
        // self.titleLabel.textColor = [UIColor redColor];
        
        [self setTitleColor:DEF_COLOR_6E6E6E forState:UIControlStateNormal];
        [self setTitleColor:DEF_COLOR_CDA265 forState:UIControlStateSelected];
        
        
    }
    return self;
}


- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
        CGFloat imageW = 22;
        CGFloat imageH = 22;
        return CGRectMake((self.width - imageH) / 2, 8, imageW, imageH);

}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
 
        CGFloat titleY = self.height * JHTabBarButtonImageRatio-8;
        CGFloat titleW = self.width;
        CGFloat titleH = self.height - titleY;
        return CGRectMake(0, titleY, titleW, titleH);
}

- (void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    
    [self setTitle:item.title forState:UIControlStateNormal];
    
    [self setImage:item.image forState:UIControlStateNormal];
    
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    
    
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
}


- (void)removeFromSuperview
{
    //    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}

/**
 *  当利用KVO监听到某个对象的属性改变了, 就会调用这个方法
 *
 *  @param keyPath 被改变的属性的名称
 *  @param object  被监听的那个对象
 *  @param change  存放者被改变属性的值
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    [self setTitle:self.item.title forState:UIControlStateNormal];
    [self setTitle:self.item.title forState:UIControlStateSelected];
    
    
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
}

- (void)setHighlighted:(BOOL)highlighted { }



@end
