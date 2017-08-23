//
//  NSNumber+TimeInterval.m
//  Boss
//
//  Created by sftoday on 2017/5/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "NSNumber+TimeInterval.h"

@implementation NSNumber (TimeInterval)

- (NSString *)stringFromTimeIntervalWithFormat:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateFormat = format;
    return [dateFormat stringFromDate:date];
}

@end
