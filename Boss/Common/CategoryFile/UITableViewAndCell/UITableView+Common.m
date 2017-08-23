//
//  UITableView+Common.m
//  JinghanLife
//
//  Created by 晶汉mac on 2017/2/21.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UITableView+Common.h"

@implementation UITableView (Common)
-(void)setExtraCellLineHidden
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
}
- (void)setCellLineUIEdgeInsetsZero
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}
@end
