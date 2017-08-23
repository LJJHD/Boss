//
//  JHBoss_staffGroupViewController.h
//  Boss
//
//  Created by jinghankeji on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_StaffListModel.h"
@interface JHBoss_staffGroupViewController : UIViewController
@property (nonatomic, strong) StaffList *staffInfo;
@property (nonatomic, copy)  NSString *sectionName;//员工所在分组名
@property (nonatomic, copy)  NSString *sectionId;//员工所在分组ID

@property (nonatomic, copy) NSString * currentSelectShop;//当前选中的店铺
@property (nonatomic, copy) void(^modificationSectionBlock)();
@end
