//
//  JHBoss_DataDetailsModel.h
//  Boss
//
//  Created by sftoday on 2017/5/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHBoss_DataDetailsModel : NSObject

@property (nonatomic, copy) NSArray<NSNumber *> *dataList;
@property (nonatomic, copy) NSArray<NSString *> *hoursList;
@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, strong) NSNumber *data;
@property (nonatomic, strong) NSNumber *compare;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *unit;

@end
