//
//  HCGDatePickerAppearance.m
//  HcgDatePicker-master
//
//  Created by 黄成钢 on 14/12/2016.
//  Copyright © 2016 chedaoshanqian. All rights reserved.
//

#import "HCGDatePickerAppearance.h"
#import "JHUserInfoData.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define DATE_PICKER_HEIGHT 105.0f
#define TOOLVIEW_HEIGHT 45.0f
#define BOTTOM_HEIGHT 54.0f
#define BACK_HEIGHT TOOLVIEW_HEIGHT + 5 + DATE_PICKER_HEIGHT + 5 + BOTTOM_HEIGHT

typedef void(^dateBlock)(NSArray *);

@interface HCGDatePickerAppearance ()

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) DatePickerMode dataPickerMode;

@property (nonatomic, copy) dateBlock dateBlock;

@property (nonatomic, strong) HCGDatePicker *datePicker;

@property (nonatomic, strong) NSDate *minDate;//最小日期
@property (nonatomic, strong) NSDate *maxDate;//最大日期
@property (nonatomic, strong) UILabel *titleLB;//标题
@property (nonatomic, strong) JHUserInfoData *userInfoData;
@end

@implementation HCGDatePickerAppearance

-(JHUserInfoData *)userInfoData{

    if (!_userInfoData) {
        _userInfoData = [[JHUserInfoData alloc]init];
    }
    return _userInfoData;
}

- (instancetype)initWithDatePickerMode:(DatePickerMode)dataPickerMode completeBlock:(void (^)(NSArray *time))completeBlock {
    self = [super init];
    if (self) {
        _dataPickerMode = dataPickerMode;
        [self setupUI];
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _dateBlock = completeBlock;
    }
    return self;
}

- (instancetype)initWithDatePickerMode:(DatePickerMode)dataPickerMode MinDate:(NSDate *)minDate MaxDate:(NSDate *)maxDate completeBlock:(void (^)(NSArray *time))completeBlock{
    self = [super init];
    if (self) {
        _dataPickerMode = dataPickerMode;
        
        if (minDate != nil && minDate != [NSNull class]) {
            
             _minDate = minDate;
        }else{
            
            _minDate = [NSString timeIntervalStr:self.userInfoData.createTime];
        }
        
        if (maxDate != nil && maxDate != [NSNull class]) {
            
             _maxDate = maxDate;
        }else{
        
            _maxDate = [NSDate date];
        }
        [self setupUI];
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        _dateBlock = completeBlock;
    }
    return self;
}

- (void)setupUI {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, BACK_HEIGHT)];
    _backView.backgroundColor = [UIColor whiteColor];
    
    
    if (_dataPickerMode == DatePickerOneTime || _dataPickerMode == DatePickerTwoTime) {
        
        _datePicker = [[HCGDatePicker alloc]initWithDatePickerMode:_dataPickerMode];
        
    }else if (_dataPickerMode == DatePickerYearMonthSection || _dataPickerMode == DatePickerYearMonthDaySection){
    
        _datePicker = [[HCGDatePicker alloc]initWithDatePickerMode:_dataPickerMode MinDate:_minDate MaxDate:_maxDate];
    }
    _datePicker.frame = CGRectMake(16, TOOLVIEW_HEIGHT + 5, kScreenWidth - 32, DATE_PICKER_HEIGHT);
    _datePicker.rowHeight = 34;
    
    UILabel *tipLB = [[UILabel alloc] init];
    _titleLB = tipLB;
    if (_dataPickerMode == DatePickerOneTime) {
        tipLB.text = @"推送时间";
    } else {
        tipLB.text = @"定时开启勿扰模式";
    }
    tipLB.textColor = DEF_COLOR_CDA265;
    tipLB.font = DEF_SET_FONT(16);
    tipLB.textAlignment = NSTextAlignmentCenter;
    [tipLB sizeToFit];
    tipLB.center = CGPointMake(DEF_WIDTH/2, TOOLVIEW_HEIGHT/2);
    
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
    [self.backView addSubview:_datePicker];
    [self.backView addSubview:btn];
    [self addSubview:self.backView];
}

- (void)done {
    if (_dateBlock) {
        switch (_dataPickerMode) {
            case DatePickerOneTime:
                _dateBlock(@[_datePicker.time]);
                break;
            case DatePickerTwoTime:
                _dateBlock(@[_datePicker.time, _datePicker.endTime]);
                break;
            case DatePickerYearMonthDaySection:
                _dateBlock(@[_datePicker.time, _datePicker.endTime]);
                break;
            default:
                break;
        }
        [self hide];
    }

}

- (void)show {
    
    if (self.titleStr.length > 0) {
        self.titleLB.text = self.titleStr;
    }
    
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

@end
