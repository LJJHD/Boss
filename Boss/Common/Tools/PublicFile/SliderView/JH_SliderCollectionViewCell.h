//
//  JH_SliderCollectionViewCell.h
//  JinghanLife
//
//  Created by 晶汉mac on 2017/3/14.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JH_SliderModel;
@interface JH_SliderCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (nonatomic,strong) JH_SliderModel *model;
@end

@interface JH_SliderModel : NSObject

@property (strong, nonatomic) NSString *titleStr;

@property (assign, nonatomic) BOOL      isSelect;

@end
