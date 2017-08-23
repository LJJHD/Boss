//
//  JHBoss_SwitchTableViewCell.h
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TipBlock)(UIButton *btn);

@interface JHBoss_SwitchTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descTitle;
@property (nonatomic, assign) BOOL showTipBtn;
@property (nonatomic, copy) void(^switchHandler)(UISwitch *);
@property (nonatomic, strong) UISwitch *switchSW;
@property (nonatomic, copy) TipBlock tipBlock;

@end
