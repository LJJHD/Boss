//
//  HCGDatePickerAppearance.h
//  HcgDatePicker-master
//
//  Created by 黄成钢 on 14/12/2016.
//  Copyright © 2016 chedaoshanqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCGDatePicker.h"


@interface HCGDatePickerAppearance : UIView
@property (nonatomic, copy) NSString *titleStr;
- (instancetype)initWithDatePickerMode:(DatePickerMode)dataPickerMode completeBlock:(void (^)(NSArray *time))completeBlock;
//用于年月日的开始时间和结束时间
- (instancetype)initWithDatePickerMode:(DatePickerMode)dataPickerMode MinDate:(NSDate *)minDate MaxDate:(NSDate *)maxDate completeBlock:(void (^)(NSArray *time))completeBlock;

- (void)show;

@end
