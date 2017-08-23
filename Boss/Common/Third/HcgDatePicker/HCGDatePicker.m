//
//  HCGDatePicker.m
//  HcgDatePicker-master
//
//  Created by 黄成钢 on 14/12/2016.
//  Copyright © 2016 chedaoshanqian. All rights reserved.
//

#import "HCGDatePicker.h"

#define HOUR ( 3 )
#define DAY ( 2 )
#define MONTH ( 1 )
#define YEAR ( 0 )
#define minTimeInterval 631152000

// Identifies for component views
#define LABEL_TAG 43

@interface HCGDatePicker ()
@property (nonatomic, strong) NSIndexPath *todayIndexPath;

@property (nonatomic, strong) NSArray *hours;//小时数组
@property (nonatomic, strong) NSArray *minutes;//分钟数组

@property (nonatomic, strong) NSArray *years;//年数组
@property (nonatomic, strong) NSArray *months;//月数组
@property (nonatomic, strong) NSArray *days;//日数组

@property (nonatomic, strong) NSCalendar *calendar;

@property (nonatomic, assign) NSInteger numberOfComponent;//记录多少个section
@property (nonatomic, assign) DatePickerMode datePickerMode;

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, assign) NSInteger HourselectRow;//记录选中的小时
@property (nonatomic, assign) NSInteger timeselectRow;//记录选中的分钟

@property (nonatomic, assign) NSInteger beginyearselectRow;//记录开始选中的年
@property (nonatomic, assign) NSInteger beginmonthselectRow;//记录开始选中的月
@property (nonatomic, assign) NSInteger begindayselectRow;//记录开始选中的日

@property (nonatomic, assign) NSInteger endyearselectRow;//记录结束选中的年
@property (nonatomic, assign) NSInteger endmonthselectRow;//记录结束选中的月
@property (nonatomic, assign) NSInteger enddayselectRow;//记录结束选中的日

@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger maxYear;
@property (nonatomic, strong) NSDate *minDate;//显示的最小日期
@property (nonatomic, strong) NSDate *maxDate;//显示的最大日期
@end

@implementation HCGDatePicker


#pragma mark - Init

//有年月日
-(instancetype)initWithDatePickerMode:(DatePickerMode)datePickerMode MinDate:(NSDate *)minDate MaxDate:(NSDate *)maxDate
{
    if (self = [super init])
    {
        self.datePickerMode = datePickerMode;
        switch (datePickerMode) {
            case DatePickerOneTime:
                self.numberOfComponent = 2;
                break;
            case DatePickerTwoTime:
                self.numberOfComponent = 5;
                break;
            case DatePickerYearMonthDaySection:
                self.numberOfComponent = 7;
                break;
            case DatePickerYearMonthSection:
                self.numberOfComponent = 5;
                break;
            default:
                break;
        }
        
        if (minDate) {
            NSDate *date =  [self extractDayDate:minDate];
            [self setMinDate:date];
        } else {
            [self setMinDate:[self extractDayDate:[NSDate dateWithTimeIntervalSince1970:minTimeInterval]]];
        }
        
        if (maxDate) {
            NSDate *date =  [self extractDayDate:maxDate];
            [self setMaxDate:date];
        } else {
            [self setMaxDate:[self extractDayDate:[NSDate dateWithTimeIntervalSince1970:4102416000]]];
            
        }
        [self loadDefaultsParameters];
        
    }
    return self;
}

//时、分
-(instancetype)initWithDatePickerMode:(DatePickerMode)datePickerMode
{
    if (self = [super init])
    {
        self.datePickerMode = datePickerMode;
        
        switch (datePickerMode) {
            case DatePickerOneTime:
                self.numberOfComponent = 2;
                break;
            case DatePickerTwoTime:
                self.numberOfComponent = 5;
                break;
            default:
                break;
        }
        
        [self loadDefaultsParameters];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadDefaultsParameters];
}


#pragma mark - Open methods
//开始时间
-(NSString *)time
{
    if (self.datePickerMode == DatePickerYearMonthDaySection) {
        
        NSString *year ;
        NSString *month;
        NSString *day;
        year = [self.years objectAtIndex:self.beginyearselectRow];
        month = [self.months objectAtIndex:self.beginmonthselectRow];
        day = [self.days objectAtIndex:self.begindayselectRow];

        NSString *date = [NSString stringWithFormat:@"%@%@%@",year,month,day];
        return date;
    }else{
    
        NSString *hour = [self.hours objectAtIndex:([self selectedRowInComponent:0])];
        
        NSString *minute = [self.minutes objectAtIndex:([self selectedRowInComponent:1])];
        
        NSString *time = [NSString stringWithFormat:@"%@:%@",[hour substringToIndex:hour.length - 1], [minute substringToIndex:minute.length - 1]];
        return time;
    }
    return nil;
}

-(NSString *)endTime
{
    
    if (self.datePickerMode == DatePickerYearMonthDaySection) {
        
        NSString *year ;
        NSString *month;
        NSString *day;
        year = [self.years objectAtIndex:self.endyearselectRow];
        month = [self.months objectAtIndex:self.endmonthselectRow];
        day = [self.days objectAtIndex:self.enddayselectRow];
        NSString *date = [NSString stringWithFormat:@"%@%@%@",year,month,day];
        return date;
    }else{
        
        NSString *hour = [self.hours objectAtIndex:([self selectedRowInComponent:3])];
        
        NSString *minute = [self.minutes objectAtIndex:([self selectedRowInComponent:4])];
        
        NSString *endTime = [NSString stringWithFormat:@"%@:%@",[hour substringToIndex:hour.length - 1], [minute substringToIndex:minute.length - 1]];
        
        return endTime;
    }
    return nil;
}


#pragma mark - UIPickerViewDelegate

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self componentWidthComponent:component] -3;
}

-(UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)

        {
            singleLine.backgroundColor = DEF_COLOR_ECECEC;
        }
    }
    
    BOOL selected = NO;
   
//    if (component == 0 || component == 3) {
//
//        if (_HourselectRow == row) {
//            
//             selected = YES;
//        }
//    
//    } else if(component == 1 || component == 4) {
//
//        
//        if (_timeselectRow == row) {
//            
//            selected = YES;
//        }
//        
//    }
    
    if (self.datePickerMode == DatePickerOneTime || self.datePickerMode == DatePickerTwoTime) {
        
        switch (component) {
            case 0:{
            
            
                if (_HourselectRow == row) {
                    
                    selected = YES;
                }
            }
                break;
            case 1:{
            
                if (_timeselectRow == row) {
                    
                    selected = YES;
                }
            }
                break;
            case 2:
                break;
            case 3:{
                
                if (_HourselectRow == row) {
                    
                    selected = YES;
                }
            }
                break;
            case 4:{
            
                if (_timeselectRow == row) {
                    
                    selected = YES;
                }
            }
                break;
                
            default:
                break;
        }
        
        
    }else if (self.datePickerMode == DatePickerYearMonthDaySection){
        //    年月日
        switch (component) {
            case 0:{
            
                if (_beginyearselectRow == row) {
                    
                    selected = YES;
                }
            }
                break;
            case 1:{
            
                if (_beginmonthselectRow == row) {
                    
                    selected = YES;
                }
            
            }
                break;
            case 2:{
                
                if (_begindayselectRow == row) {
                    
                    selected = YES;
                }
                
            }
                break;
            case 3:
                break;
            case 4:
            {
                
                if (_endyearselectRow == row) {
                    
                    selected = YES;
                }
                
                
            }
                break;
            case 5:{
                
                if (_endmonthselectRow == row) {
                    
                    selected = YES;
                }
                
            }
                break;
            case 6:{
                
                if (_begindayselectRow == row) {
                    
                    selected = YES;
                }
                
            }
                break;
            default:
                break;
        }
        
    }else if (self.datePickerMode == DatePickerYearMonthSection){
        //年月
        switch (component) {
            case 0:{
                
                if (_beginyearselectRow == row) {
                    
                    selected = YES;
                }
            }
                break;
            case 1:{
                
                if (_beginmonthselectRow == row) {
                    
                    selected = YES;
                }
                
            }
                break;
            case 2:
                break;
            case 3:{
                
                if (_endyearselectRow == row) {
                    
                    selected = YES;
                }
                
                
            }

                break;
            case 4:
            {
                
                if (_endmonthselectRow == row) {
                    
                    selected = YES;
                }
                
            }
                break;
            
            default:
                break;
        }

        
    }
    
    UILabel *returnView = nil;
    if(view.tag == LABEL_TAG)
    {
        returnView = (UILabel *)view;
    }
    else
    {
        returnView = [self labelForComponent:component];
    }
    
    if (self.datePickerMode == DatePickerYearMonthSection || self.datePickerMode == DatePickerYearMonthDaySection ) {
        CGFloat font;
        if (DEF_WIDTH <= 320) {
            font = 14;
        }else if (DEF_WIDTH > 320 && DEF_WIDTH <= 375){
        
            font = 15;
        }else{
         
            font = 17;
        }
        returnView.font = DEF_SET_FONT(font);//设置时间字体大小
        if (component == ((_numberOfComponent + 1)/2 - 1)) {
            //取最中间的component
            returnView.textAlignment = NSTextAlignmentLeft;
        }
    }else{
    
    returnView.font = DEF_SET_FONT(18);
    }
    returnView.textColor = selected ? DEF_COLOR_B48645 : DEF_COLOR_6E6E6E;
    returnView.text = [self titleForRow:row forComponent:component];
    if (self.datePickerMode == DatePickerOneTime || self.datePickerMode == DatePickerTwoTime) {
        if (component == 2) {
            returnView.textColor = DEF_COLOR_6E6E6E;
        }
    }
        return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.rowHeight;
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return self.numberOfComponent;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    
    if (self.datePickerMode == DatePickerOneTime || self.datePickerMode == DatePickerTwoTime) {
        
        switch (component) {
            case 0:
                count = self.hours.count;
                break;
            case 1:
                count = self.minutes.count;
                break;
            case 2:
                count = 1;
                break;
            case 3:
                count = self.hours.count;
                break;
            case 4:
                count = self.minutes.count;
                break;
                
            default:
                count = 0;
                break;
        }

        
    }else if (self.datePickerMode == DatePickerYearMonthDaySection){
        //    年月日
        switch (component) {
            case 0:
                count = self.years.count;
                break;
            case 1:
                count = self.months.count;
                break;
            case 2:
                count = self.days.count;
                break;
            case 3:
                count = 1;
                break;
            case 4:
                count = self.years.count;
                break;
            case 5:
                count = self.months.count;
                break;
            case 6:
                count = self.days.count;
                break;
            default:
                break;
        }
        
    }else if (self.datePickerMode == DatePickerYearMonthSection){
        //年月
        switch (component) {
            case 0:
                count = self.years.count;
                break;
            case 1:
                 count = self.months.count;
                break;
                
            case 2:
                count = 1;
                break;
            case 3:
                count = self.years.count;
                break;
            case 4:
                count = self.months.count;
                break;
            default:
                break;
        }
        
    }
    return count;
}


#pragma mark - Util

-(CGFloat)componentWidthComponent:(NSInteger)component
{
    if (self.datePickerMode == DatePickerYearMonthSection || self.datePickerMode == DatePickerYearMonthDaySection || self.datePickerMode == DatePickerTwoTime) {
        
        if (component == ((_numberOfComponent + 1)/2 - 1)) {
            //取最中间的component
            return 15;
        }else{
        
         return (self.bounds.size.width-10) / (_numberOfComponent-1);
        }
        
    }else{
        
         return self.bounds.size.width / _numberOfComponent;
    }
   
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
   
    if (self.datePickerMode == DatePickerOneTime || self.datePickerMode == DatePickerTwoTime) {
        
        switch (component) {
            case 0:
                return [self.hours objectAtIndex:row];
                break;
            case 1:
                return [self.minutes objectAtIndex:row];
                break;
            case 2:
                return @"-";
                break;
            case 3:
                return [self.hours objectAtIndex:row];
                break;
            case 4:
                return [self.minutes objectAtIndex:row];
                break;
                
            default:
                break;
        }
        
    }else if (self.datePickerMode == DatePickerYearMonthDaySection){
        //    年月日
        switch (component) {
            case 0:
                return [self.years objectAtIndex:row];
                break;
            case 1:
                 return [self.months objectAtIndex:row];
                break;
            case 2:
                return [self.days objectAtIndex:row];
                break;
            case 3:
                 return @"-";
                break;
            case 4:
                return [self.years objectAtIndex:row];
                break;
            case 5:
                return [self.months objectAtIndex:row];
                break;
            case 6:
                 return [self.days objectAtIndex:row];
                break;
            default:
                break;
        }
        
    }else if (self.datePickerMode == DatePickerYearMonthSection){
        //年月
        
        switch (component) {
            case 0:
                return [self.years objectAtIndex:row];
                break;
            case 1:
                return [self.months objectAtIndex:row];
                break;
                
            case 2:
                 return @"-";
                break;
            case 3:
                return [self.years objectAtIndex:row];
                break;
            case 4:
                return [self.months objectAtIndex:row];
                break;
            default:
                break;
        }
        
    }
    return @"";
}

//组件的label
-(UILabel *)labelForComponent:(NSInteger)component
{
    CGRect frame = CGRectMake(0, 0, [self componentWidthComponent:component]-3, self.rowHeight);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;    // UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    label.tag = LABEL_TAG;
    
    return label;
}

-(NSDate *)monthDate
{
    //    NSInteger monthCount = self.months.count;
    NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH])];
    
    //    NSInteger yearCount = self.years.count;
    NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR])];
    NSDateFormatter *formatter = [NSDateFormatter new];
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy年M月"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@%@", year, month]];
    
    return date;
}

-(NSDate *)yearDate
{
    //    NSInteger yearCount = self.years.count;
    NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR])];
    NSDateFormatter *formatter = [NSDateFormatter new];
    //    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [formatter setDateFormat:@"yyyy年"];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@", year]];
    
    return date;
}

- (void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear
{
    self.minYear = minYear;
    
    
    if (maxYear > minYear)
    {
        self.maxYear = maxYear;
    }
    else
    {
        self.maxYear = 2099;
    }
    
    self.years = [self nameOfYears];
    self.todayIndexPath = [self todayPath];
}

-(NSIndexPath *)todayPath // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self currentMonthName];
    NSString *year  = [self currentYearName];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            break;
        }
    }
    return [NSIndexPath indexPathForRow:row inSection:section];
}

-(NSString *)currentMonthName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"M月"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentYearName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentDayName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"d日"];
    return [formatter stringFromDate:[NSDate date]];
}


/**
 获取年数组

 @return 返回年数组
 */
-(NSArray *)nameOfYears{

    NSMutableArray *years = [NSMutableArray array];
    
    for(NSInteger year = self.minYear; year <= self.maxYear; year++)
    {
        NSString *yearStr = [NSString stringWithFormat:@"%li年", (long)year];
        [years addObject:yearStr];
    }
    return years;
}

/**
 获取月数组

 @return 返回月数组
 */
-(NSArray *)nameOfMonths{

   return @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
}

/**
   获取天数组

 @return 返回天数组
 */
-(NSArray *)nameOfDays{

    NSUInteger numberOfDaysInMonth = [self daysCountWithSelDate];
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 1; i < numberOfDaysInMonth +1 ; i ++) {
        NSString *day = [NSString stringWithFormat:@"%d日",i];
        [tempArr addObject:day];
    }
    return tempArr;
}

/**
 天数
 @return <#return value description#>
 */
-(NSInteger)daysCountWithSelDate {
    self.calendar = [NSCalendar currentCalendar];
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self monthDate]];
    return range.length;
}

//获得小时数组
-(NSArray *)nameOfHours
{
    NSMutableArray *hours = [NSMutableArray array];
    
    for(NSInteger hour = 0; hour <= 23; hour++)
    {
        NSString *hourStr = [NSString stringWithFormat:@"%li时", (long)hour];
        [hours addObject:hourStr];
    }
    return hours;
}
//获取分数组
-(NSArray *)nameOfMinutes
{
    NSMutableArray *minutes = [NSMutableArray array];
    
    for(NSInteger minute = 0; minute < 60; minute += 15)
    {
        NSString *hourStr = [NSString stringWithFormat:@"%02zd分", (long)minute];
        [minutes addObject:hourStr];
    }
    return minutes;
}

/**
 用于返回开始日期和结束日期

 @param type 1开始日期。 2结束日期
 @return 日期
 */
-(NSString *)selectDate:(NSString *)type{

    NSString *year ;
    NSString *month;
    NSString *day;
    if (type.intValue == 1) {
        
        year = [self.years objectAtIndex:self.beginyearselectRow];
        month = [self.months objectAtIndex:self.beginmonthselectRow];
        day = [self.days objectAtIndex:self.begindayselectRow];
    
    }else if (type.intValue == 2){
    
        year = [self.years objectAtIndex:self.endyearselectRow];
        month = [self.months objectAtIndex:self.endmonthselectRow];
        day = [self.days objectAtIndex:self.enddayselectRow];
       
    }

    NSString *date = [NSString stringWithFormat:@"%@.%@.%@",year,month,day];
    return date;
}


-(NSString *)currentMinuteName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"MM分"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentHourName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"H时"];
    return [formatter stringFromDate:[NSDate date]];
}

-(void)loadDefaultsParameters
{
    self.rowHeight = 34;
    if (self.datePickerMode == DatePickerOneTime || self.datePickerMode == DatePickerTwoTime) {
        
        self.hours = [self nameOfHours];
        self.minutes = [self nameOfMinutes];
    }else if (self.datePickerMode == DatePickerYearMonthDaySection){
    
        self.years  =  [self nameOfYears];
        self.months =  [self nameOfMonths];
        self.days   =  [self nameOfDays];
        
    }
    self.delegate = self;
    self.dataSource = self;
    [self showNowDate];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.datePickerMode == DatePickerOneTime || self.datePickerMode == DatePickerTwoTime) {
        
        if (component == 0 || component == 3 ) {
            
            _HourselectRow = row;
            
        }else if (component == 1 || component == 4){
            
            _timeselectRow = row;
        }
        if ([self.dvDelegate respondsToSelector:@selector(datePicker:didSelectedTime:)]) {
            [self.dvDelegate datePicker:self didSelectedTime:[self time]];
        }
    }else if (self.datePickerMode == DatePickerYearMonthDaySection){
//    年月日
        switch (component) {
            case 0:
                _beginyearselectRow = row;
                break;
            case 1:
                _beginmonthselectRow = row;
                break;
            case 2:
                _begindayselectRow = row;
                break;
            case 3:
                
                break;
            case 4:
                _endyearselectRow  = row;
                break;
            case 5:
                _endmonthselectRow = row;
                break;
            case 6:
                _enddayselectRow   = row;
                break;
            default:
                break;
        }
        
        if ([self.dvDelegate respondsToSelector:@selector(datePicker:beginDate:endDate:)]) {
            
            [self.dvDelegate datePicker:self beginDate:[self selectDate:@"1"] endDate:[self selectDate:@"2"]];
        }
    
    }else if (self.datePickerMode == DatePickerYearMonthSection){
        //年月
        
        switch (component) {
            case 0:
                _beginyearselectRow = row;
                break;
            case 1:
                _beginmonthselectRow = row;
                break;
           
            case 2:
                
                break;
            case 3:
                _endyearselectRow  = row;
                break;
            case 4:
                _endmonthselectRow  = row;
                break;
            default:
                break;
        }

    }
    
   
     [self reloadComponent:component];
}

//第一次打开显示单前时间
- (void)showNowDate{

    NSString * year = [NSString stringWithFormat:@"%d年",[NSDate date].year];
    NSString * month = [NSString stringWithFormat:@"%d月",[NSDate date].month];
    NSString * day   = [NSString stringWithFormat:@"%d日",[NSDate date].day];
    NSInteger yearIndex = 0;
    NSInteger monthIndex = 0;
    NSInteger dayIndex = 0;
    
    if ([self.years containsObject:year]) {
        yearIndex = [self.years indexOfObject:year];
    }
    if ([self.months containsObject:month]) {
        monthIndex = [self.months indexOfObject:month];
    }
    if ([self.days containsObject:day]) {
        dayIndex = [self.days indexOfObject:day];
    }
    
    for (int i = 0; i < self.numberOfComponents; i++) {
        
        if (self.numberOfComponents == 7) {
            NSInteger row = 0;
            switch (i) {
                case 0:
                    row = yearIndex;
                    break;
                case 1:
                    row = monthIndex;
                    break;
                case 2:
                    row = dayIndex;
                    break;
                case 3:
                    
                    break;
                case 4:
                    row = yearIndex;
                    break;
                case 5:
                    row = monthIndex;
                    break;
                case 6:
                    row = dayIndex;
                    break;
                default:
                    break;
            }
            [self selectRow:row inComponent:i animated:NO];
            [self pickerView:self didSelectRow:row inComponent:i];

        }
        
        if (self.numberOfComponents == 5) {
            
            NSInteger row = 0;
            switch (i) {
                case 0:
                    row = yearIndex;
                    break;
                case 1:
                    row = monthIndex;
                    break;
                case 2:
                   
                    break;
                case 3:
                      row = yearIndex;
                    break;
                case 4:
                   row = monthIndex;
                    break;
               
                default:
                    break;
            }
            [self selectRow:row inComponent:i animated:NO];
            [self pickerView:self didSelectRow:row inComponent:i];
        }
       
    }
}

-(NSString *)selectHourName:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"H时"];
    return [formatter stringFromDate:date];
}

-(NSCalendar *)calendar {
    if (!_calendar) {
        _calendar = [NSCalendar currentCalendar];
        
    }
    return _calendar;
}

-(NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        [_formatter setTimeZone:[NSTimeZone systemTimeZone]];
    }
    return _formatter;
}

- (NSDate *)extractDayDate:(NSDate *)date {
    //get seconds since 1970
    NSTimeInterval interval = [date timeIntervalSince1970] + 8 * 60 * 60;
    int daySeconds = 24 * 60 * 60;
    //calculate integer type of days
    NSInteger allDays = interval / daySeconds;
    
    return [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
}

- (NSDate *)extractHourDate:(NSDate *)date {
    //get seconds since 1970
    NSTimeInterval interval = [date timeIntervalSince1970];
    int daySeconds = 60 * 60;
    //calculate integer type of days
    NSInteger allDays = interval / daySeconds;
    if ((int)interval % daySeconds) {
        allDays ++;
    }
    return [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
}

- (void)setMinDate:(NSDate *)minDate{
    _minDate = minDate;
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *minComps = [self.calendar components:unitFlags fromDate:minDate];
    self.minYear = [minComps year];//获取年对应的长整形字符串
}

- (void)setMaxDate:(NSDate *)maxDate{
    _maxDate = maxDate;
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *maxComps = [self.calendar components:unitFlags fromDate:maxDate];
    
    self.maxYear = [maxComps year];//获取年对应的长整形字符串
}

@end
