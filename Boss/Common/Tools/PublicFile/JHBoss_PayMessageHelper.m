//
//  JHBoss_PayMessageHelper.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PayMessageHelper.h"

#import "JHBoss_PayMessageItem.h"

@implementation JHBoss_PayMessageHelper

- (NSMutableArray *)fetchPayMessageItemDataSources {
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:4];
    
    JHBoss_PayMessageItem *item1 = CreatePayMessageItem(@"10000", @"1000", @"5000", NO);
    JHBoss_PayMessageItem *item2 = CreatePayMessageItem(@"5000", @"500", @"1250", NO);
    JHBoss_PayMessageItem *item3 = CreatePayMessageItem(@"3000", @"300", @"500", NO);
    JHBoss_PayMessageItem *item4 = CreatePayMessageItem(@"1000", @"100", @"100", YES);
    JHBoss_PayMessageItem *item5 = CreatePayMessageItem(@"100", @"10", @"10", NO);
    JHBoss_PayMessageItem *item6 = CreatePayMessageItem(@"10", @"10", @"1", NO);
    JHBoss_PayMessageItem *item7 = CreatePayMessageItem(@"1", @"10", @"40", NO);
    
    [tmpArray addObjectsFromArray:@[item1,item3,item4,item6,item7,item5,item2]];
    
    return tmpArray;
}

@end
