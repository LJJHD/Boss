//
//  JHBoss_staffDeatailHeaderView.h
//  Boss
//
//  Created by jinghankeji on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCRM_TagsView.h"
#import "JHBoss_StaffDetailModel.h"
@interface JHBoss_staffDeatailHeaderView : UIView
@property (nonatomic, copy) void(^evaluateBlock)();//评价
@property (nonatomic, copy) void(^moneyBlock)();//打赏
@property (nonatomic, copy) void(^QRcodeBlock)(UIButton *);//二维码
@property (nonatomic, strong) JHBoss_StaffDetailModel *staffDetailModel;
@end
