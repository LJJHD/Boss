//
//  JHBoss_StaffGratuityListModel.h
//  Boss
//
//  Created by jinghankeji on 2017/5/15.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface GratuityList : JHBaseModel
@property (nonatomic , assign) NSInteger              amount;
@property (nonatomic , copy) NSString              *time;
@property (nonatomic , copy) NSString              * person;
@end


@interface JHBoss_StaffGratuityListModel : JHBaseModel
@property (nonatomic , assign) NSInteger              money;
@property (nonatomic , assign) NSInteger              number;
@property (nonatomic , strong) NSArray<GratuityList *>              * rewardContentModels;
@end
