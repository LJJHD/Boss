//
//  JHBoss_DishCommentModel.h
//  Boss
//
//  Created by sftoday on 2017/5/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHBoss_DishCommentModel : NSObject

@property (nonatomic, copy) NSString *commenterId;
@property (nonatomic, strong) NSNumber *Id;
@property (nonatomic, copy) NSString *content; // 评价内容
@property (nonatomic, copy) NSString *commenter; // 评价人
@property (nonatomic, strong) NSNumber *time; // 发布时间时间戳

@end
