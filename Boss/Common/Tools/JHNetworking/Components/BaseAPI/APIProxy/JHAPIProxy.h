//
//  JHAPIProxy.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHURLResponse.h"

typedef void(^JHCallback)(JHURLResponse *response);

@interface JHAPIProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(JHCallback)success fail:(JHCallback)fail;
- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(JHCallback)success fail:(JHCallback)fail;
- (NSInteger)callPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(JHCallback)success fail:(JHCallback)fail;
- (NSInteger)callDELETEWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(JHCallback)success fail:(JHCallback)fail;

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(JHCallback)success fail:(JHCallback)fail;
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
