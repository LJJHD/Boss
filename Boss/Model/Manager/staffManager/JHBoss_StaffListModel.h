//
//  JHBoss_StaffListModel.h
//  Boss
//
//  Created by jinghankeji on 2017/5/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface  StaffList: JHBaseModel
@property (nonatomic , assign) NSInteger              ID;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * photo;
@end


@interface JHBoss_StaffListModel : JHBaseModel
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , strong) NSMutableArray<StaffList *>              * staffList;
@end
