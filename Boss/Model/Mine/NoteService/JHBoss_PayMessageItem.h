//
//  JHBoss_PayMessageItem.h
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//短信支付

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define CreatePayMessageItem(message,sell,residue,sele)   [JHBoss_PayMessageItem createPayMessageItem:message sellCount:sell residueCount:residue select:sele]

@interface JHBoss_PayMessageItem : NSObject

@property (nullable, nonatomic, copy) NSString *sellCount;
@property (nullable, nonatomic, copy) NSString *messageCount;
@property (nullable, nonatomic, copy) NSString *residueCount;

@property (nonatomic, assign, getter=isSelect) BOOL select;

+ (JHBoss_PayMessageItem *)createPayMessageItem:(nullable NSString *)messageCount
                                      sellCount:(nullable NSString *)sellCount
                                   residueCount:(nullable NSString *)residueCount
                                         select:(BOOL)select;

@end

NS_ASSUME_NONNULL_END
