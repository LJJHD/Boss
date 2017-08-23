//
//  JHUploadTaskInfo.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHUploadTaskInfo.h"

@interface JHUploadTaskInfo()

@property (nonatomic, copy,   readwrite) NSURL * uploadFileURL;
@property (nonatomic, assign, readwrite) NSInteger countOfBytesExpectedToSend;
@property (nonatomic, copy,   readwrite) NSNumber * countOfBytesExpectedToSend_Number;
@property (nonatomic, assign, readwrite) NSInteger uploadingId;
@property (nonatomic, assign, readwrite) UploadStatus taskUploadStatus;

@end

@implementation JHUploadTaskInfo

- (instancetype)initWithFilePath:(NSString *)path{
    return [self initWithFileURL:[NSURL fileURLWithPath:path]];
}

- (instancetype)initWithData:(NSData *)data{
    if (self = [super init]) {
        self.taskUploadStatus = Upload_In_Waiting;
        self.dataContent = data;
        self.compressRate = 1.0;
    }
    return self;
}

- (instancetype)initWithFileURL:(NSURL *)url{
    if (self = [super init]) {
        self.taskUploadStatus = Upload_In_Waiting;
        self.uploadFileURL = url;
        self.compressRate = 1.0;
    }
    return self;
}

- (NSInteger)countOfBytesExpectedToSend{
    if (_countOfBytesExpectedToSend <= 0) {
        if (isObjNotEmpty(_dataContent)) {
            _countOfBytesExpectedToSend = _dataContent.length;
        }
    }
    return _countOfBytesExpectedToSend;
}

- (NSNumber *)countOfBytesExpectedToSend_Number{
    if (_countOfBytesExpectedToSend_Number == nil ||
        _countOfBytesExpectedToSend_Number.integerValue <= 0) {
        _countOfBytesExpectedToSend_Number = @(self.countOfBytesExpectedToSend);
    }
    return _countOfBytesExpectedToSend_Number;
}

- (void)bindUploadingTaskId:(NSURLSessionDataTask *)task{
    self.uploadingId = [task taskIdentifier];
}

- (void)updateUploadStatus:(UploadStatus)newStatus{
    _taskUploadStatus = newStatus;
}

@end
