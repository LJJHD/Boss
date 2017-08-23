//
//  JHUploadTaskInfo.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, UploadTaskType) {
    UploadTaskType_Image,
    UploadTaskType_Record,
};

/**
 表征上传任务的状态
 */
typedef NS_ENUM(NSUInteger, UploadStatus) {
    /**等待上传*/
    Upload_In_Waiting,
    /**正在上传*/
    Upload_In_Uploading,
    /**上传成功*/
    Upload_Succeed,
    /**等待失败*/
    Upload_Failed,
};

@interface JHUploadTaskInfo : NSObject

@property (nonatomic, copy,   readonly) NSURL * uploadFileURL;
@property (nonatomic, assign, readonly) NSInteger countOfBytesExpectedToSend;
@property (nonatomic, copy,   readonly) NSNumber * countOfBytesExpectedToSend_Number;
@property (nonatomic, assign, readonly) NSInteger uploadingId;
@property (nonatomic, assign, readonly) UploadStatus taskUploadStatus;

/**
 压缩比例，默认情况下，目前只对 image 做压缩，录音未作压缩
 */
@property (nonatomic, assign) CGFloat compressRate;

@property (nonatomic, copy) NSData * dataContent;
@property (nonatomic, assign) UploadTaskType taskType;

- (instancetype)initWithFilePath:(NSString *)path;
- (instancetype)initWithFileURL:(NSURL *)url;
- (instancetype)initWithData:(NSData *)data;

- (void)updateUploadStatus:(UploadStatus)newStatus;

- (void)bindUploadingTaskId:(NSURLSessionDataTask *)task;

@end
