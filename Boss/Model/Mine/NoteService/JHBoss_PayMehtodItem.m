//
//  JHBoss_PayMehtodItem.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PayMehtodItem.h"

@implementation JHBoss_PayMehtodItem

+ (JHBoss_PayMehtodItem *)createPayItemWithTitle:(NSString *)title
                                        subTitle:(NSString *)subTitle
                                  rightImagePath:(NSString *)rightPath
                                   leftImagePath:(NSString *)leftPath
                                       hightPath:(NSString *)hightPath
                                     hightStatus:(BOOL)hight {

    JHBoss_PayMehtodItem *payMethodItem = [[JHBoss_PayMehtodItem alloc] init];
    
    payMethodItem.title          = title;
    payMethodItem.hight          = hight;
    payMethodItem.subTitle       = subTitle;
    payMethodItem.leftImagePath  = leftPath;
    payMethodItem.rightImagePath = rightPath;
    payMethodItem.leftHightPath  = hightPath;
    
    return payMethodItem;
}

@end
