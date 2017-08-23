//
//  JHBoss_TableListModel.h
//  Boss
//
//  Created by jinghankeji on 2017/5/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface TableModels : JHBaseModel
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              * state;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , copy) NSString              * name;
@end

@interface JHBoss_TableListModel : JHBaseModel
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , strong) NSArray<TableModels *>              * tableModels;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , copy) NSString              * name;
@end
