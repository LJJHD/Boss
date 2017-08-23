//
//  JH_SliderCollectionViewCell.m
//  JinghanLife
//
//  Created by 晶汉mac on 2017/3/14.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JH_SliderCollectionViewCell.h"

@implementation JH_SliderCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(JH_SliderModel *)model
{
    _model = model;
    self.nameLB.text = model.titleStr;
    if (model.isSelect) {
        [self.nameLB setFont:[UIFont systemFontOfSize:17]];
        self.nameLB.textColor = DEF_COLOR_RGB(74, 144, 226);
    }else
    {
        [self.nameLB setFont:[UIFont systemFontOfSize:16]];
         self.nameLB.textColor = DEF_COLOR_RGB(160, 160, 160);
    }
}
@end

@implementation JH_SliderModel



@end
