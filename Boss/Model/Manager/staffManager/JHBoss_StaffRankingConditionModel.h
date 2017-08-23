//
//  JHBoss_StaffRankingConditionModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_StaffRankingConditionModel : JHBaseModel
@property (nonatomic , assign) BOOL              sortType;
@property (nonatomic , copy) NSString              * attribute;
@property (nonatomic , copy) NSString              * sortName;
@end
