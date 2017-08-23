//
//  JHCRM_CerFootSectionView.h
//  Boss
//
//  Created by 晶汉mac on 2017/3/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHCRM_CerFootSectionViewDelegate <NSObject>

- (void)choseImageWith:(void(^)(UIImage *image))param;

@end

@interface JHCRM_CerFootSectionView : UIView
@property (nonatomic,weak) id  delegate;
- (instancetype)initWithFrame:(CGRect)frame permitArr:(NSArray *)permitArr;
@end
