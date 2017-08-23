//
//  NSString+TimeInterval.m
//  Boss
//
//  Created by sftoday on 2017/5/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "NSString+TimeInterval.h"

@implementation NSString (TimeInterval)

+ (NSString *)timeIntervalFromDate:(NSDate *)date
{
       
    // NSTimeInterval返回的是double类型，输出会显示为10位整数加小数点加一些其他值
    // 如果想转成int型，必须转成long long型才够大。
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    long long dTime = [[NSNumber numberWithDouble:time] longLongValue]; // 将double转为long long型
    NSString *curTime = [NSString stringWithFormat:@"%llu",dTime]; // 输出long long型
    return curTime;
}

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

+ (NSString *_Nullable)compareDate:(NSDate *_Nullable)begainDate endDate:(NSDate *_Nullable)endDate{

     NSString *showDateStr;
    NSDate *currentDate = [NSDate date];//今天
    NSDate *yesterday = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:currentDate];//昨天
    NSDate *beforeYesterday = [NSDate dateWithTimeInterval:-48*60*60 sinceDate:currentDate];//前天

    // 获得比较结果(谁大谁小)
    NSComparisonResult result = [begainDate compare:endDate];
    if (result == NSOrderedSame) { // 升序, 越往右边越大
        //开始时间和结束时间是同一时间
        NSCalendar *calender = [NSCalendar currentCalendar];
        
        if ([calender isDate:begainDate inSameDayAsDate:currentDate] ) {
            
            showDateStr = @"今日";
        }else if ([calender isDate:begainDate inSameDayAsDate:yesterday]){
            
            showDateStr = @"昨天";
        }else if ([calender isDate:begainDate inSameDayAsDate:beforeYesterday]){
            
            showDateStr = @"前天";
        }else{
        
            showDateStr  = [NSString stringWithFormat:@"%@-%@",[self date:begainDate format:@"YYYY.MM.dd"],[self date:endDate format:@"YYYY.MM.dd"]];

        }
        
    }else{
        
        showDateStr  = [NSString stringWithFormat:@"%@-%@",[self date:begainDate format:@"YYYY.MM.dd"],[self date:endDate format:@"YYYY.MM.dd"]];
    }
    return showDateStr;
}

+(NSString *)dateStr:(NSString *)dateStr{

   
    NSTimeInterval oldtTimeInterval= [dateStr doubleValue]/1000;

    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    //相差秒数
    double distanceTime = now - oldtTimeInterval;
    NSString *distanceStr;
    
    NSDate *oldDate = [NSDate dateWithTimeIntervalSince1970:oldtTimeInterval];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString * timeStr = [df stringFromDate:oldDate];
    
    [df setDateFormat:@"dd"];
    NSString *nowDay = [df stringFromDate:[NSDate date]];
    NSString *lastDay = [df stringFromDate:oldDate];

    if (distanceTime < 60) {
        distanceStr = @"刚刚";
    }else if (distanceTime < 60 *60){
    
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
    }else if (distanceTime <246060 && [nowDay integerValue] == [lastDay integerValue]){
    
       distanceStr = [NSString stringWithFormat:@"今天 %@",timeStr];
    }else if (distanceTime<246060*2 && [nowDay integerValue] != [lastDay integerValue]){
    
        if ([nowDay integerValue] - [lastDay integerValue] ==1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
        }
        else{
            [df setDateFormat:@"MM-dd HH:mm"];
            distanceStr = [df stringFromDate:oldDate];
        }
    }else if (distanceTime <246060*365){
    
        [df setDateFormat:@"MM-dd HH:mm"];
        distanceStr = [df stringFromDate:oldDate];
    }else{
    
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        distanceStr = [df stringFromDate:oldDate];
    }
    return distanceStr;
}

+(NSString *)date:(NSDate *)date format:(NSString *)dateFormat{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    return [formatter stringFromDate:date];
}

+(NSString *)dateStr:(NSString *)dateStr format:(NSString *)format{
    
    if (dateStr.length <= 0) {
        return nil;
    }

    NSTimeInterval time= [dateStr doubleValue];
    //毫秒数转成秒
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time/1000];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式 @"yyyy-MM-dd HH:mm:ss"
    [dateFormatter setDateFormat:format];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    return currentDateStr;
}

+(NSDate *)timeIntervalStr:(NSString *)interval{

    NSTimeInterval intervalTime = [interval doubleValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:intervalTime];
    return date;
}

@end
