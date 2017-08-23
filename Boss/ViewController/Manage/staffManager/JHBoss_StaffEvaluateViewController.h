//
//  JHBoss_StaffEvaluateViewController.h
//  Boss
//
//  Created by jinghankeji on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_StaffDetailModel.h"

@interface JHBoss_StaffEvaluateViewController : UIViewController
@property (nonatomic, strong) JHBoss_StaffDetailModel *staffDetailModel;
@property (nonatomic, copy) NSString * currentSelectShop;//当前选中的店铺

@end
