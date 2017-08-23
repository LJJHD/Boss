//
//  JHBoss_OrderDetailEvaluateView.h
//  Boss
//
//  Created by jinghankeji on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <MyLayout/MyLayout.h>
#import "JHBoss_OrderListModel.h"
@interface JHBoss_OrderDetailEvaluateView : MyLinearLayout
@property (nonatomic, strong) CommentList *model;
@property (nonatomic, strong) NSArray *commentArr;//服务员评价
@property (nonatomic, strong) NSArray *restArr;//餐厅评价
@end
