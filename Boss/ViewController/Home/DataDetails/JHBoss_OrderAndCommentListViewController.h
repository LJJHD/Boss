//
//  JHBoss_OrderAndCommentListViewController.h
//  Boss
//
//  Created by jinghankeji on 2017/6/21.
//  Copyright © 2017年 jinghan. All rights reserved.
//  订单异常列表和差评列表

#import <UIKit/UIKit.h>

@interface JHBoss_OrderAndCommentListViewController : UIViewController
@property (nonatomic, assign) JHBoss_OrderOrComment orderOrCommentEntInto;
@property (nonatomic, copy) NSString *merchanId;
@property (nonatomic, copy) NSString *BegainSelectedDate;//选中的开始日期
@property (nonatomic, copy) NSString *EndSelectedDate;//选中的结束日期
@end
