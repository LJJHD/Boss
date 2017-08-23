//
//  JHUtility.h
//  JinghanLife
//
//  Created by jinghan on 16/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JHUtility : NSObject

/**
 *  工厂方法创建Label
 *
 *  @param frame            frame
 *  @param text             内容
 *  @param fontSize         字体大小(CGFloat型)
 *  @param textColor        字体颜色
 *  @param textAlignment    对齐方式
 *
 *  @return UILabel         创建好的Label
 */
+ (UILabel *)createLabelWithFrame:(CGRect)frame
                             text:(NSString *)text
                             font:(CGFloat)fontSize
                        textColor:(UIColor *)textColor
                    textAlignment:(NSTextAlignment)textAlignment;



/**
 *  工厂方法创建Button
 *
 *  @param frame            frame
 *  @param title            标题
 *  @param fontSize         字体大小(CGFloat型)
 *  @param textColor        字体颜色
 *  @param target           target
 *  @param action           action
 *  @param imageName        图片名称
 *
 *  @return Button          创建好的Button
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame
                              title:(NSString *)title
                               font:(CGFloat)fontSize
                          textColor:(UIColor *)textColor
                             target:(id)target
                             action:(SEL)action
                          imageName:(NSString *)imageName;


/**
 *  计算两点经纬度之间的距离
 *
 *  @param coordinate1       经纬度1
 *  @param coordinate2       经纬度2
 *
 *  @return double           距离
 */
+ (double)calculateDistanceCoordinateFrom:(CLLocationCoordinate2D)coordinate1 to:(CLLocationCoordinate2D)coordinate2;


/**
 *  校验手机号
 *
 *  @param mobileNum 传入手机号
 *
 *  @return 返回bool
 */
+ (BOOL)validateMobile:(NSString *)mobileNum;


/**
 *	@brief	隐藏电话号码
 *
 *	@param 	pNum 	电话号码
 *
 *	@return 186****1325
 */
+ (NSString *)securePhoneNumber:(NSString *)pNum;


/**
 *  反转数组
 *
 *  @param targetArray 传入可变数组
 */
+ (void)reverseArray:(NSMutableArray *)targetArray;


/**
 *  将时间戳转换为指定格式时时间
 *
 *  @param strTimestamp  传入的时间戳
 *  @param strDateFormat 时间的格式
 *
 *  @return 返回的时间
 */
+ (NSString *)getTimeWithTimestamp:(NSString *)strTimestamp WithDateFormat:(NSString *)strDateFormat;


/**
 *  通过时间获得时间戳     传入时间格式为YYYY-MM-dd HH:mm:ss
 *
 *  @param strDate 时间戳
 *
 *  @return 时间
 */
+ (NSString *)getTimeStampWithDate:(NSString *)strDate;


/**
 *  动态算出文本大小
 *
 *  @param size   限制宽高
 *  @param font   字体的大小
 *  @param spacing 行间距
 *  @param string 内容
 *
 *  @return cgsize
 */
+ (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font string:(NSString*)string withSpacing:(CGFloat)spacing;


/**
 *  设置文字行间距
 *
 *  @param string   字符串
 *  @param font     字体大小
 *  @param spacing  间距大小
 *
 *  @return NSAttributedString
 */

+(NSAttributedString *)setLineSpacingWithString:(NSString *)string withFont:(CGFloat)font spacing:(CGFloat)spacing;


/**
 *  获得屏幕图像
 *
 *  @param theView view
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)theView;


/**
 *  获得某个范围内的屏幕图像
 *
 *  @param theView view
 *  @param r       坐标
 *
 *  @return       UIImage
 */
+ (UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)r;


/**
 *  提示框
 *
 *  @param message  提示内容
 *
 */
+ (void)showToastWithMessage:(NSString *)message;


/**
 *  提示框
 *  @param  imageName 图片名称 
 *  @param message  提示内容
 *
 */
+ (void)showToastWithImageName:(NSString *)imageName message:(NSString *)message;


/**
 *  风火轮加载信息
 *
 *  @param targetView 对象
 *  @param msg        提示信息
 */
+ (void)showMBProgress:(UIView *)targetView message:(NSString *)msg;

/**
 *  隐藏风火轮
 *
 *  @param targetView 对象
 */
+ (void)hideMBProgress:(UIView*)targetView;

/**
 *  判断第一次启动
 *
 *
 */
+ (BOOL)isFirstLaunch;

/**
 返回字体的宽高
 **/
+(CGSize)getTextWith:(NSString *)text withFont:(NSInteger)font withWidth:(float)width withHeight:(float)height;

/**
 *  修改字体颜色
 *
 *  @param string       字符串
 *  @param font         字体大小
 *  @param textColor    字体颜色
 *
 *  @return             NSAttributedString
 */
+ (NSAttributedString *)getAttributedStringWithString:(NSString *)string font:(CGFloat)font textColor:(UIColor *)textColor;

/**
 *  修改字体颜色
 *
 *  @param string       字符串
 *  @param font         字体大小
 *  @param textColor    字体颜色
 *  @param  range       修改的范围
 *  @return             NSAttributedString
 */
+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string  range:(NSRange )range font:(CGFloat)font textColor:(UIColor *)textColor;


/**
 *  网络请求时播放的动画
 *
 *  @param view         当前的View
 *
 */
+(void)showGifProgressViewInView:(UIView *)view;

/**
 *  网络请求时播放的动画   自定义位置
 *
 *  @param view         当前的View 有偏移量
 *
 */
+(void)showGifProgressViewInView:(UIView *)view andOffsetValue:(CGFloat)value;


/**
 *  结束动画
 *
 *  @param view         当前的View
 *
 */
+(void)hiddenGifProgressViewInView:(UIView *)view;

/**
 *  获取当前系统版本
 *
 *  返回的是大版本号  比如 10.2.1  只返回10
 *
 */
+ (NSInteger)getSystemVersion;



@end
