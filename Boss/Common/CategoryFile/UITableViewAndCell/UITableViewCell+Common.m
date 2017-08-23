//
//  UITableViewCell+Common.m
//  JinghanLife
//
//  Created by 晶汉mac on 2017/2/21.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UITableViewCell+Common.h"

@implementation UITableViewCell (Common)
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
