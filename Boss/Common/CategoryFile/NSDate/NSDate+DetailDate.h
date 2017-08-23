//
//  NSDate+DetailDate.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DetailDate)

@property (assign ,nonatomic, readonly) int year;
@property (assign, nonatomic, readonly) int month;
@property (assign, nonatomic, readonly) int day;
@property (assign, nonatomic, readonly) int hour;
@property (assign, nonatomic, readonly) int minute;
@property (assign, nonatomic, readonly) int second;

/**
 * 通过给定的日期格式，格式化日期。例如：
 * formatter = @”YYYY-MM-DD,HH:mm:dd“
 * 输出 年-月-日，时:分:秒
 */
- (NSString *)transformDateFromFormatterString:(NSString *)formatter;
@end
