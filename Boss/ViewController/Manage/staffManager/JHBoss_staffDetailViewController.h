//
//  JHBoss_staffDetailViewController.h
//  Boss
//
//  Created by jinghankeji on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_StaffListModel.h"
@interface JHBoss_staffDetailViewController : UIViewController
@property (nonatomic, strong) StaffList *staffInfo;
@property (nonatomic, copy)  NSString *sectionName;
@property (nonatomic, copy)  NSString *sectionId;//员工所在分组ID

@property (nonatomic, copy) NSString * currentSelectShop;//当前选中的店铺id
@property (nonatomic, copy) void(^updateStaffListBlock)();
@end
