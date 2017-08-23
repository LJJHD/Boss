//
//  JHBoss_ClassifyManagerTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/5/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ClassifyManagerTableViewCell.h"

@interface JHBoss_ClassifyManagerTableViewCell ()
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@end

@implementation JHBoss_ClassifyManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



-(void)restClassificationModel:(JHBoss_RestClassification *)restClassificationModel indexPath:(NSIndexPath *)indexPath{
    _currentIndexPath = indexPath;
    
    _sectionNamLab.text = DEF_OBJECT_TO_STIRNG(restClassificationModel.name);
    _textTF.text = DEF_OBJECT_TO_STIRNG(restClassificationModel.name);

}

- (IBAction)deletSection:(UIButton *)sender {
    
    if (self.deletBlock) {
        self.deletBlock(_currentIndexPath);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
