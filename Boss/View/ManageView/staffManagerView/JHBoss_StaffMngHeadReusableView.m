//
//  JHBoss_StaffMngHeadReusableView.m
//  Boss
//
//  Created by jinghankeji on 2017/5/2.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffMngHeadReusableView.h"

@interface JHBoss_StaffMngHeadReusableView ()
@property (nonatomic, strong) NSIndexPath *indexpath;
@property (nonatomic, assign) BOOL sectionStaute;
@end

@implementation JHBoss_StaffMngHeadReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _sectionStaute = NO;
}

-(void)createHeaderViewWith:(UICollectionView *)collectionView sectionIndex:(NSIndexPath *)indexpath{

    _indexpath = indexpath;
//    static NSString *reuse = @"JHBoss_StaffMngHeadReusableView";
//    JHBoss_StaffMngHeadReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuse forIndexPath:indexpath];
//    
//    if (!headView) {
//        
//        headView = [[[NSBundle mainBundle]loadNibNamed:@"JHBoss_StaffMngHeadReusableView" owner:self options:nil]objectAtIndex:0];
//    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(controlCell)];
    [self addGestureRecognizer:tap];
    

}

-(void)controlCell{
    
    
    if (self.tapSectionBlock) {
        self.tapSectionBlock(_indexpath,!_sectionStaute);
    }
    
    
}

/*
 1、通过懒加载，设置“箭头”的方向
 2、通过头视图SectionView的点击，改变“箭头”的方向
 3、通过点击SectionView，回调block进行section刷新
 */
- (void)setModel:(JHBoss_tableMangSectionHeaderModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.sectionNameLab.text = model.title;
    self.staffNumLab.text = [NSString stringWithFormat:@"%d",model.sectionStaffNum];
//    if (model.cellArray != nil && model.cellArray != [NSNull class] && model.cellArray != NULL) {
//        
//        self.staffNumLab.text = [NSString stringWithFormat:@"%lu",(unsigned long)model.cellArray.count - 1];
//    }else{
//    
//         self.staffNumLab.text = @"0";
//    }
   
    
    if (model.isExpand) {       //展开
        self.indicateImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    }else{
        self.indicateImageView.transform = CGAffineTransformIdentity;
    }
}
- (IBAction)btnTap:(UIButton *)sender {
    
    self.model.isExpand = ! self.model.isExpand;
    if (self.model.isExpand) {
        
        self.indicateImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else{
        
        self.indicateImageView.transform = CGAffineTransformIdentity;
    }
    if (self.block) {
        self.block(self.model.isExpand);
    }

    
}




@end
