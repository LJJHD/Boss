//
//  JHBoss_PayMessageView.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PayMessageView.h"

#import "JHBoss_PayMessageItem.h"

@interface JHBoss_PayMessageView ()

@property (nonatomic, strong) UILabel *moneyLbl;
@property (nonatomic, strong) UILabel *presentLbl;
@property (nonatomic, strong) UILabel *messageCountLbl;

@end

@implementation JHBoss_PayMessageView

#pragma mark - Private Method

- (instancetype)init {

    if (self = [super init]) {
        
        [self addTarget];
        
        [self createUI];
    }
    
    return self;
}
- (void)addTarget {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tapEvent:)];
    
    [self addGestureRecognizer:tap];
}

- (void)createUI {

    //信息条数
    [self addSubview:self.messageCountLbl];
    
    [self.messageCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.width.equalTo(@20).priorityLow(250);
        make.height.equalTo(self).multipliedBy(0.25);
    }];
    
    //金额
    [self addSubview:self.moneyLbl];
    
    [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20).priorityLow(250);
        make.height.equalTo(self.messageCountLbl);
        make.centerX.equalTo(self.messageCountLbl);
        make.top.equalTo(self.messageCountLbl.mas_bottom).offset(5);
    }];
    
    //赠送条数
    [self addSubview:self.presentLbl];
    
    [self.presentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self.messageCountLbl);
        make.top.equalTo(self.moneyLbl.mas_bottom).offset(5);
    }];
    
}

- (void)setPayItem:(JHBoss_PayMessageItem *)payItem {
    
    _payItem = payItem;
    
    self.moneyLbl.text        = [NSString stringWithFormat:@"售价¥%g",[payItem.sellCount floatValue]/100];
    self.presentLbl.text      = [NSString stringWithFormat:@"送%@条",payItem.residueCount];
    self.messageCountLbl.text = [NSString stringWithFormat:@"%@条",payItem.messageCount];
    
    if (payItem.select) {
        
        //选中
        self.layer.borderColor = [UIColor colorWithRGBValue:205 g:162 b:101].CGColor;
        self.layer.borderWidth = 1;
        
        self.presentLbl.backgroundColor     = [UIColor colorWithRGBValue:205 g:162 b:101];
        
        NSMutableAttributedString *mAttrStr = [[NSMutableAttributedString alloc] initWithString:self.messageCountLbl.text];
        
        [mAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGBValue:150 g:88 b:0] range:NSMakeRange(0, payItem.messageCount.length)];
        
        self.messageCountLbl.attributedText = mAttrStr;
        
    } else {
        
        //取消
        self.layer.borderColor = [UIColor colorWithRGBValue:215 g:215 b:215].CGColor;
        self.layer.borderWidth = 1;
        
        self.presentLbl.backgroundColor = [UIColor colorWithRGBValue:161 g:161 b:161];
        
        self.messageCountLbl.textColor  = [UIColor colorWithRGBValue:161 g:161 b:161];
    }
    
}

//回调事件
- (void)tapEvent:(UITapGestureRecognizer *)tap {

    if (self.messageBlock) {
        self.messageBlock(self.payItem);
    }
    
}

#pragma mark - Getter Mehtod
- (UILabel *)moneyLbl {
    
    if (!_moneyLbl) {
        _moneyLbl           = [[UILabel alloc] init];
        _moneyLbl.font      = [UIFont systemFontOfSize:15];
        _moneyLbl.textColor = [UIColor colorWithRGBValue:161 g:161 b:161];
        
    }
    
    return _moneyLbl;
}

- (UILabel *)presentLbl {

    if (!_presentLbl) {
        _presentLbl                 = [[UILabel alloc] init];
        _presentLbl.font            = [UIFont systemFontOfSize:13];
        _presentLbl.textColor       = [UIColor whiteColor];
        _presentLbl.textAlignment   = NSTextAlignmentCenter;
    }
    
    return _presentLbl;
}

- (UILabel *)messageCountLbl {
    
    if (!_messageCountLbl) {
    
        _messageCountLbl = [[UILabel alloc] init];
        _messageCountLbl.textColor       = [UIColor colorWithRGBValue:161 g:161 b:161];
    }
    
    return _messageCountLbl;
}

@end
