//
//  UIScrollView+JH_MJRefresh.h
//  JinghanLife
//
//  Created by jinghan on 17/3/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (JH_MJRefresh)

/**
 * 添加一个引用UIScrollView+MJRefresh的gif图片的下拉刷新控件
 *
 * @param block 进入刷新状态就会自动调用这个block
 */
- (void)addCustomGifHeaderWithRefreshingBlock:(void (^)())block;

/**
 * 添加一个引用UIScrollView+MJRefresh的gif图片的上拉加载控件
 *
 * @param block 进入刷新状态就会自动调用这个block
 */
- (void)addCustomGifFooterWithRefreshingBlock:(void (^)())block;



@end
