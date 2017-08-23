//
//  JHBoss_PayCountTableViewCell.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PayCountTableViewCell.h"

#define kCols  3
#define kRow   3

@interface JHBoss_PayCountTableViewCell ()

@end

@implementation JHBoss_PayCountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    }
    
    return self;
}



//回调信息
- (void)clickPayCountButton:(UIButton *)btn {
    
    for (UIButton *tmpBtn in self.contentView.subviews) {
        
        tmpBtn.selected = NO;
        
        [self changeColorWithBtn:tmpBtn];
    }
    
    btn.selected = YES;
    
    [self changeColorWithBtn:btn];
    
    //获取支付金额
    CGFloat payCount = [[[btn.currentTitle componentsSeparatedByString:@" "] lastObject] floatValue];
    
    if (self.payCountBlock) {
        self.payCountBlock(payCount,btn.tag);
    }
}

- (void)changeColorWithBtn:(UIButton *)btn {
    
    if (btn.selected) {
        btn.layer.borderColor = [UIColor colorWithRGBValue:205 g:162 b:101].CGColor;
    } else {
        btn.layer.borderColor = [UIColor colorWithRGBValue:215 g:215 b:215].CGColor;
    }
}

#pragma mark - Public Method
- (void)showPayCountWithDataSource:(NSMutableArray *)payArray {

    for (NSInteger i = 0; i < payArray.count; i++) {
        
        UIButton *btn         = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderWidth = 1;
        
        btn.tag = i+1;
        
        [btn setTitleColor:[UIColor colorWithRGBValue:215 g:215 b:215] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRGBValue:205 g:162 b:101] forState:UIControlStateSelected];
        
        [btn addTarget:self
                action:@selector(clickPayCountButton:)
      forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@38);
            make.width.equalTo(self.contentView).multipliedBy(0.25);
            make.top.mas_equalTo(i/kRow * ((self.contentView.height*0.4) + 30) + 20);
            make.left.equalTo(@(i%kCols * ((self.contentView.width*0.3) + (DEF_DEVICE_Iphone5?(DEF_WIDTH/30):DEF_DEVICE_Iphone6?(DEF_WIDTH/13):(DEF_WIDTH/10))) + 15));
        }];
        
        [btn setTitle:payArray[i] forState:UIControlStateNormal];
        
        if (i == 0) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
        
        [self changeColorWithBtn:btn];
    }
    
}

#pragma mark - Getter

@end
