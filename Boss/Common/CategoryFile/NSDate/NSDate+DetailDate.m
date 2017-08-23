//
//  NSDate+DetailDate.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "NSDate+DetailDate.h"
#import <objc/runtime.h>
@interface NSDate()

@property (strong, nonatomic) NSDateFormatter * formatter;

@end

static const void *  kFormatterKey = &kFormatterKey;

@implementation NSDate (DetailDate)
- (NSString *)transformDateFromFormatterString:(NSString *)formatter{
    NSAssert(isObjNotEmpty(formatter), @"not a valid formatter");
    [self.formatter setDateFormat:formatter];
    return [self.formatter stringFromDate:self];
}

#pragma mark - setter / getter

- (int)year{
    return [[self transformDateFromFormatterString:@"YYYY"] intValue];
}

- (int)month{
    return [[self transformDateFromFormatterString:@"MM"]intValue];
}

- (int)day{
    return [[self transformDateFromFormatterString:@"dd"]intValue];
}

- (int)hour{
    return [[self transformDateFromFormatterString:@"hh"]intValue];
}

- (int)minute{
    return [[self transformDateFromFormatterString:@"mm"]intValue];
}

- (int)second{
    return [[self transformDateFromFormatterString:@"ss"]intValue];
}

- (NSDateFormatter *)formatter{
    NSDateFormatter * formatter = objc_getAssociatedObject(self, kFormatterKey);
    if (isObjEmpty(formatter)) {
        formatter = [[NSDateFormatter alloc]init];
        self.formatter = formatter;
    }
    return formatter;
}

- (void)setFormatter:(NSDateFormatter *)formatter{
    objc_setAssociatedObject(self, kFormatterKey, formatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
