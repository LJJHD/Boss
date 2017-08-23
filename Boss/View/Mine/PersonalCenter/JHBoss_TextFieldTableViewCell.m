//
//  JHBoss_TextFieldTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_TextFieldTableViewCell.h"

@interface JHBoss_TextFieldTableViewCell ()

@end


@implementation JHBoss_TextFieldTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

//设置UI
-(void)setUI
{
    @weakify(self);
    
    _inputTF = [[UITextField alloc] init];
    _inputTF.font = DEF_SET_FONT(15);
    _inputTF.placeholder = @"请输入名称";
    _inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.inputTF];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(25);
        make.centerY.equalTo(self);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(20);
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _inputTF.text = title;
}

@end
