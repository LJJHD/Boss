//
//  NSNumber+FileSize.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "NSNumber+FileSize.h"

// 转换时除以的是 1000，而不是 1024
@implementation NSNumber (FileSize)

- (CGFloat)sizeInKByte{
    return self.floatValue / 1000;
}

- (NSString *)sizeInKByte_String{
    return [NSString stringWithFormat:@"%.2f",self.sizeInKByte];
}

- (CGFloat)sizeInMByte{
    return self.sizeInKByte / 1000;
}

- (NSString *)sizeInMByte_String{
    return [NSString stringWithFormat:@"%.2f",self.sizeInMByte];
}

- (NSString *)sizeInKByte_String_Unit{
    return [self.sizeInKByte_String stringByAppendingString:@"KB"];
}

- (NSString *)sizeInMByte_String_Unit{
    return [self.sizeInMByte_String stringByAppendingString:@"MB"];
}

@end
