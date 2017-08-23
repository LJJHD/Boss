//
//  JHServiceFactory.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHService.h"

@interface JHServiceFactory : NSObject

@property (strong, nonatomic, readonly) NSArray * allServiceNameList;

+ (instancetype)shareInstance;

/**
 实际上，identifier就是类名
 */
- (JHService<JHServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;

@end
