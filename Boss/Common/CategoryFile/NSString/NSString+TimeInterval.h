//
//  NSString+TimeInterval.h
//  Boss
//
//  Created by sftoday on 2017/5/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeInterval)

/**
 <#Description#>

 @param date 日期
 @return 毫秒数
 */
+ (NSString *)timeIntervalFromDate:(NSDate *)date;
+ (nullable NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 比较开始时间和结束时间，开始时间和结束时间为同一天，则比较 是否是今天  昨天 前天  返回相应时间
 如果开始时间和结束时间不为同一天，则拼接开始时间和结束时间返回
 @param begainDate 开始时间
 @param endDate 结束时间
 @return 返回时间
 */
+ (NSString *_Nullable)compareDate:(NSDate *_Nullable)begainDate endDate:(NSDate *_Nullable)endDate;


/**
 时间戳转成指定格式的时间字符串

 @param dateStr 时间戳
 @param format 时间格式
 @return 转换后的时间字符串
 */
+(NSString *_Nullable)dateStr:(NSString *_Nullable)dateStr format:(NSString *_Nullable)format;


/**
 后台传的时间戳和当前时间进行比较 返回 几分钟前  几小时前  和具体时间
 @param dateStr 时间戳
 @return 返回的时间
 */
+(NSString *_Nullable)dateStr:(NSString *_Nullable)dateStr;


/**
 返回指定格式的时间字符串

 @param date 时间date
 @param dateFormat 时间格式
 @return 返回的时间字符串
 */
+(NSString *_Nullable)date:(NSDate *_Nullable)date format:(NSString *_Nullable)dateFormat;

/**
 字符串毫秒数转NSDate

 @param interval 毫秒数
 @return 日期
 */
+(NSDate *)timeIntervalStr:(NSString *)interval;
@end
