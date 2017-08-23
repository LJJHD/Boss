//
//  UIView+CurrentViewController.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UIView+CurrentViewController.h"

@implementation UIView (CurrentViewController)
- (UIViewController *)currentViewController{
    UIResponder * responder = self;
    UIViewController * currentViewController;
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {//是 viewcontroller 的子类
           currentViewController = (UIViewController *)responder;
            break;
        }else{
            responder = responder.nextResponder;
        }
    }
    return currentViewController;
}
@end
