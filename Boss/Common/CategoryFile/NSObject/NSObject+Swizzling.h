//
//  NSObject+Swizzling.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)
+ (void)swizzlingClass:(Class)aClass fromSEL:(SEL)originalSEL toSEL:(SEL)targetSEL;
@end
