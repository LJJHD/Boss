//
//  JHBoss_DishesListModel.h
//  Boss
//
//  Created by jinghankeji on 2017/5/15.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface DishesList : JHBaseModel
@property (nonatomic , assign) NSInteger              number;
@property (nonatomic , assign) NSInteger              goodCount;
@property (nonatomic , assign) NSInteger              compare;
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , assign) NSInteger              price;
@property (nonatomic , assign) NSInteger              stock;
@property (nonatomic , copy) NSString              * picture;
@property (nonatomic , assign) NSInteger              memberPrice;
@property (nonatomic , copy) NSString              * name;
@end

@interface JHBoss_DishesListModel : JHBaseModel
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , assign) NSInteger              count;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , strong) NSArray<DishesList *>              * dishesList;
@end
