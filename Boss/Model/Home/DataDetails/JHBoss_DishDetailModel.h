//
//  JHBoss_DishDetailModel.h
//  Boss
//
//  Created by sftoday on 2017/5/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHBoss_DishDetailModel : NSObject

@property (nonatomic , copy) NSString              * data;
@property (nonatomic , strong) NSArray<NSString *>              * xlist;
@property (nonatomic , strong) NSArray<NSString *>              * ylist;
@property (nonatomic , copy) NSString              * unit;
@property (nonatomic , copy) NSString              * yunit;

@end
