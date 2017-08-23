//
//  JHBoss_ADModel.h
//  Boss
//
//  Created by jinghankeji on 2017/7/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_ADModel : JHBaseModel
@property (nonatomic , copy) NSString              * address;
@property (nonatomic , strong) NSNumber            *  port;
@property (nonatomic , strong) NSNumber            *  status;
@property (nonatomic , strong) NSNumber            *  endTime;
@property (nonatomic , strong) NSNumber            *  ID;
@property (nonatomic , copy) NSString              * context;
@property (nonatomic , strong) NSNumber            *  count;
@property (nonatomic , copy) NSString              * picture;
@property (nonatomic , strong) NSNumber            *  page;
@property (nonatomic , strong) NSNumber            *  startTime;
@end
