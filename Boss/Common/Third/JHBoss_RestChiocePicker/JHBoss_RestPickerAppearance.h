//
//  JHBoss_RestPickerAppearance.h
//  Boss
//
//  Created by jinghankeji on 2017/6/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_RestPicker.h"
@interface JHBoss_RestPickerAppearance : UIView

@property (nonatomic, copy) NSString *titleStr;
/**
 <#Description#>

 @param pickerType 类型
 @param contentParam 传给picker的内容
 @param completeBlock 完成picker选择的回调
 @return 返回该类对象
 */
-(instancetype)initWithPickerType:(JHBoss_pickerType )pickerType param:(NSArray *)contentParam completeBlock:(void(^)(int index))completeBlock;

-(void)show;
@end
