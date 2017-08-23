//
//  JHBoss_RestPicker.m
//  Boss
//
//  Created by jinghankeji on 2017/6/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_RestPicker.h"
// Identifies for component views
#define LABEL_TAG 43
@interface JHBoss_RestPicker ()
@property (nonatomic, assign) NSInteger selectRow;//记录选中的row
@property (nonatomic, assign) JHBoss_pickerType pickerType;
@property (nonatomic, copy)    NSArray *contentArr;//内容
@end
@implementation JHBoss_RestPicker

-(instancetype)initWithPickerMode:(JHBoss_pickerType)PickerMode param:(NSArray *)contentParam{

    self = [super init];
    if (self) {
        _pickerType = PickerMode;
        _contentArr = contentParam;
        
        [self loadDefaultsParameters];
    }

    return self;
}

-(void)loadDefaultsParameters
{
    self.rowHeight = 34;
    
    
    self.delegate = self;
    self.dataSource = self;
}

-(void)setRowHeight:(NSInteger)rowHeight{

    _rowHeight = rowHeight;
    if (rowHeight <= 0) {
        
        self.rowHeight = 34;
    }

}

#pragma mark - UIPickerViewDelegate

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.bounds.size.width - 8;
}

-(UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
    
    BOOL selected = NO;
    
    if (self.selectRow == row) {
        selected = YES;
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
    
    returnView.font = DEF_SET_FONT(18);
    returnView.textColor = selected ? DEF_COLOR_B48645 : DEF_COLOR_6E6E6E;
    returnView.text = [self titleForRow:row forComponent:component];
    if (component == 2) {
        returnView.textColor = DEF_COLOR_6E6E6E;
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
    return 1;
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    return self.contentArr.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if ([self.pickerDelegate respondsToSelector:@selector(restPicker:didSelectedIndex:contentStr:)]) {
        [self.pickerDelegate restPicker:(JHBoss_RestPicker *)pickerView didSelectedIndex:(int)row contentStr:self.contentArr[row]];
    }
   
    [self reloadComponent:component];
}

-(int)selectIndex{

    return (int)[self selectedRowInComponent:0];
}

-(UILabel *)labelForComponent:(NSInteger)component
{
    CGRect frame = CGRectMake(0, 0, self.bounds.size.width - 8, self.rowHeight);
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;    // UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.userInteractionEnabled = NO;
    label.tag = LABEL_TAG;
    return label;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.contentArr[row];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
