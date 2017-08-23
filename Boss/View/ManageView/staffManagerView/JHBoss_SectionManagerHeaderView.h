//
//  JHBoss_SectionManagerHeaderView.h
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_SectionManagerUnfoldModel.h"
#import "JHBoss_RestClassification.h"
@interface JHBoss_SectionManagerHeaderView : UITableViewHeaderFooterView
@property (nonatomic, copy)void (^unfoldBlock)(BOOL,UIButton *);
@property (nonatomic, copy)void (^deletBlock)();
@property (nonatomic, strong) JHBoss_RestClassification *ClassificationModel;

@property (nonatomic, strong) JHBoss_SectionManagerUnfoldModel *model;
@end
