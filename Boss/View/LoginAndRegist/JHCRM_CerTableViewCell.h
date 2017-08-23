//
//  JHCRM_CerTableViewCell.h
//  Boss
//
//  Created by 晶汉mac on 2017/3/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCRM_LoginAndRegistModel.h"
@interface JHCRM_CerTableViewCell : UITableViewCell
@property (nonatomic,strong) JHCRM_LoginAndRegistModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
