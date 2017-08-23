//
//  JHUploadResponse.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHUploadResponse : NSObject

@property (copy, nonatomic, readonly) NSDictionary * reponseDictionary;
@property (copy, nonatomic, readonly) NSError * error;
@property (assign, nonatomic, readonly) BOOL isSucceed;

- (instancetype)initWithResponseObject:(id)responseData error:(NSError *)error;

@end
