//
//  JHBoss_RestPicker.h
//  Boss
//
//  Created by jinghankeji on 2017/6/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class JHBoss_RestPicker;

@protocol PickerDelegate <NSObject>

@optional
- (void)restPicker:(JHBoss_RestPicker *)restPicker didSelectedIndex:(int )index contentStr:(NSString *)contentStr;

@end

@interface JHBoss_RestPicker : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) id<PickerDelegate> pickerDelegate;

@property (nonatomic, assign) NSInteger rowHeight;


/**
 *  查看datePicker当前选择的row
 */
@property (nonatomic, assign, readonly) int selectIndex;

-(instancetype)initWithPickerMode:(JHBoss_pickerType)PickerMode param:(NSArray *)contentParam;
@end
