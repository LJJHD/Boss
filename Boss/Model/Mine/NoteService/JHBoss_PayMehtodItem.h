//
//  JHBoss_PayMehtodItem.h
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define CreatePayMethodItem(title, subTle, rightP, leftP, hightP,hig) [JHBoss_PayMehtodItem createPayItemWithTitle:title subTitle:subTle rightImagePath:rightP leftImagePath:leftP hightPath:hightP hightStatus:hig]

@interface JHBoss_PayMehtodItem : NSObject

@property (nullable, nonatomic, copy) NSString *title;

@property (nullable, nonatomic, copy) NSString *subTitle;

@property (nullable, nonatomic, copy) NSString *rightImagePath;

@property (nullable, nonatomic, copy) NSString *leftImagePath;

@property (nullable, nonatomic, copy) NSString *leftHightPath;

@property (nonatomic, assign, getter=isHight) BOOL hight;

+ (JHBoss_PayMehtodItem *)createPayItemWithTitle:(nullable NSString *)title
                                        subTitle:(nullable NSString *)subTitle
                                  rightImagePath:(nullable NSString *)rightPath
                                   leftImagePath:(nullable NSString *)leftPath
                                       hightPath:(nullable NSString *)hightPath
                                     hightStatus:(BOOL)hight;

@end

NS_ASSUME_NONNULL_END
