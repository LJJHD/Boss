//
//  JHBoss_DishValuationHeaderTableViewCell.h
//  Boss
//
//  Created by sftoday on 2017/5/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_DishDetailModel.h"

@interface JHBoss_DishValuationHeaderTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *countOfValuations;
@property (nonatomic, strong) JHBoss_DishDetailModel *model;

@end
