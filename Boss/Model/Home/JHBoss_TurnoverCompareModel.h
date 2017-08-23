//
//  JHBoss_TurnoverCompareModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/11.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"


@interface LastYearTurnover : JHBaseModel
@property (nonatomic , copy) NSString              * cdate;
@property (nonatomic , strong) NSNumber              *turnoverAmount;
@end

@interface LastMonthTurnover : JHBaseModel
@property (nonatomic , copy) NSString              * cdate;
@property (nonatomic , strong) NSNumber            *  turnoverAmount;
@end

@interface RateOfLastMonth : JHBaseModel
@property (nonatomic , copy) NSString              * cdate;
@property (nonatomic , copy) NSString              * rate;
@end

@interface ThisYearTurnover : JHBaseModel
@property (nonatomic , copy) NSString              * cdate;
@property (nonatomic , strong) NSNumber            *  turnoverAmount;
@end

@interface RateOfLastYear : JHBaseModel
@property (nonatomic , copy) NSString              * cdate;
@property (nonatomic , copy) NSString              * rate;
@end

@interface JHBoss_TurnoverCompareModel : JHBaseModel
@property (nonatomic , strong) NSArray<LastYearTurnover *>              * lastYearTurnover;
@property (nonatomic , strong) NSArray<LastMonthTurnover *>              * lastMonthTurnover;
@property (nonatomic , strong) NSArray<RateOfLastMonth *>              * rateOfLastMonth;
@property (nonatomic , strong) NSArray<ThisYearTurnover *>              * thisYearTurnover;
@property (nonatomic , strong) NSArray<RateOfLastYear *>              * rateOfLastYear;
@end
