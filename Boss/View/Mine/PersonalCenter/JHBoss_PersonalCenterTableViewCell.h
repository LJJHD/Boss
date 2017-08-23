//
//  JHBoss_PersonalCenterTableViewCell.h
//  Boss
//
//  Created by sftoday on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TipBlock)(UIButton *btn);

@interface JHBoss_PersonalCenterTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descTitle;
@property (nonatomic, strong) UIColor *descColor;

@property (nonatomic, copy) TipBlock tipBlock;

@property (nonatomic, assign) BOOL showTipBtn;
@property (nonatomic, assign) BOOL showIndicate;

@end
