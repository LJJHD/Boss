//
//  JHBoss_SectionManagerTableViewCell.h
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_SectionManagerUnfoldModel.h"
@interface JHBoss_SectionManagerTableViewCell : UITableViewCell
@property (nonatomic, strong)JHBoss_SectionManagerUnfoldModel *model;
@property (weak, nonatomic) IBOutlet UITextField *modificationTF;
@end
