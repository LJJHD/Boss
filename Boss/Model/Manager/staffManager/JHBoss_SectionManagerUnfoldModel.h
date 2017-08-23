//
//  JHBoss_SectionManagerUnfoldModel.h
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

@interface JHBoss_SectionManagerUnfoldModel : JHBaseModel
@property (nonatomic,assign) BOOL isExpand;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSArray *cellArray;
@end
