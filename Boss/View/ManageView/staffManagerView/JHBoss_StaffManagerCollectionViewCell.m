//
//  JHBoss_StaffManagerCollectionViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/5/2.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffManagerCollectionViewCell.h"

@interface JHBoss_StaffManagerCollectionViewCell ()


@end

@implementation JHBoss_StaffManagerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _staffIconImageView.layer.masksToBounds = YES;
    _staffIconImageView.layer.cornerRadius = 30;
}



-(void)setModel:(StaffList *)model{

//    NSString *imageUrl = JH_loadPictureIP;
//    [imageUrl stringByAppendingString:DEF_OBJECT_TO_STIRNG(model.photo)];
    [_staffIconImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:DEF_IMAGENAME(@"2.2.2_icon_zhanweitu")];

     _staffNameLab.text = model.name;
    
}

@end
