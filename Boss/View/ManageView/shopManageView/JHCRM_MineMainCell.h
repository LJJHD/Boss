//
//  JHCRM_MineMainCell.h
//  SuppliersCRM
//
//  Created by jinghan on 17/3/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCRM_MineMainModel.h"

@interface JHCRM_MineMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLable;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (nonatomic,strong) JHCRM_MineMainModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TitleLbleadingLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *InfoLbTralingLayout;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
