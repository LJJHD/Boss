//
//  JH_Menu.h
//  Boss
//
//  Created by jinghankeji on 2017/3/28.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Rect.h"
@interface JH_Menu : NSObject
+ (void)createMenuInView:(UIView *)view fromRect:(CGRect)rect textItems:(NSMutableArray *)textItemsArr;
@end
