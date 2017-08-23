//
//  NSFileManager+JHExtension.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "NSFileManager+JHExtension.h"
#define kFileManager [NSFileManager defaultManager]

@implementation NSFileManager (JHExtension)

+ (BOOL)createDirectoryAtPath:(NSString *)directoryPath{
    return [self createDirectoryAtPath:directoryPath removeExistFile:YES];
}

+ (BOOL)createDirectoryAtPath:(NSString *)directoryPath removeExistFile:(BOOL)shouldRemoveExistFile{
    if ([self directoryExistAtPath:directoryPath]) {
        return YES;
    }else{
        if ([self fileExistAtPath:directoryPath]) {
            if (shouldRemoveExistFile) {
                [kFileManager removeItemAtPath:directoryPath error:nil];
            }else{
                return NO;
            }
        }
    }
    return [kFileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (BOOL)createDirectoryAtCache:(NSString *)directoryName{
    return [self createDirectoryAtPath:[self createDirectoryPathInCacheWithDiretoryPath:directoryName]];
}

+ (BOOL)createFileAtPath:(NSString *)filePath{
    BOOL isFile = NO;
    if ([kFileManager fileExistsAtPath:filePath isDirectory:&isFile]) {
        if (isFile == YES) {
            return YES;
        }
    }
    return [kFileManager createFileAtPath:filePath contents:nil attributes:nil];
}

+ (BOOL)fileExistAtPath:(NSString *)filePath{
    BOOL isDirectory = NO;
    if ([kFileManager fileExistsAtPath:filePath isDirectory:&isDirectory]) {//文件存在
        if (isDirectory) {//如果是文件夹的话，那么就不是文件了
            return NO;
        }
    }
    return NO;
}

+ (BOOL)directoryExistAtPath:(NSString *)directoryPath{
    BOOL isDirectory = NO;
    if ([kFileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory]) {//文件存在
        if (isDirectory) {
            return YES;
        }
    }
    return NO;
}

+ (NSString *)createFilePathInCacheWithFilePath:(NSString *)filePath{
    NSString * cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [cachePath stringByAppendingPathComponent:filePath];
}

+ (NSString *)createDirectoryPathInCacheWithDiretoryPath:(NSString *)directoryPath{
    NSString * cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [cachePath stringByAppendingPathComponent:directoryPath];
}

+ (NSNumber *)fileSizeAtFilePath:(NSString *)filePath{
    return @(((NSString *)[kFileManager attributesOfItemAtPath:filePath error:nil][NSFileSize]).integerValue);
}

+ (NSNumber *)fileSizeAtFileURL:(NSURL *)fileURL{
    return [self fileSizeAtFilePath:fileURL.absoluteString];
}



@end
