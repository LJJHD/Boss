//
//  JHBoss_StaffManagerCollectionViewCell.h
//  Boss
//
//  Created by jinghankeji on 2017/5/2.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_StaffListModel.h"
@interface JHBoss_StaffManagerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *staffIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *staffNameLab;
-(void)setStaffName:(NSString *)str;
@property (nonatomic, strong)  StaffList*model;
@end
