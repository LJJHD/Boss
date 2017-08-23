//
//  JHBoss_TableMangerCollectionViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/5/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_TableMangerCollectionViewCell.h"

@interface JHBoss_TableMangerCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *tableTypeImagV;
@property (weak, nonatomic) IBOutlet UILabel *peopleLab;

@property (weak, nonatomic) IBOutlet UILabel *tableNameLab;
@end

@implementation JHBoss_TableMangerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setTableModels:(TableModels *)tableModels{

    _tableModels = tableModels;
    
    if ([tableModels.state isEqualToString:@"A1"]) {
        //空闲
        _tableTypeImagV.image = DEF_IMAGENAME(@"2.1.4.2_icon_empty table");
        
    }else if ([tableModels.state isEqualToString:@"A2"]){
    //预定
       _tableTypeImagV.image = DEF_IMAGENAME(@"2.1.4.2_icon_reservation");
        
    }else if ([tableModels.state isEqualToString:@"A3"]){
    //开台未下单
        _tableTypeImagV.image = DEF_IMAGENAME(@"2.1.4.2_icon_not order");
    }else if ([tableModels.state isEqualToString:@"A4"]){
    //下单待审
        _tableTypeImagV.image = DEF_IMAGENAME(@"2.1.4.2_icon_order pending");
    }else if ([tableModels.state isEqualToString:@"A5"]){
    //已下厨
        _tableTypeImagV.image = DEF_IMAGENAME(@"2.1.4.2_icon_cook");
    }else if ([tableModels.state isEqualToString:@"A6"]){
    //厨打失败
        _tableTypeImagV.image = DEF_IMAGENAME(@"2.1.4.2_icon_cook failure");
    }else if ([tableModels.state isEqualToString:@"A7"]){
    //下厨加菜
        _tableTypeImagV.image = DEF_IMAGENAME(@"2.1.4.2_icon_cooking food");
    }else if ([tableModels.state isEqualToString:@"A8"]){
    //待付款
        _tableTypeImagV.image = DEF_IMAGENAME(@"2.1.4.2_icon_payment");
    }else if ([tableModels.state isEqualToString:@"A9"]){
    //买单待审
        _tableTypeImagV.image = DEF_IMAGENAME(@"2.1.4.2_icon_check pending");
    }else if ([tableModels.state isEqualToString:@"A10"]){
    //已买单
        _tableTypeImagV.image = DEF_IMAGENAME(@"zhifuchenggong");
    }else if ([tableModels.state isEqualToString:@"A11"]){
    //脏台
        _tableTypeImagV.image = DEF_IMAGENAME(@"2.1.4.2_icon_dirty table");
    }else if ([tableModels.state isEqualToString:@"A12"]){
    //暂时用不到
//        _tableTypeImagV.image = DEF_IMAGENAME(@"2.1.4.2_icon_dirty table");
    }
    
    _peopleLab.text = [NSString stringWithFormat:@"%ld人",tableModels.count];
    
    _tableNameLab.text = tableModels.name;
}

@end
