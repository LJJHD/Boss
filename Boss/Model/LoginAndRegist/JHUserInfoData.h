//
//  JHUserInfoData.h
//  JinghanLife
//
//  Created by 晶汉mac on 2017/2/23.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * 用户信息存储标识
 */
#define saveUserIdentify @"saveUserIdentify"

@interface JHUserInfoData : NSObject

/**个人配置参数**/
@property (nonatomic,strong,readonly) NSString    *token;

@property (nonatomic,strong) NSString    *account;

@property (nonatomic,copy,readonly)   NSString    *createTime;

@property (nonatomic, assign) BOOL        isBoss;

//存储用户账号
-(void)saveAccount:(NSString *)account;


- (void)saveInfoWithData:(NSDictionary*)dic identify:(NSString *)identify;

- (void)getUserInfoIdentify:(NSString *)identify result:(void(^)(NSDictionary * result))resultBlock;



- (void)removeInfoIdentify:(NSString *)identify;

/**
 存储单前选择的餐厅信息

 @param restInfo 餐厅信息
 */
+(void)saveCurrentSelectRestInfo:(NSDictionary *)restInfo;

/**
 获取当前选择的餐厅信息

 @return 餐厅信息
 */
+(NSDictionary *)getCurrentSelectRestInfo;
@end
