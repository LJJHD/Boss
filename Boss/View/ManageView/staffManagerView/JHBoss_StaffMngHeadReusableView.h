//
//  JHBoss_StaffMngHeadReusableView.h
//  Boss
//
//  Created by jinghankeji on 2017/5/2.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_tableMangSectionHeaderModel.h"
typedef void(^CallBackBlock)(BOOL);
@interface JHBoss_StaffMngHeadReusableView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *indicateImageView;
@property (weak, nonatomic) IBOutlet UILabel *sectionNameLab;
@property (weak, nonatomic) IBOutlet UILabel *staffNumLab;
@property (weak, nonatomic) IBOutlet UIButton *tapBtn;
@property (nonatomic,strong) JHBoss_tableMangSectionHeaderModel *model;
@property (nonatomic,strong) CallBackBlock block;

@property (nonatomic , copy) void(^tapSectionBlock)(NSIndexPath *indexPath,BOOL sectionStaute);
-(void)createHeaderViewWith:(UICollectionView *)collectionView sectionIndex:(NSIndexPath *)indexpath;

@end
