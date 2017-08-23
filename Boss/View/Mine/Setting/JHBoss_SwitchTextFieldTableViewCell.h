//
//  JHBoss_SwitchTextFieldTableViewCell.h
//  Boss
//
//  Created by sftoday on 2017/5/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TextFieldEndEditBlock)(NSString *text);

@interface JHBoss_SwitchTextFieldTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descTitle;
@property (nonatomic, assign) BOOL showTipBtn;
@property (nonatomic, assign) BOOL enableTextField;

@property (nonatomic, strong) UITextField *descTF;
@property (nonatomic, strong) UISwitch *switchSW;

@property (nonatomic, copy) TextFieldEndEditBlock textFieldEndEditBlock;

@end
