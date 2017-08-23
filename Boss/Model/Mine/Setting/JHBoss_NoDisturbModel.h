//
//  JHBoss_NoDisturbModel.h
//  Boss
//
//  Created by sftoday on 2017/5/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHBoss_NoDisturbModel : NSObject

@property (nonatomic, assign) BOOL state;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;

@end
