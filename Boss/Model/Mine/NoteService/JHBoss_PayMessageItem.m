//
//  JHBoss_PayMessageItem.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PayMessageItem.h"

@implementation JHBoss_PayMessageItem

+ (JHBoss_PayMessageItem *)createPayMessageItem:(NSString *)messageCount
                                      sellCount:(NSString *)sellCount
                                   residueCount:(NSString *)residueCount
                                         select:(BOOL)select {
    
    JHBoss_PayMessageItem *item = [[JHBoss_PayMessageItem alloc] init];
    
    item.select       = select;
    item.sellCount    = sellCount;
    item.residueCount = residueCount;
    item.messageCount = messageCount;

    return item;
}

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"sellCount"   : @"price",
             @"residueCount":@"gift",
             @"messageCount":@"strip"};
}


@end
