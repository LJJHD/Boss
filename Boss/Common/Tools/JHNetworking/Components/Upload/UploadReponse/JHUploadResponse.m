//
//  JHUploadResponse.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHUploadResponse.h"

@interface JHUploadResponse ()

@property (copy, nonatomic, readwrite) NSDictionary * reponseDictionary;
@property (copy, nonatomic, readwrite) NSError * error;
@property (assign, nonatomic, readwrite) BOOL isSucceed;

@end

@implementation JHUploadResponse
- (instancetype)initWithResponseObject:(id)responseData error:(NSError *)error{
    if (self = [super init]) {
        self.error = error;
        self.isSucceed = self.error == nil;
        if (isObjNotEmpty(responseData)) {
            self.reponseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        }
    }
    return self;
}
@end
