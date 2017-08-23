//
//  FyCalendarView.m
//  FYCalendar
//
//  Created by 丰雨 on 16/3/17.
//  Copyright © 2016年 Feng. All rights reserved.
//

#import "FyCalendarView.h"

@interface FyCalendarView ()
@property (nonatomic, strong) UIButton *selectBtn;
@property (nonatomic, strong) NSMutableArray *daysArray;
@property (nonatomic, assign) CGFloat sourceHeight;
@property (nonatomic, strong) NSDate *startDate;
@end

@implementation FyCalendarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.date = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.startDate = [dateFormatter dateFromString:@"2016-07-15"];
        
        self.layer.masksToBounds = YES;
        [self setupDate];
        [self setupNextAndLastMonthOrYearView];
        [self createCalendarView];
    }
    return self;
}

- (void)setupDate {
    self.daysArray = [NSMutableArray arrayWithCapacity:42];
    for (int i = 0; i < 42; i++) {
        UIButton *button = [[UIButton alloc] init];
        [self addSubview:button];
        [_daysArray addObject:button];
        [button addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupNextAndLastMonthOrYearView {
    //上一个月
    UIButton *lastMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lastMonthBtn setImage:[UIImage imageNamed:@"1.1.7.2_btn_dropdown"] forState:UIControlStateNormal];
    [lastMonthBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    lastMonthBtn.tag = 1;
    lastMonthBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    lastMonthBtn.frame = CGRectMake(self.width*0.565,10, 34, 34);
    [self addSubview:lastMonthBtn];
    //下一个月
    UIButton *nextMonthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextMonthBtn setImage:[UIImage imageNamed:@"1.1_btn_dropdown"] forState:UIControlStateNormal];
    [nextMonthBtn addTarget:self action:@selector(nextAndLastMonth:) forControlEvents:UIControlEventTouchUpInside];
    nextMonthBtn.tag = 2;
    nextMonthBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    nextMonthBtn.frame = CGRectMake(self.width*0.935 - 34, 10, 34, 34);
    [self addSubview:nextMonthBtn];
    //上一年
    UIButton *lastYearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [lastYearBtn setImage:[UIImage imageNamed:@"1.1.7.2_btn_dropdown"] forState:UIControlStateNormal];
    [lastYearBtn addTarget:self action:@selector(nextAndLastYear:) forControlEvents:UIControlEventTouchUpInside];
    lastYearBtn.tag=33;
    lastYearBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    lastYearBtn.frame=CGRectMake(self.width*0.065,10,34,34);
    [self addSubview:lastYearBtn];
    //下一年
    UIButton *nextYearBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextYearBtn setImage:[UIImage imageNamed:@"1.1_btn_dropdown"] forState:UIControlStateNormal];
    [nextYearBtn addTarget:self action:@selector(nextAndLastYear:) forControlEvents:UIControlEventTouchUpInside];
    nextYearBtn.tag=44;
    nextYearBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    nextYearBtn.frame=CGRectMake(self.width*0.435 - 34, 10, 34, 34);
    [self addSubview:nextYearBtn];

   
}


-(void)nextAndLastYear:(UIButton*)button
{
    NSDateComponents *todayComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDateComponents *selectedComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    NSDateComponents *startComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.startDate];
    if (todayComp.year == selectedComp.year && button.tag != 33) {
        return;
    }
    if (button.tag == 33 && selectedComp.year == startComp.year) {
        return;
    }
    
    NSDateComponents *assistComp = [[NSDateComponents alloc] init];
    [assistComp setYear:button.tag == 33 ? -1 : 1];
    NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:assistComp toDate:self.date options:0];
    
    // 不够下一年
    if (todayComp.year == selectedComp.year + 1 && button.tag != 33 && todayComp.month < selectedComp.month) {
        nextMonthDate = [NSDate date];
    }
    // 不够上一年
    if (button.tag == 33 && selectedComp.year == startComp.year + 1 && selectedComp.month < startComp.month) {
        nextMonthDate = self.startDate;
    }
    
    self.date = nextMonthDate;
    
    for (int i = 0; i < 42; i++) {
        UIButton *dayButton = _daysArray[i];
        
        NSInteger daysInThisMonth = [self totaldaysInMonth:nextMonthDate];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:nextMonthDate];
        
        NSInteger day = 0;
        
        if (i % 7 == 0 || i % 7 == 6) {
            [dayButton setTitleColor:DEF_COLOR_CDA265 forState:UIControlStateNormal];
        } else {
            [dayButton setTitleColor:DEF_COLOR_333339 forState:UIControlStateNormal];
        }
        
        if (i < firstWeekday) {
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            dayButton.enabled = YES;
            [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
            dayButton.titleLabel.font = DEF_SET_FONT(15);
        }
        
        // this month
        if ([self isSameDay:nextMonthDate date2:[NSDate date]]) {
            NSInteger todayIndex = [self day:[NSDate date]] + firstWeekday - 1;
            
            if (i ==  todayIndex) {
                [dayButton setTitle:@"今日" forState:UIControlStateNormal];
                dayButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
            }else if(i <= firstWeekday + daysInThisMonth - 1 && i > todayIndex){
                // 今天之后显示灰色，不可点
                [dayButton setTitleColor:DEF_COLOR_A1A1A1 forState:UIControlStateNormal];
                dayButton.enabled = NO;
            } else {
                
            }
        }
        
        // start month
        NSDateComponents *nextComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:nextMonthDate];
        if (nextComp.year == startComp.year && nextComp.month == startComp.month) {
            NSInteger todayIndex = [self day:self.startDate] + firstWeekday - 1;
            
            if (i ==  todayIndex) {
                
            }else if(firstWeekday <= i && i < todayIndex){
                // 今天之后显示灰色，不可点
                [dayButton setTitleColor:DEF_COLOR_A1A1A1 forState:UIControlStateNormal];
                dayButton.enabled = NO;
            } else {
                
            }
        }
    }
    
    // 对选中的日期着色
    if ([[self.selectedDate substringToIndex:4] integerValue] == [self year:nextMonthDate] &&
        [[self.selectedDate substringWithRange:NSMakeRange(5, 2)] integerValue] == [self month:nextMonthDate]) {
        self.selectBtn.selected = YES;
        [self.selectBtn setBackgroundColor:self.dateColor];
    } else {
        self.selectBtn.selected = NO;
        [self.selectBtn setBackgroundColor:[UIColor clearColor]];
    }
    
    self.yearlabel.text = [NSString stringWithFormat:@"%li",[self year:nextMonthDate]];
    self.monthlabel.text = [NSString stringWithFormat:@"%li月",[self month:nextMonthDate]];

    if (button.tag==33){
        if (self.lastYearBlock) {
            self.lastYearBlock();
        }
    } else {
        if (self.nextYearBlock) {
            self.nextYearBlock();
        }
    }
    
}
- (void)nextAndLastMonth:(UIButton *)button {
    
    NSDateComponents *todayComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDateComponents *selectedComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    NSDateComponents *startComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.startDate];
    if (todayComp.year == selectedComp.year && todayComp.month == selectedComp.month && button.tag != 1) {
        return;
    }
    if (startComp.year == selectedComp.year && startComp.month == selectedComp.month && button.tag == 1) {
        return;
    }
    
    NSDateComponents *assistComp = [[NSDateComponents alloc] init];
    [assistComp setMonth:button.tag == 1 ? -1 : 1];
    
    NSDate *nextMonthDate = [[NSCalendar currentCalendar] dateByAddingComponents:assistComp toDate:self.date options:0];
    self.date = nextMonthDate;
    
    for (int i = 0; i < 42; i++) {
        UIButton *dayButton = _daysArray[i];
        
        NSInteger daysInThisMonth = [self totaldaysInMonth:nextMonthDate];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:nextMonthDate];
        
        NSInteger day = 0;
        
        if (i % 7 == 0 || i % 7 == 6) {
            [dayButton setTitleColor:DEF_COLOR_CDA265 forState:UIControlStateNormal];
        } else {
            [dayButton setTitleColor:DEF_COLOR_333339 forState:UIControlStateNormal];
        }
        
        if (i < firstWeekday) {
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            dayButton.enabled = YES;
            [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
            dayButton.titleLabel.font = DEF_SET_FONT(15);
        }
        
        // this month
        if ([self isSameDay:nextMonthDate date2:[NSDate date]]) {
            NSInteger todayIndex = [self day:[NSDate date]] + firstWeekday - 1;
            
            if (i ==  todayIndex) {
                [dayButton setTitle:@"今日" forState:UIControlStateNormal];
                dayButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
            }else if(i <= firstWeekday + daysInThisMonth - 1 && i > todayIndex){
                // 今天之后显示灰色，不可点
                [dayButton setTitleColor:DEF_COLOR_A1A1A1 forState:UIControlStateNormal];
                dayButton.enabled = NO;
            } else {
                
            }
        }
        
        // start month
        NSDateComponents *nextComp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:nextMonthDate];
        if (nextComp.year == startComp.year && nextComp.month == startComp.month) {
            NSInteger todayIndex = [self day:self.startDate] + firstWeekday - 1;
            
            if (i ==  todayIndex) {
                
            }else if(firstWeekday <= i && i < todayIndex){
                // 今天之后显示灰色，不可点
                [dayButton setTitleColor:DEF_COLOR_A1A1A1 forState:UIControlStateNormal];
                dayButton.enabled = NO;
            } else if(i <= firstWeekday + daysInThisMonth - 1 && i > todayIndex) {
                
            }
        }
    }
    
    // 对选中的日期着色
    if ([[self.selectedDate substringToIndex:4] integerValue] == [self year:nextMonthDate] &&
        [[self.selectedDate substringWithRange:NSMakeRange(5, 2)] integerValue] == [self month:nextMonthDate]) {
        self.selectBtn.selected = YES;
        [self.selectBtn setBackgroundColor:self.dateColor];
    } else {
        self.selectBtn.selected = NO;
        [self.selectBtn setBackgroundColor:[UIColor clearColor]];
    }
    
    self.yearlabel.text = [NSString stringWithFormat:@"%li",[self year:nextMonthDate]];
    self.monthlabel.text = [NSString stringWithFormat:@"%li月",[self month:nextMonthDate]];
    
    if (button.tag == 1) {
        if (self.lastMonthBlock) {
            self.lastMonthBlock();
        }
    } else {
        if (self.nextMonthBlock) {
            self.nextMonthBlock();
        }
    }
}


#pragma mark - create View

- (void)createCalendarView{
    
    NSDate *date = [NSDate date];
    
    CGFloat margin = 13;
    CGFloat itemW     = (self.frame.size.width - 2 * margin) / 7;
    CGFloat itemH     = (self.frame.size.width - 2 * margin) / 7;
    
    //1.year
    self.yearlabel = [[UILabel alloc]init];
    self.yearlabel.text = [NSString stringWithFormat:@"%li",[self year:date]];
    self.yearlabel.font = [UIFont systemFontOfSize:14];
    self.yearlabel.textAlignment = NSTextAlignmentCenter;
    self.yearlabel.frame = CGRectMake(self.width*0.25 - 25, 17, 50, 20);
    self.yearlabel.textColor = DEF_COLOR_333339;
    [self addSubview:self.yearlabel];
    
    // 2. month
    self.monthlabel = [[UILabel alloc] init];
    self.monthlabel.text     = [NSString stringWithFormat:@"%li月",[self month:date]];
    self.monthlabel.font     = [UIFont systemFontOfSize:14];
    self.monthlabel.frame           = CGRectMake(self.width*0.75 - 20,17,40,20);
    self.monthlabel.textAlignment   = NSTextAlignmentCenter;
    self.monthlabel.textColor = DEF_COLOR_333339;
    [self addSubview: self.monthlabel];
    
    // 2.weekday
    NSArray *array = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    self.weekBg = [[UIView alloc] init];
    self.weekBg.frame = CGRectMake(margin, CGRectGetMaxY(self.monthlabel.frame)+20, self.frame.size.width - 2 * margin, itemH);
    [self addSubview:self.weekBg];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(_weekBg.frame.origin.x+20, CGRectGetMaxY(_weekBg.frame)-20, _weekBg.frame.size.width*0.9, 0.5)];
    line.backgroundColor = DEF_COLOR_ECECEC;
    [self addSubview:line];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:11];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        if (i == 0 || i == 6) {
            week.textColor       = DEF_COLOR_CDA265;
        } else {
            week.textColor       = DEF_COLOR_A1A1A1;
        }
        [self.weekBg addSubview:week];
    }
    
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW + margin + (itemW - 32) / 2 ;
        int y = (i / 7) * itemH + CGRectGetMaxY(self.weekBg.frame);
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, 32, 32);
        dayButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i % 7 == 0 || i % 7 == 6) {
            [dayButton setTitleColor:DEF_COLOR_CDA265 forState:UIControlStateNormal];
        } else {
            [dayButton setTitleColor:DEF_COLOR_333339 forState:UIControlStateNormal];
        }
        [dayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        dayButton.layer.cornerRadius = dayButton.frame.size.height / 2;
        dayButton.layer.masksToBounds = YES;
        
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        
        
        if (i < firstWeekday) {
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            dayButton.enabled = YES;
            [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
        }
        
        // this month
        if ([self month:date] == [self month:[NSDate date]]) {
            NSInteger todayIndex = [self day:date] + firstWeekday - 1;
            
            if(i ==  todayIndex){
                [dayButton setTitle:@"今日" forState:UIControlStateNormal];
                dayButton.titleLabel.font = [UIFont systemFontOfSize:11.0];
                self.selectBtn = dayButton;
                _selectedDate = [self dateStringFromDate:date];
            }else if(i > todayIndex){
                // 今天之后显示灰色，不可点
                [dayButton setTitleColor:DEF_COLOR_A1A1A1 forState:UIControlStateNormal];
                dayButton.enabled = NO;
            } else {
                
            }
        }
        
        // start month
        if ([self month:date] == [self month:self.startDate]) {
            NSInteger todayIndex = [self day:self.startDate] + firstWeekday - 1;
            
            if(i ==  todayIndex){
                
            }else if(i < todayIndex){
                // 今天之后显示灰色，不可点
                [dayButton setTitleColor:DEF_COLOR_A1A1A1 forState:UIControlStateNormal];
                dayButton.enabled = NO;
            } else {
                
            }
        }
    }
}


#pragma mark - chooseMonth

- (void)chooseMonth:(UIButton *)button {
    //下期版本
}


#pragma mark - output date

-(void)logDate:(UIButton *)dayBtn
{
    self.selectBtn.selected = NO;
    [self.selectBtn setBackgroundColor:[UIColor clearColor]];
    
    self.selectBtn = dayBtn;
    dayBtn.selected = YES;
    [dayBtn setBackgroundColor:self.dateColor];
    
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    if (!day) {
        day = [comp day];
    }
    
    _selectedDate = [NSString stringWithFormat:@"%zd-%02zd-%02zd", [comp year], [comp month], day];
    
    if (self.calendarBlock) {
        self.calendarBlock(day,[comp month],[comp year]);
    }
    
    [self dismiss];
    
}


#pragma mark - date button style

- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    if (self.isShowOnlyMonthDays) {
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    }
}

- (void)setStyle_BeforeToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    for (NSString *str in self.allDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text]) {
            UIView *domView = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.size.width / 2 - 3, btn.frame.size.height - 6, 6, 6)];
            domView.backgroundColor = [UIColor orangeColor];
            domView.layer.cornerRadius = 3;
            domView.layer.masksToBounds = YES;
            [btn addSubview:domView];
        }
    }
    for (NSString *str in self.allDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text]) {
            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
            stateView.layer.cornerRadius = btn.frame.size.height / 2;
            stateView.layer.masksToBounds = YES;
            stateView.backgroundColor = [UIColor blueColor];
            stateView.alpha = 0.5;
            [btn addSubview:stateView];
        }
    }
}

- (void)setStyle_Today:(UIButton *)btn
{
    btn.layer.cornerRadius = btn.frame.size.height / 2;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:DEF_COLOR_333339 forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn setBackgroundColor:DEF_COLOR_CDA265];
}

- (void)setStyle_AfterToday:(UIButton *)btn
{
    for (NSString *str in self.allDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text]) {
            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
            stateView.layer.cornerRadius = btn.frame.size.height / 2;
            stateView.layer.masksToBounds = YES;
            stateView.backgroundColor = self.allDaysColor;
            stateView.image = self.allDaysImage;
            stateView.alpha = 0.5;
            [btn addSubview:stateView];
        }
    }
    for (NSString *str in self.partDaysArr) {
        if ([str isEqualToString:btn.titleLabel.text]) {
            UIImageView *stateView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, btn.frame.size.height)];
            stateView.layer.cornerRadius = btn.frame.size.height / 2;
            stateView.layer.masksToBounds = YES;
            stateView.backgroundColor = self.partDaysColor;
            stateView.image = self.partDaysImage;
            stateView.alpha = 0.5;
            [btn addSubview:stateView];
        }
    }
}

- (void)setSelectBtn:(UIButton *)selectBtn
{
    _selectBtn = selectBtn;
    selectBtn.selected = YES;
    selectBtn.layer.cornerRadius = selectBtn.frame.size.height / 2;
    selectBtn.layer.masksToBounds = YES;
    [selectBtn setBackgroundColor:DEF_COLOR_CDA265];
}

#pragma mark - Lazy loading
- (NSArray *)allDaysArr {
    if (!_allDaysArr) {
        _allDaysArr = [NSArray array];
    }
    return _allDaysArr;
}

- (NSArray *)partDaysArr {
    if (!_partDaysArr) {
        _partDaysArr = [NSArray array];
    }
    return _partDaysArr;
}

- (UIColor *)headColor {
    if (!_headColor) {
        _headColor = [UIColor grayColor];
    }
    return _headColor;
}

- (UIColor *)dateColor {
    if (!_dateColor) {
        _dateColor = DEF_COLOR_CDA265;
    }
    return _dateColor;
}

- (UIColor *)allDaysColor {
    if (!_allDaysColor) {
        _allDaysColor = [UIColor blueColor];
    }
    return _allDaysColor;
}

- (UIColor *)partDaysColor {
    if (!_partDaysColor) {
        _partDaysColor = [UIColor cyanColor];
    }
    return _partDaysColor;
}

- (UIColor *)weekDaysColor {
    if (!_weekDaysColor) {
        _weekDaysColor = [UIColor lightGrayColor];
    }
    return _weekDaysColor;
}

- (void)display
{
    @weakify(self);
    
    //展开的动画
    self.sourceHeight = kScreenWidth + 30;
    self.height = 0;
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self);
        self.frame = CGRectMake(0, self.frame.origin.y, kScreenWidth, self.sourceHeight);
    } completion:^(BOOL finished) {
        @strongify(self);
        self.height = self.sourceHeight;
    }];
}

- (void)dismiss
{
    @weakify(self);
    
    //消失的动画
    [UIView animateWithDuration:0.25 animations:^{
        @strongify(self);
        self.frame = CGRectMake(0, self.frame.origin.y, kScreenWidth, 0);
    } completion:^(BOOL finished) {
        @strongify(self);
        self.height = self.sourceHeight;
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

//一个月第一个周末
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [component setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:component];
    NSUInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekDay - 1;
}

//总天数
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark - month +/-

- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    self.date=newDate;
    return newDate;
}

- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    self.date=newDate;
    return newDate;
}

#pragma mark - year+/-
-(NSDate*)lastYear:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    self.date=newDate;
    return newDate;

}

-(NSDate*)nextYear:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    self.date=newDate;
    return newDate;
    
}


#pragma mark - date get: day-month-year

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

// 是否是同一天
- (BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

- (NSString *)dateStringFromDate:(NSDate *)date
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date];
    return [NSString stringWithFormat:@"%zd-%02zd-%02zd", [comp1 year], [comp1 month], [comp1 day]];
}

@end
