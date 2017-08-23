//
//  JHBoss_UploadFileModel.h
//  Boss
//
//  Created by sftoday on 2017/5/23.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHBoss_UploadFileModel : NSObject

@property (nonatomic, copy) NSString *fileContentType; // 文件类型 image/jpeg
@property (nonatomic, strong) NSNumber *fileSize; // 文件大小
@property (nonatomic, copy) NSString *filename; // 文件名 abc.jpg
@property (nonatomic, copy) NSString *fullFilename; // 完整文件路径
@property (nonatomic, copy) NSString *originalFilename; // 原始文件名
@property (nonatomic, copy) NSString *serverFilename; // 保存的文件名

@end
