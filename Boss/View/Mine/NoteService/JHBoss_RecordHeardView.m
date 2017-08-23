//
//  JHBoss_RecordHeardView.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_RecordHeardView.h"

@interface JHBoss_RecordHeardView ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *consumptionLabel;

@end

@implementation JHBoss_RecordHeardView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    
    return self;
}


//显示内容
- (void)showDetailWithDate:(NSString *)dateStr consumptionStr:(NSString *)consumption {

    self.dateLabel.text        = dateStr;
    self.consumptionLabel.text = consumption;
}

#pragma mark Private Method
- (void)createUI {
    
    [self addSubview:self.dateLabel];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
        make.width.equalTo(@20).priorityLow(250);
    }];
    
    [self addSubview:self.consumptionLabel];
    
    [self.consumptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self);
        make.centerY.equalTo(self.dateLabel);
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@20).priorityLow(250);
    }];
    
}

#pragma mark - Setter And Getter 
- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        
        _dateLabel               = [[UILabel alloc] init];
        _dateLabel.font          = [UIFont systemFontOfSize:14];
        _dateLabel.textColor     = [UIColor colorWithRGBValue:110 g:110 b:110];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _dateLabel;
}

- (UILabel *)consumptionLabel {
    
    if (!_consumptionLabel) {
        
        _consumptionLabel               = [[UILabel alloc] init];
        _consumptionLabel.font          = [UIFont systemFontOfSize:14];
        _consumptionLabel.textColor     = [UIColor colorWithRGBValue:110 g:110 b:110];
        _consumptionLabel.textAlignment = NSTextAlignmentRight;
        
    }
    
    return _consumptionLabel;
}

@end
