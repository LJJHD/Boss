//
//  JHHttpRequest.h
//  JinghanLife
//
//  Created by 晶汉mac on 2017/1/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "EnumTypedefDefine.h"
typedef NS_ENUM(NSUInteger, FileType) {
    FileTypeImage = 1,
    FileTypeVideo,

};
// 请求方式
typedef NS_ENUM(NSInteger, JHRequestType) {
    JHRequestTypeGet=1,
    JHRequestTypePost,
    JHRequestTypePut,
    JHRequestTypeDelete,
    JHRequestTypeUpLoad,
    JHRequestTypeDownload
};
/**
 请求成功回调
 **/
typedef void(^RequsetSuccess)(id object);
/**
 请求失败回调
 **/
typedef void(^RequsetFail)(NSString *errorMsg , JH_HttpRequestFailState errorState);




@interface JHHttpRequest : NSObject
#pragma mark --- 简单http ---
/**  get统一请求方法
 *  @param  params  请求参数
 *  @param  path    请求路径
 *  @param  show    是否显示加载图
 *  @param  success 请求成功回调
 *  @param  fail    请求失败回调
 
 **/
+(void)getRequestWithParams:(NSDictionary*)params
                    path:(NSString*)path
           isShowLoading:(BOOL)show
                isNeedCache:(BOOL)isNeedCache
                 success:(RequsetSuccess)success
                    fail:(RequsetFail)fail
                ;


/**  Post统一请求方法
 *  @param  params  请求参数
 *  @param  path    请求路径
 *  @param  show    是否显示加载图
 *  @param  success 请求成功回调
 *  @param  fail    请求失败回调
 
 **/
+(void)postRequestWithParams:(NSDictionary*)params
                       path:(NSString*)path
              isShowLoading:(BOOL)show
                 isNeedCache:(BOOL)isNeedCache
                    success:(RequsetSuccess)success
                       fail:(RequsetFail)fail;


/** put统一请求方法
 *  @param  params  请求参数
 *  @param  path    请求路径
 *  @param  show    是否显示加载图
 *  @param  success 请求成功回调
 *  @param  fail    请求失败回调
 
 **/
+(void)putRequestWithParams:(NSDictionary *)params
                       path:(NSString *)path
              isShowLoading:(BOOL)show
                isNeedCache:(BOOL)isNeedCache
                    success:(RequsetSuccess)success
                       fail:(RequsetFail)fail;

/** put统一请求方法
 *  @param  params  请求参数
 *  @param  path    请求路径
 *  @param  show    是否显示加载图
 *  @param  success 请求成功回调
 *  @param  fail    请求失败回调
 
 **/
+(void)deleteRequestWithParams:(NSDictionary *)params
                       path:(NSString *)path
              isShowLoading:(BOOL)show
                isNeedCache:(BOOL)isNeedCache
                    success:(RequsetSuccess)success
                       fail:(RequsetFail)fail;


#pragma mark --- im ---
/**  IM get统一请求方法
 *  @param  params  请求参数
 *  @param  path    请求路径
 *  @param  show    是否显示加载图
 *  @param  success 请求成功回调
 *  @param  fail    请求失败回调
 
 **/
+(void)getIMRequestWithParams:(NSDictionary *)params
                         path:(NSString *)path
                isShowLoading:(BOOL)show
                  isNeedCache:(BOOL)isNeedCache
                      success:(RequsetSuccess)success
                         fail:(RequsetFail)fail;
/**  IM Post统一请求方法
 *  @param  params  请求参数
 *  @param  path    请求路径
 *  @param  show    是否显示加载图
 *  @param  success 请求成功回调
 *  @param  fail    请求失败回调
 
 **/
+(void)postIMRequestWithParams:(NSDictionary *)params
                          path:(NSString *)path
                 isShowLoading:(BOOL)show
                   isNeedCache:(BOOL)isNeedCache
                       success:(RequsetSuccess)success
                          fail:(RequsetFail)fail;



/**  上传多媒体请求
 *  @param  params  请求参数
 *  @param  path    请求路径
 *  @param  data    发送的data
 *  @param  type    发送多媒体的类型（可以为空，暂时没用）
 *  @param  mimeType    发送多媒体的格式fileName（image/jpeg）
 *  @param  fileName    发送多媒体的名字
 *  @param  success 请求成功回调
 *  @param  fail    请求失败回调
 
 **/
+ (void)uploadFileWithPath:(NSString *)path
                withParams:(NSDictionary*)params
                  withData:(id)data
              withFileType:(NSUInteger)type
              withmimeType:(NSString *)mimeType
              withFileName:(NSString*)fileName
                   success:(RequsetSuccess)success
                      fail:(RequsetFail)fail;

/**  上传多媒体请求
 *  @param  params  请求参数
 *  @param  path    请求路径
 *  @param  imageDataArray    发送的imagedata数组
 *  @param  type    发送多媒体的类型 （可以为空，暂时没用）
 *  @param  mimeTypeArray    发送多媒体的格式数组（image/jpeg）
 *  @param  fileNameArray    发送多媒体的名字数组
 
 
 *  @param  success 请求成功回调
 *  @param  fail    请求失败回调
 
 **///(此方法暂时废弃)
+ (void)uploadMoreFileWithPath:(NSString *)path
                    withParams:(NSDictionary*)params
                      withData:(NSArray*)imageDataArray
                  withFileType:(NSUInteger)type
                  withmimeType:(NSArray *)mimeTypeArray
                  withFileName:(NSArray*)fileNameArray
                       success:(RequsetSuccess)success
                          fail:(RequsetFail)fail;
//预留方法 参考
+ (NSURLSessionUploadTask*)uploadTaskWithImage:(id)image
                                      withPath:(NSString*)path
                                  withFileName:(NSString*)fileName
                                  withMimeType:(NSString*)mineType
                                    completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock;
@end
