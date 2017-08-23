//
//  JHBoss_SectionManagerTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_SectionManagerTableViewCell.h"

@implementation JHBoss_SectionManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _modificationTF.returnKeyType =  UIReturnKeyDone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
