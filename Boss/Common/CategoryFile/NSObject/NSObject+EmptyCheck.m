//
//  NSObject+EmptyCheck.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "NSObject+EmptyCheck.h"

@implementation NSObject (EmptyCheck)
bool isObjEmpty(NSObject *obj){
    return [NSObject isObjEmpty:obj];
}

bool isObjNotEmpty(NSObject *obj){
    return !isObjEmpty(obj);
}

+ (BOOL)isObjEmpty:(NSObject *)obj{
    if (obj != nil) {
        if ([obj isKindOfClass:[NSArray class]]) {
            return ((NSArray *)obj).count == 0;
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            return ((NSDictionary *)obj).allKeys.count == 0;
        }else if ([obj isKindOfClass:[NSString class]]){
            return [(NSString *)obj isEqualToString:@""];
        }
        return NO;
    }
    return YES;
}

+ (BOOL)isObjNotEmpty:(NSObject *)obj{
    return ![self isObjEmpty:obj];
}

@end
