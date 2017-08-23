//
//  JHBoss_OrderListModel.m
//  Boss
//
//  Created by jinghankeji on 2017/5/15.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderListModel.h"

@implementation CommentList

@end

@implementation dishesList

@end

@implementation WaiterList

@end

@implementation JHBoss_OrderListModel

+(NSDictionary *)mj_objectClassInArray{

    return @{@"dishesList":[dishesList class],@"waiterList":[WaiterList class],@"commentList":[CommentList class]};

}

@end
