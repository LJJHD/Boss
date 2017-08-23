//
//  JHBoss_AppreciationServiceViewController.h
//  Boss
//
//  Created by jinghankeji on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//  增值服务

#import <UIKit/UIKit.h>
@interface JHBoss_AppreciationServiceViewController : UIViewController
//商户ID
@property (nonatomic, copy) NSString *merchanId;
//剩余短息条数
@property (nullable, nonatomic, copy) NSString * residueMessageCount;
@property (nullable, nonatomic, copy) NSString *moneyCount;
/**
 刷新增值服务钱包余额和短信余额
 */
@property (nonatomic, copy) void(^refreshWalletMoneyHanlder)();
@end
