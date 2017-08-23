//
//  JHBoss_StaffDetailModel.h
//  Boss
//
//  Created by jinghankeji on 2017/5/15.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_StaffEvaluationListModel : JHBaseModel
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , assign) NSInteger              flag;//1 表示标记 显示黄色   0 表示没有选中灰色
@property (nonatomic , copy) NSString              * content;
@end

@interface JHBoss_StaffAccountModel : JHBaseModel
@property (nonatomic , copy) NSString              * bankCard;
@property (nonatomic , copy) NSString              * wechatNumber;
@end

@interface JHBoss_StaffDetailModel : JHBaseModel
@property (nonatomic , assign) NSInteger              ID;//员工id
@property (nonatomic , strong) NSNumber            *departmentId;//部门id
@property (nonatomic , strong) NSArray<JHBoss_StaffEvaluationListModel *>              * evaluationList;
@property (nonatomic , copy) NSString              * shopName;
@property (nonatomic , copy) NSString              * classify;
@property (nonatomic , copy) NSString              * sex;
@property (nonatomic , copy) NSString              * age;
@property (nonatomic , copy) NSString              * starMark;
@property (nonatomic , assign) NSInteger              evaluationCount;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * photo;
@property (nonatomic , copy) NSString              * address;
@property (nonatomic , copy) NSString              * rewardMoney;
@property (nonatomic , copy) NSString              * dailyServiceCount;
@property (nonatomic , copy) NSString              * serviceResponse;
@property (nonatomic , copy) NSString              * remarks;
@property (nonatomic , strong) NSNumber              * personalCustomPrice;//客单价
@property (nonatomic , strong) JHBoss_StaffAccountModel              * accountModel;
@end
