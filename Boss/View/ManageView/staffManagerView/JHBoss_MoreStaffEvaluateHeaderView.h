//
//  JHBoss_MoreStaffEvaluateHeaderView.h
//  Boss
//
//  Created by jinghankeji on 2017/5/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <MyLayout/MyLayout.h>

@interface JHBoss_MoreStaffEvaluateHeaderView : MyLinearLayout
@property (nonatomic, strong) MyFlowLayout *flowLayout;
@property (nonatomic, copy) void(^showMoreBlock)(UIButton *);
@property (nonatomic, copy) NSMutableArray *flagArr;
-(instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation flagArr:(NSArray *)flagArr;
@end
