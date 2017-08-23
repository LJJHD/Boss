//
//  NSArray+JHNetworkingMethod.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "NSArray+JHNetworkingMethod.h"

@implementation NSArray (JHNetworkingMethod)

- (NSString *)JH_paramString{
    NSMutableString *paramString =  [[NSMutableString alloc]init];
    NSArray *sortedParams = [self sortedArrayUsingSelector:@selector(compare:)];
    [sortedParams enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (paramString.length == 0) {
            [paramString appendFormat:@"%@",obj];
        }else{
            [paramString appendFormat:@"&%@",obj];
        }
    }];
    return paramString;
}

- (NSString *)JH_jsonString{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
