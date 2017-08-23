//
//  JHBoss_PhysicalExaminationModel.h
//  Boss
//
//  Created by sftoday on 2017/5/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JHBoss_PhysicalExaminationItemModel;

@interface JHBoss_PhysicalExaminationModel : NSObject

@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSMutableArray<JHBoss_PhysicalExaminationItemModel *> *checkList;

@end


@interface JHBoss_PhysicalExaminationItemModel : NSObject

@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *prompt; // 描述
@property (nonatomic, copy) NSString *name;

@end
