 

#import <UIKit/UIKit.h>

@interface XlSegmentView : UIView

//字体
@property (nonatomic)UIFont *font;
//是否被选择
@property (nonatomic)BOOL selected;
//设定它在分段控制器中的位置
@property (nonatomic)NSInteger index;

@property (nonatomic,strong)NSString *text;

@property (nonatomic,assign)BOOL showDot;


//设定imageView的默认图片和选中图
-(void)setImage:(UIImage *)image highlineImage:(UIImage *)highlineImage;
//设定TextLabel的默认颜色和选中时颜色
-(void)setLableTextColor:(UIColor *)color highlineColor:(UIColor *)highlineColor;

@end
