//
//  JHBoss_ClassifyManagerTableViewCell.h
//  Boss
//
//  Created by jinghankeji on 2017/5/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_RestClassification.h"
@interface JHBoss_ClassifyManagerTableViewCell : UITableViewCell
-(void)restClassificationModel:(JHBoss_RestClassification *)restClassificationModel indexPath:(NSIndexPath *)indexPath;
@property (weak, nonatomic) IBOutlet UILabel *sectionNamLab;
@property (weak, nonatomic) IBOutlet UITextField *textTF;
@property (weak, nonatomic) IBOutlet UIButton *deletBtn;
@property (nonatomic, copy) void(^deletBlock)(NSIndexPath *indexPath);
@end
