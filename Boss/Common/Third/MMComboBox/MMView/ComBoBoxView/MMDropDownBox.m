//
//  MMDropDownBox.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMDropDownBox.h"
#import "MMComboBoxHeader.h"
@interface MMDropDownBox ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrow;
@end

@implementation MMDropDownBox
- (id)initWithFrame:(CGRect)frame titleName:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        @weakify(self);
        self.title = title;
        self.isSelected = NO;
        self.userInteractionEnabled = YES;
        
        //add recognizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondToTapAction:)];
        [self addGestureRecognizer:tap];
        
        //add subView
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = DEF_SET_FONT(15);
        self.titleLabel.text = self.title;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = DEF_COLOR_333339;
        [self addSubview:self.titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.width.mas_lessThanOrEqualTo(self.width - 40);
        }];
        
        self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.1_btn_dropdown_default"]];
        [self addSubview:self.arrow];
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.mas_equalTo(self.titleLabel);
            make.left.equalTo(self.titleLabel.mas_right).with.offset(4);
            make.size.mas_equalTo(CGSizeMake(10, 6));
        }];
    }
    return self;

}

- (void)updateTitleState:(BOOL)isSelected {
    self.isSelected = isSelected;
    if (isSelected) {
        self.titleLabel.textColor = DEF_COLOR_333339;
        self.arrow.image = [UIImage imageNamed:@"1.1_btn_dropdown_selected"];
    } else{
        self.titleLabel.textColor = DEF_COLOR_333339;
        self.arrow.image = [UIImage imageNamed:@"1.1_btn_dropdown_default"];
    }
}

- (void)updateTitleContent:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)respondToTapAction:(UITapGestureRecognizer *)gesture {
    if ([self.delegate respondsToSelector:@selector(didTapDropDownBox:atIndex:)]) {
        [self.delegate didTapDropDownBox:self atIndex:self.tag];
    }
}
@end
