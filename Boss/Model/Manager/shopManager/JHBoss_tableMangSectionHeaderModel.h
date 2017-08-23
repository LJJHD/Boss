//
//  JHBoss_tableMangerModel.h
//  Boss
//
//  Created by jinghankeji on 2017/5/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_tableMangSectionHeaderModel : JHBaseModel
@property (nonatomic,assign) BOOL isExpand;
@property (nonatomic,strong) NSString *title;
@property (nonatomic, assign) int sectionStaffNum;//部门员工人数
@property (nonatomic,strong) NSArray *cellArray;
@end
