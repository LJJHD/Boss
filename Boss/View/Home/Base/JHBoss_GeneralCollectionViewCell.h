//
//  JHBoss_GeneralCollectionViewCell.h
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_GeneralCollectionModel.h"

@interface JHBoss_GeneralCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) JHBoss_GeneralCollectionModel *model;

@end
