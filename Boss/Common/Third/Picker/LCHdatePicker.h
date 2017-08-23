//
//  LCHdatePicker.h
//  LBS_ store
//
//  Created by 李聪会 on 16/5/5.
//  Copyright © 2016年 BeidouLife. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum:NSInteger {
    DatePickerModeDateAndTime =1 ,//只有具体时间 13:13:00
    DatePickerModeDate,          //年月日 2010-10-10
    DatePickerModeTime,
    DatePickerModeCountDownTimer,
    DatePickerModeYearAndMoth,//只有年和月
}DataTpye;

@class LCHdatePicker;

@protocol LCHdatePickerDelegate <NSObject>
- (void)datePicker:(UIDatePicker*)datePicker  withTimeString:(NSString*)timeString withTimeDate:(NSDate*)date
;
//只显示年月的代理方法
- (void)PickView:(LCHdatePicker*)PickView  withTimeString:(NSString*)timeString withTimeDate:(NSDate*)date
;
@end


@interface LCHdatePicker : UIView
@property (nonatomic,strong) UIView         *BgView;
@property (nonatomic,strong) UIDatePicker   *datePicker;
@property (nonatomic,weak)   id             <LCHdatePickerDelegate>delegate;
@property (nonatomic,strong) UILabel        *titleLabel;
@property (nonatomic,assign) DataTpye       dataType;//显示系统博伦样式
@property (nonatomic,strong) NSString       *dateFormatterStr;//data转字符串的格式

- (void)showInView;

- (id)initWithType:(NSInteger)timeType withTimeFormatter:(NSString*)timeFormatter;

@end

