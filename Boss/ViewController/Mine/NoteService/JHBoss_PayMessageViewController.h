//
//  JHBoss_PayMessageViewController.h
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBoss_PayMessageViewController : UIViewController

//商户ID
@property (nonatomic, copy) NSString *merchanId;
/**
 刷新增值服务钱包余额和短信余额
 */
@property (nonatomic, copy) void(^refreshWalletMoneyHanlder)(NSString *moneyCount,NSString *residueMessageCount);
@end

NS_ASSUME_NONNULL_END
