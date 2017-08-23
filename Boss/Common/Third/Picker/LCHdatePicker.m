//
//  LCHdatePicker.m
//  LBS_ store
//
//  Created by 李聪会 on 16/5/5.
//  Copyright © 2016年 BeidouLife. All rights reserved.
//

#import "LCHdatePicker.h"
#import "AppDelegate.h"

@interface LCHdatePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation LCHdatePicker
{
    CGRect rect;
    UIView *_upView;
    
    //pick view
    UIPickerView *_pickerView;
    NSMutableArray *yearArray;
    NSMutableArray *monthArray;
    NSInteger currentYear;
    NSInteger currentMonth;
    NSString *restr;
    
    NSString *selectedYear;
    NSString *selectecMonth;
}


//默认时分秒选择
- (id)init{
    if (self = [super init]) {
        self.dataType = 1;
        self.dateFormatterStr = @"yyyy-MM-dd HH:mm";
        [self creatView];
    }
    return self;
}

//可以动态改变的 自己设置时间样式  和返回格式
-(id)initWithType:(NSInteger)timeType withTimeFormatter:(NSString*)timeFormatter{
    if (self = [super init]) {
        self.dataType = timeType;
        self.dateFormatterStr =timeFormatter;
        [self creatView];
    }
    return self;
}

- (void)creatView{
    self.frame = CGRectMake(0, DEF_HEIGHT, DEF_WIDTH, 216);
    self.backgroundColor = [UIColor whiteColor];
   rect = self.frame;
    
    float  height = 40;
    float  width  = 60;
    _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, height+10)];
    _upView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_upView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRGBValue_Hex:0xf0f0f0];
    view.frame = CGRectMake(0, _upView.maxY, DEF_WIDTH, 0.5);
    [_upView addSubview:view];
    
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRGBValue_Hex:0x333333] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setFrame:CGRectMake(0, 2, width, height)];
    [_upView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setFrame:CGRectMake(self.width-width,2, width, height)];
    [sureBtn setTitleColor:[UIColor colorWithRGBValue_Hex:0x333333] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_upView addSubview:sureBtn];
    
    [sureBtn addTarget:self action:@selector(sureBntClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), 0, self.width-2*width, height+4)];
    self.titleLabel.text = @"请选择时间";
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor colorWithRGBValue_Hex:0x333333];
    self.titleLabel.textAlignment =  NSTextAlignmentCenter ;
    [_upView addSubview:self.titleLabel];
    
    
    self.BgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH, DEF_HEIGHT)];
    self.BgView.backgroundColor  =[UIColor blackColor];
    self.BgView.alpha = 0.3;
    self.BgView.hidden = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPickView:)];
    gestureRecognizer.numberOfTapsRequired =1;
    gestureRecognizer.numberOfTouchesRequired = 1;
    [self.BgView addGestureRecognizer:gestureRecognizer];
    
    
    if (self.dataType == DatePickerModeYearAndMoth) {
        
        [self createPickView];
    }else{
    
        [self createPickDateView];
    }
    
}

//系统自带的pickdateView
- (void)createPickDateView{


    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.frame = CGRectMake(0, CGRectGetMaxY(_upView.frame), DEF_WIDTH, 216);
    self.datePicker.minuteInterval = 1;
    // 设置时区
    [self.datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"+0800"]];
    // 设置显示最小时间
//    NSDate *minDate = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    //    [self.datePicker setMinimumDate:[NSDate date]];
    // 设置显示最大时间（此处为当前时间）
    NSDate *maxDate = [NSDate date];
    [self.datePicker setMaximumDate:maxDate];
    // 设置当前显示时间（此处为当前时间）
    [self.datePicker setDate:[NSDate date] animated:YES];
    // 设置UIDatePicker的显示模式
    switch (self.dataType) {
        case 1:
            [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
            break;
        case 2:
            [self.datePicker setDatePickerMode:UIDatePickerModeDate];
            break;
        case 3:
            [self.datePicker setDatePickerMode:UIDatePickerModeTime];
            break;
        case 4:
            [self.datePicker setDatePickerMode:UIDatePickerModeCountDownTimer];
            break;
            
        default:
            break;
    }
    // 当值发生改变的时候调用的方法
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (self.dataType==2) {
        self.titleLabel.text = [self string:@"yyyy年MM月dd日" date:self.datePicker.date];
        
    }else
    {
        self.titleLabel.text = [self string:@"yyyy年" date:self.datePicker.date];
        
    }
    
    [self addSubview:self.datePicker];
    

}


//只有年月的PickView
-(void)createPickView{

    //pickview 配置参数
    [self setPickViewParm];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_upView.frame), DEF_WIDTH, 216)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor colorWithRed:240.0/255 green:243.0/255 blue:250.0/255 alpha:1];
    
    //设置pickerView默认选中当前时间
    [pickerView selectRow:[selectedYear integerValue] - 2015 inComponent:0 animated:YES];
    [pickerView selectRow:[selectecMonth integerValue] - 1 inComponent:1 animated:YES];
    _pickerView = pickerView;
    [self addSubview:_pickerView];



}

//pickview 配置参数
-(void)setPickViewParm{

    //获取当前时间 （时间格式支持自定义）
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM"];//自定义时间格式
    NSString *currentDateStr = [formatter stringFromDate:[NSDate date]];
    //拆分年月成数组
    NSArray *dateArray = [currentDateStr componentsSeparatedByString:@"-"];
    if (dateArray.count == 2) {//年 月
        currentYear = [[dateArray firstObject]integerValue];
        currentMonth =  [dateArray[1] integerValue];
    }
    selectedYear = [NSString stringWithFormat:@"%ld",(long)currentYear];
    selectecMonth = [NSString stringWithFormat:@"%ld",(long)currentMonth];
    
    //初始化年数据源数组
    yearArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 2017; i <= currentYear ; i++) {
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",i];
        [yearArray addObject:yearStr];
    }
    
    //初始化月数据源数组
    monthArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 1 ; i <= 12; i++) {
        NSString *monthStr = [NSString stringWithFormat:@"%ld月",i];
        [monthArray addObject:monthStr];
    }
}


- (void)datePickerValueChanged:(id)sender{
    
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate *date = control.date;
    self.datePicker.date = date;
    if (self.dataType==2) {
        self.titleLabel.text = [self string:@"yyyy年MM月dd日" date:self.datePicker.date];
        
    }else
    {
        self.titleLabel.text = [self string:@"yyyy年" date:self.datePicker.date];
        
    }
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return yearArray.count;
    }
    else {
        return monthArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return yearArray[row];
    } else {
        return monthArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSCharacterSet* nonDigits =[[NSCharacterSet decimalDigitCharacterSet] invertedSet];
   
   
    
    if (component == 0) {
        selectedYear = [yearArray[row] stringByTrimmingCharactersInSet:nonDigits];
       
        
    } else {
        
        selectecMonth = [monthArray[row] stringByTrimmingCharactersInSet:nonDigits];
    }
}


#pragma mark------视图消失----------
- (void)dismissPickView:(id*)sender
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.BgView.hidden = YES;
        self.frame = CGRectMake(0, rect.origin.y, DEF_WIDTH, 216+50);
        [self removeFromSuperview];
        [self.BgView removeFromSuperview];
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark------清除----------

- (void)clearBtnClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(datePicker:withTimeString:withTimeDate:)]) {
        
         NSString *currentDateStr;
        if (_dataType == DatePickerModeYearAndMoth) {
            
            currentDateStr = [NSString stringWithFormat:@"%@年%@月",selectedYear,selectecMonth];
            
            if ([self.delegate respondsToSelector:@selector(PickView:withTimeString:withTimeDate:)]) {
                
                [self.delegate PickView:self withTimeString:currentDateStr
                           withTimeDate:[self string:_dateFormatterStr dateStr:[currentDateStr stringByAppendingString:@"1日"]]];
                
              
                
            }
            
        }else{
        
        
            currentDateStr = [self string:self.dateFormatterStr date:self.datePicker.date];
            
            if ([self.delegate respondsToSelector:@selector(datePicker:withTimeString:withTimeDate:)]) {
                
                [self.delegate datePicker:self.datePicker withTimeString:currentDateStr withTimeDate:[self correctDate:self.datePicker.date]];
                
                [self dismissPickView:nil];
                
            }
        
        }
        
//        [self.delegate datePicker:self.datePicker withTimeString:@"" withTimeDate:self.datePicker.date];
         [self dismissPickView:nil];
    }
    
    
}

#pragma mark------确定按钮方法----------
- (void)sureBntClick:(UIButton*)sureBtn
{
   
    NSString *currentDateStr;
   
    if (_dataType == DatePickerModeYearAndMoth){
        
       
        currentDateStr = [NSString stringWithFormat:@"%@年%@月",selectedYear,selectecMonth];
        
        if ([self.delegate respondsToSelector:@selector(PickView:withTimeString:withTimeDate:)]) {
            
            [self.delegate PickView:self withTimeString:currentDateStr
                       withTimeDate:[self string:_dateFormatterStr dateStr:[currentDateStr stringByAppendingString:@"1日"]]];
            
            [self dismissPickView:nil];
            
        }
        
    }else{
    
        currentDateStr = [self string:self.dateFormatterStr date:self.datePicker.date];
        
        if ([self.delegate respondsToSelector:@selector(datePicker:withTimeString:withTimeDate:)]) {
            
            [self.delegate datePicker:self.datePicker withTimeString:currentDateStr withTimeDate:[self correctDate:self.datePicker.date]];
            
            [self dismissPickView:nil];
            
        }
    
    }
}


- (NSString*)string:(NSString*)framt date:(NSDate*)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:framt];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    //输出格式为：2010-10-27 10:22:13
    return currentDateStr;
}

- (NSDate *)string:(NSString *)framt dateStr:(NSString *)dateStr{

    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:framt];
    
     NSDate *date = [dateFormatter dateFromString:dateStr];
    
     date = [self correctDate:date];
    
    return date;

}

//处理时间差 [NSDate date] 获取的是GMT时间，与本地时间有时间差

- (NSDate *)correctDate:(NSDate *)date{

    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
    NSInteger interval = [localTimeZone secondsFromGMTForDate: date];
    
    date = [date  dateByAddingTimeInterval: interval];
    
    return date;
}



#pragma mark------视图出现----------
- (void)showInView
{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [app.window addSubview:self.BgView];
        [app.window addSubview:self];
        self.BgView.hidden = NO;
        
        self.frame = CGRectMake(0, rect.origin.y-216-50, DEF_WIDTH, 216+50);
        //self.BgView.frame =CGRectMake(0, 0, 375, 667);
        
    } completion:^(BOOL finished) {
        
    }];
}

@end
