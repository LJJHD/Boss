//
//  JHBoss_NoteServiceTableViewCell.h
//  Boss
//
//  Created by jinghankeji on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCRM_MineMainModel.h"
@interface JHBoss_NoteServiceTableViewCell : UITableViewCell
@property (nonatomic, strong) JHCRM_MineMainModel *model;//增值服务费界面进入
//剩余短息条数
@property (nullable, nonatomic, copy) NSString * residueMessageCount;
@end
