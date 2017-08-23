//
//  HCGDatePicker.h
//  HcgDatePicker-master
//
//  Created by 黄成钢 on 14/12/2016.
//  Copyright © 2016 chedaoshanqian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DatePickerOneTime,//显示时分
    DatePickerTwoTime,//显示开始时间(时分) 和结束时间（时分）
    DatePickerYearMonthDaySection,//显示开始时间(年月日) 和结束时间（年月日）
    DatePickerYearMonthSection,//显示开始时间(年月) 和结束时间（年月）
}DatePickerMode;

@class HCGDatePicker;

@protocol HCGDatePickerDelegate <NSObject>

@optional
- (void)datePicker:(HCGDatePicker *)datePicker didSelectedTime:(NSString *)time;
/**
 用于开始年月日---结束年月日

 @param datePicker <#datePicker description#>
 @param beginDate 返回开始时间
 @param endDate 结束时间
 */
- (void)datePicker:(HCGDatePicker *)datePicker beginDate:(NSString *)beginDate endDate:(NSString *)endDate;
@end

@interface HCGDatePicker : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) id<HCGDatePickerDelegate> dvDelegate;

@property (nonatomic, assign) NSInteger rowHeight;


/**
 *  查看datePicker当前选择的日期
 */
@property (nonatomic, copy, readonly) NSString *time;
@property (nonatomic, copy, readonly) NSString *endTime;


/**
 *  datePicker显示time
 */
- (void)selectTime:(NSString *)time;

-(instancetype)initWithDatePickerMode:(DatePickerMode)datePickerMode;
-(instancetype)initWithDatePickerMode:(DatePickerMode)datePickerMode MinDate:(NSDate *)minDate MaxDate:(NSDate *)maxDate;
@end
