//
//  LCHPickView.h
//  LBS_ store
//

//

#import <Foundation/Foundation.h>

@class LCHPickView;

@protocol LCHPickerDelegate <NSObject>
- (void)pickView:(LCHPickView*)datePicker  withAddress:(NSString*)address withIdDic:(NSDictionary*)dic
;
@end


@protocol LCHPickerDelegate;

@interface LCHPickView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) UIView       *BgView;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,retain) UIPickerView *pick;
@property (nonatomic,strong) UILabel      *titleLabel;
@property (nonatomic,strong) NSArray      *privinceArr;//当前省份数组
@property (nonatomic,strong) NSArray      *cityArr;//当前城市
@property (nonatomic,strong) NSArray      *districtsArr;//区
@property (nonatomic,assign) NSInteger    firstIndex;//第一个区idnex
@property (nonatomic,assign) NSInteger    sectionIndex;//第2个区idnex
@property (nonatomic,assign) NSInteger    thirdIndex;//第3个区idnex
@property (nonatomic,weak)   id<LCHPickerDelegate>            delegate;

- (void)showInView;

@end
