//
//  JH_SliderSegmentView.h
//  JinghanLife
//
//  Created by 晶汉mac on 2017/3/14.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JH_SliderCollectionViewCell.h"


@protocol JH_SliderSegmentViewDelegate <NSObject>

- (void)sliderSegmentView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSInteger )index;


@end

@interface JH_SliderSegmentView : UIView
@property (nonatomic,strong) UIScrollView   *sliderScrolView;
@property (nonatomic,strong) NSArray    *modelArray;
@property (nonatomic,weak) id           delegate;
//暂时废弃
- (id)initWithTitleArray:(NSArray*)array;

@end
