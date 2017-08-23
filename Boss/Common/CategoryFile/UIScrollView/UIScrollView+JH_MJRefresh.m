//
//  UIScrollView+JH_MJRefresh.m
//  JinghanLife
//
//  Created by jinghan on 17/3/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UIScrollView+JH_MJRefresh.h"

@implementation UIScrollView (JH_MJRefresh)

#pragma mark - gif 下拉刷新 隐藏状态时间
- (void)addCustomGifHeaderWithRefreshingBlock:(void (^)())block;{
    NSMutableArray *headerImages = [[NSMutableArray alloc] init];
 
    for (int i = 1; i <= 9; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"boss_loading_%zd",i]];
        [headerImages addObject:image];
    }
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        block();
    }];
    
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setImages:@[headerImages[0]] forState:MJRefreshStateIdle];
    [header setImages:headerImages forState:MJRefreshStateRefreshing];
    
    self.mj_header = header;
    
}

- (void)addCustomGifFooterWithRefreshingBlock:(void (^)())block{
    NSMutableArray *footerImages = [[NSMutableArray alloc] init];
    
    for (int i = 1; i <= 25; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh-%d",i]];
        [footerImages addObject:image];
    }
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        block();
    }];
    
    footer.stateLabel.hidden = YES;
    [footer setImages:@[footerImages[0]] forState:MJRefreshStateIdle];
    [footer setImages:footerImages forState:MJRefreshStateRefreshing];
    
    self.mj_footer = footer;
}

@end
