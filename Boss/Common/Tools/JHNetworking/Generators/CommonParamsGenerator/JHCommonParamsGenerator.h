//
//  JHCommonParamsGenerator.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

//可以将 请求中的常用参数 放在这个类中，集中管理
@interface JHCommonParamsGenerator : NSObject

+ (NSDictionary *)commonParamsDictionary;

@end
