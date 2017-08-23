//
//  LCHPickView.m
//  LBS_ store
//
//  Created by 李聪会 on 16/5/10.
//  Copyright © 2016年 BeidouLife. All rights reserved.
//

#import "JHPickView.h"
#import "AddressManager.h"
#import "AppDelegate.h"
@implementation JHPickView
{
    CGRect rect;
}
- (id)init
{
    if (self = [super init]) {
        
        [self creatView];
    }
    return self;
}
- (void)creatView
{
    self.frame = CGRectMake(0, DEF_HEIGHT, DEF_WIDTH, 216);
    self.backgroundColor = [UIColor whiteColor];
    rect = self.frame;
    
    float  height = 40;
    float  width  = 60;
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, height+10)];
    upView.backgroundColor = [UIColor whiteColor];
    [self addSubview:upView];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRGBValue_Hex:0xf0f0f0];
    view.frame = CGRectMake(0, upView.maxY, DEF_WIDTH, 0.5);
    [upView addSubview:view];
    
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRGBValue_Hex:0x333333] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setFrame:CGRectMake(0, 2, width, height)];
    [upView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(dismissPickView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setFrame:CGRectMake(self.width-width,2, width, height)];
    [sureBtn setTitleColor:[UIColor colorWithRGBValue_Hex:0x333333] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [upView addSubview:sureBtn];
    
    [sureBtn addTarget:self action:@selector(sureBntClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), 0, self.width-2*width, height+4)];
    self.titleLabel.text = @"请选择省/市/区";
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor colorWithRGBValue_Hex:0x333333];
    self.titleLabel.textAlignment =  NSTextAlignmentCenter ;
    [upView addSubview:self.titleLabel];
    
    
    self.BgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH,DEF_HEIGHT)];
    self.BgView.backgroundColor  =[UIColor blackColor];
    self.BgView.alpha = 0.3;
    self.BgView.hidden = YES;
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self.BgView];
    [app.window addSubview:self];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPickView:)];
    gestureRecognizer.numberOfTapsRequired =1;
    gestureRecognizer.numberOfTouchesRequired = 1;
    [self.BgView addGestureRecognizer:gestureRecognizer];
    
    _pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(upView.frame),DEF_WIDTH, 216)];
    _pick.delegate = self;
    _pick.dataSource = self;
    [self addSubview:self.pick];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.numberOfSection;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    switch (component) {
        case 0:
            return [self.dataArray count];
            
            break;
        case 1:
            return [self.sectionArray count];
            
            break;
        case 2:
            
            return [self.thirdArray count];
            
            break;
            
        default:
            return 0;
            break;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
        {
            JHPickModel *model = self.dataArray[row];
            
            return model.name;
        }
           
            break;
        case 1:
        {
            JHPickModel *model = self.sectionArray[row];
            
            return model.name;
        }
            break;
        case 2:
        {
            JHPickModel *model = self.thirdArray[row];
            
            return model.name;
        }
            break;
        default:
            return  @"";
            break;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case 0:{
            self.firstIndex = row;
            if (isObjNotEmpty(self.dataArray)) {
                JHPickModel *firstModel = self.dataArray[row];
                self.sectionArray = firstModel.subArray;
            }
            if (isObjNotEmpty(self.sectionArray)) {
                JHPickModel *sectionModel = self.sectionArray[row];
                self.thirdArray = sectionModel.subArray;
                [self.pick reloadComponent:1];
                [self.pick selectRow:0 inComponent:1 animated:YES];

            }
            if (isObjNotEmpty(self.thirdArray)) {
                [self.pick reloadComponent:2];
                [self.pick selectRow:0 inComponent:2 animated:YES];
            }

            
            break;
        }
        case 1:
        {
            self.sectionIndex = row;
            if (isObjNotEmpty(self.sectionArray)) {
                JHPickModel *sectionModel = self.sectionArray[row];
                self.thirdArray = sectionModel.subArray;
            }
            if (isObjNotEmpty(self.thirdArray)) {
                [self.pick reloadComponent:2];
                [self.pick selectRow:0 inComponent:2 animated:YES];
            }
            break;
        }
        case 2:{
            self.thirdIndex = row;
            break;
        }
        default:
            break;
    }
}
- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    if (isObjNotEmpty(dataArray)) {
        JHPickModel *firstModel = dataArray[0];
        self.sectionArray = firstModel.subArray;
        if (isObjNotEmpty(self.sectionArray)) {
            JHPickModel *sectionModel = self.sectionArray[0];
            self.thirdArray = sectionModel.subArray;
        }
    }
    [self.pick reloadAllComponents];
    
    
}
#pragma mark------视图消失----------
- (void)dismissPickView:(id*)sender
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.BgView.hidden = YES;
        self.frame = CGRectMake(0, rect.origin.y, DEF_WIDTH, 216+50);
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark------确定按钮方法----------
- (void)sureBntClick:(UIButton*)sureBtn
{
    if ([self.delegate respondsToSelector:@selector(pickView:withFirstModel:withSectionModel:withThirdModel:)]) {
        
        JHPickModel *firstModel = nil;
        
        JHPickModel *secondModel = nil;

        JHPickModel *thirdModel = nil;

        if (isObjNotEmpty(self.dataArray)) {
            firstModel = self.dataArray[self.firstIndex];
        }
        if (isObjNotEmpty(self.sectionArray)) {
            secondModel = self.sectionArray[self.sectionIndex];
        }
        if (isObjNotEmpty(self.thirdArray)) {
            thirdModel = self.thirdArray[self.thirdIndex];
        }
    
        [self.delegate pickView:self withFirstModel:firstModel withSectionModel:secondModel withThirdModel:thirdModel];
        
        
        [self dismissPickView:nil];
        
        
        
        
    }
}
#pragma mark------视图出线----------
- (void)showInView
{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.BgView.hidden = NO;
        self.frame = CGRectMake(0, rect.origin.y-216-50, DEF_WIDTH, 216+50);
    } completion:^(BOOL finished) {
        
    }];
}


@end
