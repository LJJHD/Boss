//
//  NSObject+Swizzling.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>
@implementation NSObject (Swizzling)
+(void)swizzlingClass:(Class)aClass fromSEL:(SEL)originalSEL toSEL:(SEL)targetSEL{
    Method origMethod = class_getInstanceMethod(aClass, originalSEL);
    Method overrideMethod= class_getInstanceMethod(aClass, targetSEL);
    
    //运行时函数class_addMethod 如果发现方法已经存在，会失败返回，也可以用来做检查用:
    if(class_addMethod(aClass, originalSEL, method_getImplementation(overrideMethod),method_getTypeEncoding(overrideMethod))){
        //如果添加成功(在父类中重写的方法)，再把目标类中的方法替换为旧有的实现:
        class_replaceMethod(aClass,targetSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else{
        //addMethod会让目标类的方法指向新的实现，使用replaceMethod再将新的方法指向原先的实现，这样就完成了交换操作。
        method_exchangeImplementations(origMethod,overrideMethod);
    }
}
@end
