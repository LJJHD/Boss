//
//  JHBoss_UserInfoModel.h
//  Boss
//
//  Created by sftoday on 2017/5/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHBoss_UserInfoModel : NSObject

@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, assign) BOOL gender; // 性别
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, strong) NSNumber *authorityId;
@property (nonatomic, strong) NSNumber *age;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *phoneNumber;

@end
