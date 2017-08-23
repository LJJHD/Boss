//
//  NSFileManager+JHExtension.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (JHExtension)


/**
 在指定路径上创建文件夹 —— [self createDirectoryAtPath:directoryPath removeExistFile:YES];
 */
+ (BOOL)createDirectoryAtPath:(NSString *)directoryPath;

/**
 在指定路径上创建文件夹,如果该路径上已经存在一个文件夹，直接返回 yes，如果存在的是文件，通过 bool 值判断是将其移除，还是保留
 */
+ (BOOL)createDirectoryAtPath:(NSString *)directoryPath removeExistFile:(BOOL)shouldRemoveExistFile;

+ (BOOL)createDirectoryAtCache:(NSString *)directoryName;

+ (BOOL)createFileAtPath:(NSString *)filePath;

/**
 指定路径下是否已经存在文件
 */
+ (BOOL)fileExistAtPath:(NSString *)filePath;

/**
 指定路径下是否已经存在一个文件夹
 */
+ (BOOL)directoryExistAtPath:(NSString *)directoryPath;

/**
 便利方法，通过这个方法可以在 cache 文件夹下创建文件
 方法中会默认将文件路径定位到 cache 文件夹这一级

 @param filePath 文件路径，在 cache 文件夹下更细致的文件路径
 @return 文件全路径
 */
+ (NSString *)createFilePathInCacheWithFilePath:(NSString *)filePath;

/**
 便利方法，通过这个方法可以在 cache 文件夹下创建文件夹
 方法中会默认将文件路径定位到 cache 文件夹这一级
 @param directoryPath 文件夹路径，在 cache 文件夹下更细致的文件夹路径
 @return 文件夹全路径
 */
+ (NSString *)createDirectoryPathInCacheWithDiretoryPath:(NSString *)directoryPath;

+ (NSNumber *)fileSizeAtFilePath:(NSString *)filePath;

+ (NSNumber *)fileSizeAtFileURL:(NSURL *)fileURL;

@end
