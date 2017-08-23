//
//  NSNumber+FileSize.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

// 一般情况下，文件夹的 size 取自 fileManager，而且返回值都是以 Byte 为单位的
// 所有的size string 保留两位小数
@interface NSNumber (FileSize)

@property (assign, nonatomic, readonly) CGFloat sizeInKByte;
@property (copy, nonatomic, readonly) NSString *sizeInKByte_String;
@property (copy, nonatomic, readonly) NSString *sizeInKByte_String_Unit;

@property (assign, nonatomic, readonly) CGFloat sizeInMByte;
@property (copy, nonatomic, readonly) NSString *sizeInMByte_String;
@property (copy, nonatomic, readonly) NSString *sizeInMByte_String_Unit;

@end
