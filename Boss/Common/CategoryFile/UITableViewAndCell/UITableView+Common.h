//
//  UITableView+Common.h
//  JinghanLife
//
//  Created by 晶汉mac on 2017/2/21.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Common)
/**
 设置表的foot为空视图，主要用于表的数据少的时候空 cell的情况
 **/
-(void)setExtraCellLineHidden;
/**
 设置cell的分割到最左边配合cell同样的方法使用
 **/
- (void)setCellLineUIEdgeInsetsZero;
@end
