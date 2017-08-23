//
//  JHBoss_RechargeViewController.h
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//钱包充值页面

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PayMethodType) {

    kPayMethodType_Employees_Reward, //员工打赏
    KPayMethodType_Top_UP  // 钱包充值
};

NS_ASSUME_NONNULL_BEGIN

@interface JHBoss_RechargeViewController : UIViewController



@property (nonatomic, assign) PayMethodType payType;

//员工的ID
@property (nonatomic, copy) NSString *staffId;
@property (nonatomic, copy) NSString *staffName;
@property (nonatomic, copy) NSString *staffPictureUrl;

//商户ID
@property (nonatomic, copy) NSString *merchanId;


/**
  刷新增值服务钱包余额和短信余额
 */
@property (nonatomic, copy) void(^refreshWalletMoneyHanlder)(NSString *moneyCount,NSString *residueMessageCount);
@end

NS_ASSUME_NONNULL_END
