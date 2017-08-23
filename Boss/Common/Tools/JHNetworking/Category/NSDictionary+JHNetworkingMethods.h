//
//  NSDictionary+JHNetworkingMethods.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JHNetworkingMethods)

@property (copy, nonatomic, readonly) NSString *JH_jsonString;
- (NSString *)JH_urlParamsStringSignature:(BOOL)isForSignature;
- (NSArray *)JH_transformedUrlParamsArraySignature:(BOOL)isForSignature;

@end
