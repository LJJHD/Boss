
//
//  JHHttpRequest.m
//  JinghanLife
//
//  Created by 晶汉mac on 2017/1/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHHttpRequest.h"
#import <YYCache.h>
#import "JHRequsetCaches.h"
#import "JHLoginState.h"
#import "JHBaseNavigationController.h"
#import "JHCRM_LoginViewController.h"


@implementation JHHttpRequest

+(void)getIMRequestWithParams:(NSDictionary *)params path:(NSString *)path isShowLoading:(BOOL)show  isNeedCache:(BOOL)isNeedCache success:(RequsetSuccess)success fail:(RequsetFail)fail
{
   
   
    [self requestWithParams:params path:path method:JHRequestTypeGet isShowLoading:show success:success fail:fail isNeedCache:isNeedCache isIMRequest:YES];//默认是有缓存的

}

+(void)postIMRequestWithParams:(NSDictionary *)params path:(NSString *)path isShowLoading:(BOOL)show  isNeedCache:(BOOL)isNeedCache success:(RequsetSuccess)success fail:(RequsetFail)fail
{
    [self requestWithParams:params path:path method:JHRequestTypePost isShowLoading:show success:success fail:fail isNeedCache:isNeedCache isIMRequest:YES];//默认是有缓存的

}


/**get请求**/
+(void)getRequestWithParams:(NSDictionary *)params path:(NSString *)path isShowLoading:(BOOL)show  isNeedCache:(BOOL)isNeedCache success:(RequsetSuccess)success fail:(RequsetFail)fail
{
    
    [self requestWithParams:params path:path method:JHRequestTypeGet isShowLoading:show success:success fail:fail isNeedCache:isNeedCache isIMRequest:NO];//默认是有缓存的
    
}
/**post请求**/
+(void)postRequestWithParams:(NSDictionary *)params path:(NSString *)path  isShowLoading:(BOOL)show  isNeedCache:(BOOL)isNeedCache success:(RequsetSuccess)success fail:(RequsetFail)fail 
{
    [self requestWithParams:params path:path method:JHRequestTypePost isShowLoading:show success:success fail:fail isNeedCache:isNeedCache isIMRequest:NO];//默认是有缓存的

}
/**put请求**/
+(void)putRequestWithParams:(NSDictionary *)params path:(NSString *)path isShowLoading:(BOOL)show  isNeedCache:(BOOL)isNeedCache success:(RequsetSuccess)success fail:(RequsetFail)fail
{
    [self requestWithParams:params path:path method:JHRequestTypePut isShowLoading:show success:success fail:fail isNeedCache:isNeedCache isIMRequest:NO];//默认是有缓存的
    
}
/**delete请求**/
+(void)deleteRequestWithParams:(NSDictionary *)params path:(NSString *)path  isShowLoading:(BOOL)show  isNeedCache:(BOOL)isNeedCache success:(RequsetSuccess)success fail:(RequsetFail)fail
{
    [self requestWithParams:params path:path method:JHRequestTypeDelete isShowLoading:show success:success fail:fail isNeedCache:isNeedCache isIMRequest:NO];//默认是有缓存的
    
}
+(void)requestWithParams:(NSDictionary*)params
                    path:(NSString*)path
                  method:(JHRequestType)requestType
           isShowLoading:(BOOL)show
                 success:(RequsetSuccess)success
                    fail:(RequsetFail)fail
             isNeedCache:(BOOL)isNeedCache
             isIMRequest:(BOOL)isIMRequest
{
    
    
    /**
     如果没有网络的时候取缓存数据
     **/
    if (isNeedCache)
    {
        //没网的时候去本地数据
        if ([JHReachabilityManager reachabilityForInternetConnection].currentReachabilityStatus == NotReachable)
        {
            id cacheData = [JHRequsetCaches getCachesDataWithKey:path];
            
            if (isObjNotEmpty(cacheData))
            {
                NSError *error2;
                
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:cacheData options:NSJSONReadingMutableContainers error:&error2];
                
                success(responseDictionary);
                
                return ;
            }else
            {
                
            }

        }
        
    }
    
    if (isIMRequest)
    {
        path = [NSString stringWithFormat:@"%@%@",JH_IM_IP,path];

    }else
    {
        //http://192.168.2.148:8088
        if([path rangeOfString:@"/jinghan-boss/"].location !=NSNotFound)//_roaldSearchText
        {

             path = [NSString stringWithFormat:@"%@%@",JH_HTTP_IP,path];
        }else if ([path rangeOfString:@"advert/queryAdvert.shtml"].location !=NSNotFound){
        
            path = [NSString stringWithFormat:@"%@%@",JH_AD_IP,path];
        }else if ([path rangeOfString:@"jinghan-reward"].location !=NSNotFound){
            
            path = [NSString stringWithFormat:@"%@%@",JH_Reward_IP,path];
        }else if ([path rangeOfString:@"/jinghan-payment/api/wx/"].location !=NSNotFound){
            
            path = [NSString stringWithFormat:@"%@%@",JH_PayOrder_IP,path];
        }else if ([path rangeOfString:@"/jinghan-payment/api/ali/appPay"].location !=NSNotFound){
            
            path = [NSString stringWithFormat:@"%@%@",JH_AlipayOrder_IP,path];
        }else if ([path rangeOfString:@"merchantMessageRecharge"].location !=NSNotFound){
            
            path = [NSString stringWithFormat:@"%@%@",JH_WalletOrBuyNote_IP,path];
        }
        else
        {

            path = [NSString stringWithFormat:@"%@%@",JH_Login_IP,path];
        }
        
        /*
         
         else if ([path rangeOfString:@"/information/queryInformation.shtml"].location != NSNotFound){
         
         path = [@"http://192.168.2.148:8088" stringByAppendingString:path];
         
         }
         */
        
    }
    
    AFHTTPSessionManager *manager = [self getSessionManager];
    
    manager.securityPolicy = [self securityPolicyWithPath:nil];
    //设置公共参数
    params = [JHHttpRequest setHttpBodyWith:params];
    
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    if (requestType == JHRequestTypePost)
    {
        
        [manager POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSError *error2;
             
             if (isNeedCache) {
                 //存数据
                  [JHRequsetCaches saveDataWith:responseObject withKey:path];
             }
             
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error2];
             
             success(responseDictionary);
            //判断token是否失效
             [self tokenNoWorkingWith:responseDictionary];
             DPLog(@"++++++++++++++URL:%@++++++参数:%@+++++返回数据:%@+++++++++返回提示信息:%@",path,params,responseDictionary,responseDictionary[@"msg"]);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
         {
             fail(error.description,[self requestFailure]);

             DPLog(@"++++++++++++++error%@++++%@",path,error.description);

         }];
    }else if (requestType == JHRequestTypeGet)
    {
        
        [manager GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
         {
             NSError *error2;
             
             if (isNeedCache) {
                 //存数据
                 [JHRequsetCaches saveDataWith:responseObject withKey:path];
             }
             
             NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error2];
             
             success(responseDictionary);
             
              NSLog(@"++++++++++++++URL:%@++++++参数:%@+++++返回数据:%@+++++++++返回提示信息:%@",path,params,responseDictionary,responseDictionary[@"msg"]);

             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             fail(error.description,[self requestFailure]);

             NSLog(@"++++++++++++++error%@++++%@+++++++++",path,error.description);

         }];
    }else if (requestType == JHRequestTypePut)
    {
        [manager PUT:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *error2;
            
            if (isNeedCache) {
                //存数据
                [JHRequsetCaches saveDataWith:responseObject withKey:path];
            }
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error2];
            
            success(responseDictionary);
            
            NSLog(@"++++++++++++++URL:%@++++++参数:%@+++++返回数据:%@+++++++++返回提示信息:%@",path,params,responseDictionary,responseDictionary[@"msg"]);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            fail(error.description,[self requestFailure]);

            NSLog(@"++++++++++++++error%@++++%@+++++++++",path,error.description);

        }];
    }else if (requestType == JHRequestTypeDelete)
    {
      
        [manager DELETE:path parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *error2;
            
            if (isNeedCache) {
                //存数据
                [JHRequsetCaches saveDataWith:responseObject withKey:path];
            }
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error2];
            
            success(responseDictionary);
            
            NSLog(@"++++++++++++++URL:%@++++++参数:%@+++++返回数据:%@+++++++++返回提示信息:%@",path,params,responseDictionary,responseDictionary[@"msg"]);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            fail(error.description,[self requestFailure]);
            NSLog(@"++++++++++++++error%@++++%@+++++++++",path,error.description);
            
        }];
    }


}

+ (JH_HttpRequestFailState)requestFailure
{
    if (NETWORK_CONNECTION_STAT == NotReachable) {
        
        return JH_HttpRequestFailState_NetworkBreak;
    }else{
        return JH_HttpRequestFailState_ServiceBreak;
    }
}


+ (void)uploadFileWithPath:(NSString *)path
                withParams:(NSDictionary*)params
                  withData:(id)data
              withFileType:(NSUInteger)type
              withmimeType:(NSString *)mimeType
              withFileName:(NSString*)fileName
                   success:(RequsetSuccess)success
                      fail:(RequsetFail)fail

{
 
    
    NSData *sendData = data;
    
    NSString *name = @"file";
 
    path = [NSString stringWithFormat:@"%@%@",JH_UploadPicture_IP,path];
    
    AFHTTPSessionManager *manager = [ self getSessionManager];
    
    [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        
                                    [formData appendPartWithFileData:sendData
                                                                name:name
                                                            fileName:fileName
                                                            mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        NSError *error2;
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&error2];

        success(responseDictionary);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        NSLog(@"%@",error);
    }];
    
}

+ (void)uploadMoreFileWithPath:(NSString *)path
                    withParams:(NSDictionary*)params
                      withData:(NSArray*)imageDataArray
                  withFileType:(NSUInteger)type
                  withmimeType:(NSArray *)mimeTypeArray
                  withFileName:(NSArray*)fileNameArray
                       success:(RequsetSuccess)success
                          fail:(RequsetFail)fail

{
    
    
    NSString *name = @"file";
    
    path = [NSString stringWithFormat:@"%@%@",JH_HTTP_IP,path];
    
    
    AFHTTPSessionManager *manager = [ self getSessionManager];
    
    [manager POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData){
        
        if (imageDataArray.count>0)
        {
            for (int i = 0; i<imageDataArray.count; i++) {
                [formData appendPartWithFileData:imageDataArray[i]
                                            name:name
                                        fileName:fileNameArray[i]
                                        mimeType:mimeTypeArray[i]];
            }
        }
       
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         NSError *error2;
         
         NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error2];
         
         success(responseDictionary);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         NSLog(@"%@",error);
     }];
    
}


+ (NSURLSessionUploadTask*)uploadTaskWithImage:(id)image
                                      withPath:(NSString*)path
                                  withFileName:(NSString*)fileName
                                  withMimeType:(NSString*)mineType
                                    completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock {
    // 构造 NSURLRequest
    NSError* error = NULL;
    
    path = [NSString stringWithFormat:@"%@%@",JH_HTTP_IP,path];

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        NSData* imageData =image;
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:mineType];
        
    } error:&error];
    
    // 可在此处配置验证信息
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
    } completionHandler:completionBlock];
    
    return uploadTask;
}

+ (AFHTTPSessionManager*)getSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求超时时间：
    manager.requestSerializer.timeoutInterval = 10.0f;
    //设置允许接收返回数据类型：
//     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", nil];
    //请求格式 （普通格式）
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
//
    //返回格式 data（af不给解析成json）
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //如果是https
#if JH_BASESERVICE == JH_HTTPS_SERVICE
    
    manager.securityPolicy = [self securityPolicyWithPath:@"lv"];//设置证书
    
#endif
    return manager;
  
}
+ (AFSecurityPolicy*)securityPolicyWithPath:(NSString*)cerName
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setAllowInvalidCertificates:NO];//是否允许无效证书（自建证书）
    [securityPolicy setValidatesDomainName:YES];//是否允许验证域名
    return securityPolicy;
}
//ljj 添加
+ (NSMutableDictionary*)setHttpBodyWith:(NSDictionary*)param
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary* headerDic = @{
                                @"reqId":[NSNumber numberWithLong:100],
                                @"channel":[NSNumber numberWithInteger:10],
                                @"os":@"iOS",
                                @"model":[[UIDevice currentDevice] systemVersion],
                                @"appVer": version ,
                                @"lng":[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"] ? [[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"] : @(0),
                                @"lat":[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"] ? [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"] : @(0),
                                @"signType":@"",
                                @"sign":@"",
                                @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"token"] : @"cd9407cce9e94dbdb6d3cccf209a6524",
                                };
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:headerDic];
    [dic setObject:param forKey:@"param"];
//    [dic[@"param"] setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"merchantId"] forKey:@"merchantId"];
    return dic;
}

//ljj 添加 判断token是否有效
+ (void)tokenNoWorkingWith:(id)object{
    
    if ([object[@"code"] integerValue] == 5500) {
       
        [JHLoginState setLoginOuted];
        
        UIViewController *vc;
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
            
        vc = window.rootViewController;
        
        JHCRM_LoginViewController* rootVc = [[JHCRM_LoginViewController alloc] init];
        
        JHBaseNavigationController *nav= [[JHBaseNavigationController alloc]initWithRootViewController:rootVc];
        
        [vc presentViewController:nav animated:YES completion:nil];
        
    }
}
@end
