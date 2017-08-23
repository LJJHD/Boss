//
//  JHBoss_DishDetailTableViewCell.h
//  Boss
//
//  Created by sftoday on 2017/5/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_DishDetailModel.h"

typedef NS_ENUM(NSUInteger,money_EnterIntoType) {

    JHBoss_NoteService,//钱包相关界面进入
};

@interface JHBoss_DishDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) JHBoss_DishDetailModel *model;
@property (nonatomic, assign) money_EnterIntoType enterIntoType;//进入类型
@property (nonatomic, copy)   NSString *titleStr;
@property (nonatomic, copy)   NSString *money;

@end
