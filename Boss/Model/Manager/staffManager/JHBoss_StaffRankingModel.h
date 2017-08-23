//
//  JHBoss_StaffRankingModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_StaffRankingModel : JHBaseModel
@property (nonatomic , strong) NSNumber            *  negativeCommentNum;//差论数
@property (nonatomic , strong) NSNumber            *  perCapitaConsumption;//人均消费
@property (nonatomic , copy)   NSString              * headImageUrl;
@property (nonatomic , copy)   NSString              * name;
@property (nonatomic , strong) NSNumber            *  serviceResponse;//服务响应时间
@property (nonatomic , strong) NSNumber            *  rewardNum;//打赏次数
@property (nonatomic,  strong) NSNumber            *staffId;
@end
