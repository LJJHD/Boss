//
//  UIControl+PreverQuickTapsBtn.h
//  Boss
//
//  Created by jinghankeji on 2017/4/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (PreverQuickTapsBtn)
@property (nonatomic, assign) NSTimeInterval JHBtn_acceptEventInterval;//添加点击事件的间隔时间

@property (nonatomic, assign) BOOL JHBtn_ignoreEvent;//是否忽略点击事件,不响应点击事件
@end
