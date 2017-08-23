//
//  JHBoss_AppreciationServiceHeaderView.m
//  Boss
//
//  Created by jinghankeji on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_AppreciationServiceHeaderView.h"

@implementation JHBoss_AppreciationServiceHeaderView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
      
//        UIImage *image = [UIImage imageNamed:@"5.1_bg_bg"];
//        UIGraphicsBeginImageContextWithOptions(CGSizeMake(DEF_WIDTH, 644), NO, 0.f);
//        [image drawInRect:CGRectMake(0, 0, DEF_WIDTH, 644)];
//        UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        self.backgroundColor = [UIColor colorWithPatternImage:lastImage];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        imageView.image = [UIImage imageNamed:@"4.2.1_icon_banner"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.and.bottom.mas_equalTo(0);
            make.height.mas_equalTo(MYDIMESCALEH(160));
            
        }];
    }

    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
