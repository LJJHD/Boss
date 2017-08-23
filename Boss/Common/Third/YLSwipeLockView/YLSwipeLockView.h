//
//  YLSwipeLockView.h
//  YLSwipeLockViewDemo
//
//  Created by 肖 玉龙 on 15/2/12.
//  Copyright (c) 2015年 Yulong Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define LIGHTBLUE [UIColor colorWithRed:0 green:170/255.0 blue:1 alpha:1]

typedef NS_ENUM(NSUInteger, YLSwipeLockViewState) {
    YLSwipeLockViewStateNormal,
    YLSwipeLockViewStateWarning,
    YLSwipeLockViewStateSelected
};
@protocol YLSwipeLockViewDelegate;

@interface YLSwipeLockView : UIView
@property (nonatomic, weak) id<YLSwipeLockViewDelegate> delegate;
-(void)cleanNodesIfNeeded;
@end


@protocol YLSwipeLockViewDelegate<NSObject>
@optional
-(YLSwipeLockViewState)swipeView:(YLSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password;
@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
