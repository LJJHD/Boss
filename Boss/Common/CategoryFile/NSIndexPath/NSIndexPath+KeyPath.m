//
//  NSIndexPath+KeyPath.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "NSIndexPath+KeyPath.h"

@implementation NSIndexPath (KeyPath)
- (NSString *)JHKeyPath{
    return [NSString stringWithFormat:@"%ld-%ld",(long)self.section,(long)self.row];
}
@end
