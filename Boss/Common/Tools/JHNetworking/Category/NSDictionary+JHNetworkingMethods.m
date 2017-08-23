//
//  NSDictionary+JHNetworkingMethods.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "NSDictionary+JHNetworkingMethods.h"
#import "NSArray+JHNetworkingMethod.h"

@implementation NSDictionary (JHNetworkingMethods)

- (NSString *)JH_urlParamsStringSignature:(BOOL)isForSignature{
    NSArray *sortedArray = [self JH_transformedUrlParamsArraySignature:isForSignature];
    return sortedArray.JH_paramString;
}

- (NSString *)JH_jsonString{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSArray *)JH_transformedUrlParamsArraySignature:(BOOL)isForSignature{
    NSMutableArray *result = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            obj = [NSString stringWithFormat:@"%@",obj];
        }
        if (!isForSignature) {
            obj = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,  (CFStringRef)obj,  NULL,  (CFStringRef)@"!*'();:@&;=+$,/?%#[]",  kCFStringEncodingUTF8));
        }
        if ([obj length] > 0) {
            [result addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
        }
    }];
    NSArray * sortedResult = [result sortedArrayUsingSelector:@selector(compare:)];
    return sortedResult;
}

@end
