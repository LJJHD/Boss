//
//  LCHPickView.h
//  LBS_ store
//
//  Created by 李聪会 on 16/5/10.
//  Copyright © 2016年 BeidouLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHPickModel.h"

@class JHPickView;

@protocol JHPickViewDelegate <NSObject>
- (void)pickView:(JHPickView*)datePicker  withAddress:(NSString*)address withIdDic:(NSDictionary*)dic
;
- (void)pickView:(JHPickView*)pickView  withFirstModel:(JHPickModel*)fristModel withSectionModel:(JHPickModel*)sectionModel  withThirdModel:(JHPickModel*)thirdModel;
@end


@protocol JHPickViewDelegate;

@interface JHPickView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) UIView       *BgView;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,retain) UIPickerView *pick;
@property (nonatomic,strong) UILabel      *titleLabel;
@property (nonatomic,strong) NSArray      *dataArray;
@property (nonatomic,strong) NSArray      *sectionArray;
@property (nonatomic,strong) NSArray      *thirdArray;
@property (nonatomic,assign) NSInteger    firstIndex;//第一个区idnex
@property (nonatomic,assign) NSInteger    sectionIndex;//第2个区idnex
@property (nonatomic,assign) NSInteger    thirdIndex;//第3个区idnex
@property (nonatomic,assign) NSInteger    numberOfSection;

@property (nonatomic,weak)   id<JHPickViewDelegate>            delegate;

- (void)showInView;

@end
