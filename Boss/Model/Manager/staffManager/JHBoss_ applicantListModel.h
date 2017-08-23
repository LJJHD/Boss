//
//  JHBoss_ applicantListModel.h
//  Boss
//
//  Created by jinghankeji on 2017/5/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"
#import "JHBoss_StaffDetailModel.h"
@interface JHBoss_applicantListModel : JHBaseModel

@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              *name;//应聘者名字
@property (nonatomic , copy) NSString              *sex;//应聘者性别
@property (nonatomic , assign) NSInteger              age;
@property (nonatomic , assign) NSInteger              starMark;//星评分数
@property (nonatomic , assign) NSInteger              evaluationCount;
@property (nonatomic , copy) NSString              *oldRestName;//曾就职餐厅
@property (nonatomic , copy) NSString              *oldJob;//曾任职位
@property (nonatomic , copy) NSString              *photo;//头像
@property (nonatomic , strong) NSArray<JHBoss_StaffEvaluationListModel *> * evaluateListArr;


@end
