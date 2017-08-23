//
//  NSObject+EmptyCheck.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (EmptyCheck)
bool isObjEmpty(NSObject *obj);
bool isObjNotEmpty(NSObject *obj);

+ (BOOL)isObjEmpty:(NSObject *)obj;
+ (BOOL)isObjNotEmpty:(NSObject *)obj;

@end
