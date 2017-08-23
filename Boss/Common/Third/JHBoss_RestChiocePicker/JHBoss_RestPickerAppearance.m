//
//  JHBoss_RestPickerAppearance.m
//  Boss
//
//  Created by jinghankeji on 2017/6/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_RestPickerAppearance.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define DATE_PICKER_HEIGHT 105.0f
#define TOOLVIEW_HEIGHT 45.0f
#define BOTTOM_HEIGHT 54.0f
#define BACK_HEIGHT TOOLVIEW_HEIGHT + 5 + DATE_PICKER_HEIGHT + 5 + BOTTOM_HEIGHT
typedef void(^finishBlock)(int index);

@interface JHBoss_RestPickerAppearance ()
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) JHBoss_pickerType PickerMode;

@property (nonatomic, copy) finishBlock finish_Block;

@property (nonatomic, strong) JHBoss_RestPicker *restPicker;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, copy)    NSArray *contentArr;//内容
@end
@implementation JHBoss_RestPickerAppearance

-(instancetype)initWithPickerType:(JHBoss_pickerType )pickerType param:(NSArray *)contentParam completeBlock:(void(^)(int index))completeBlock{

    self = [super init];
    if (self) {
        
        _PickerMode = pickerType;
        _contentArr = contentParam;
       
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _finish_Block = completeBlock;
         [self setupUI];
    }

    return self;
}


- (void)setupUI {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, BACK_HEIGHT)];
    _backView.backgroundColor = [UIColor whiteColor];
    
    if (_PickerMode == JHBoss_PickerType_Rest ) {
        
        _restPicker = [[JHBoss_RestPicker alloc]initWithPickerMode:self.PickerMode param:self.contentArr];
        
    }
    _restPicker.frame = CGRectMake(16, TOOLVIEW_HEIGHT + 5, kScreenWidth - 32, DATE_PICKER_HEIGHT);
    _restPicker.rowHeight = 34;
    
    UILabel *tipLB = [[UILabel alloc] init];
    self.titleLB = tipLB;
//    tipLB.text = @"店铺选择";
    tipLB.textAlignment = NSTextAlignmentCenter;
    tipLB.textColor = DEF_COLOR_CDA265;
    tipLB.font = DEF_SET_FONT(16);
    [tipLB sizeToFit];
    tipLB.center = CGPointMake(CGRectGetWidth(self.bounds)/2, TOOLVIEW_HEIGHT/2);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, TOOLVIEW_HEIGHT - 0.5, kScreenWidth, 0.5)];
    lineView.backgroundColor = DEF_COLOR_LINEVIEW;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 45, BACK_HEIGHT - BOTTOM_HEIGHT + 5, 90, 25)];
    btn.backgroundColor = DEF_COLOR_CDA265;
    btn.layer.cornerRadius = 12.5;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backView addSubview:tipLB];
    [self.backView addSubview:lineView];
    [self.backView addSubview:_restPicker];
    [self.backView addSubview:btn];
    [self addSubview:self.backView];
}

-(void)setTitleStr:(NSString *)titleStr{

    _titleStr = titleStr;
    self.titleLB.text = titleStr;
    [self.titleLB sizeToFit];
    self.titleLB.center = CGPointMake(CGRectGetWidth(self.bounds)/2, TOOLVIEW_HEIGHT/2);
}

//回调
- (void)done {
    if (_finish_Block) {
       
        self.finish_Block(self.restPicker.selectIndex);
        [self hide];
    }
    
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [UIView animateWithDuration:0.25 animations:^{
        _backView.frame = CGRectMake(0, kScreenHeight - (BACK_HEIGHT), kScreenWidth, BACK_HEIGHT);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    }];
}

-(void)hide {
    [UIView animateWithDuration:0.2 animations:^{
        _backView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, BACK_HEIGHT);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
