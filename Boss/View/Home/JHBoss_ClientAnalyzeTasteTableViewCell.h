//
//  JHBoss_ClientAnalyzeTasteTableViewCell.h
//  Boss
//
//  Created by jinghankeji on 2017/6/23.
//  Copyright © 2017年 jinghan. All rights reserved.
//顾客分析 口味和菜系分析

#import <UIKit/UIKit.h>
#import "JHBoss_WelcomeDishsModel.h"
typedef NS_ENUM(NSUInteger,ClientAnalyzeType) {

    clientAnalyzeType_styleOfCooking,//菜系分析
    ClientAnalyzeType_taste,//口味分析
};

@interface JHBoss_ClientAnalyzeTasteTableViewCell : UITableViewCell
@property (nonatomic, assign) ClientAnalyzeType   clientAnalyzeType;
@property (nonatomic, strong) JHBoss_WelcomeDishsModel *model;
@property (nonatomic, strong) NSMutableArray *welcomeDishsArr;
@end
