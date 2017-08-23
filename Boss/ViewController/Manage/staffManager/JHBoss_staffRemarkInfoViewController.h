//
//  JHBoss_staffRemarkInfoViewController.h
//  Boss
//
//  Created by jinghankeji on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_StaffDetailModel.h"
typedef NS_ENUM(NSUInteger,JHBoss_RemarkOrAddSection) {

    JHBoss_type_remark = 1,
    
    JHBoss_type_addSection
};

@interface JHBoss_staffRemarkInfoViewController : UIViewController
@property (nonatomic, assign) JHBoss_RemarkOrAddSection  enterIntoType;
@property (nonatomic, strong) JHBoss_StaffDetailModel *staffDetailModel;//员工详情
@property (nonatomic, copy) void(^addSectionBlock)();
@property (nonatomic, copy) NSString  *currentShop;//单前餐厅
@property (nonatomic, copy) void(^updateStaffDeatil)();//修改备注，刷新员工详情界面
@end
