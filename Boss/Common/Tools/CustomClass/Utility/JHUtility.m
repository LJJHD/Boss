//
//  JHUtility.m
//  JinghanLife
//
//  Created by jinghan on 16/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHUtility.h"
#import <MBProgressHUD.h>

@implementation JHUtility


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
+ (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text font:(CGFloat)fontSize textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = textColor?textColor:[UIColor blackColor];
    label.textAlignment = textAlignment;
    
    return label;
}


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
 *  @return button          创建好的button
 */
+ (UIButton *)createButtonWithFrame:(CGRect)frame title:(NSString *)title font:(CGFloat)fontSize textColor:(UIColor *)textColor target:(id)target action:(SEL)action imageName:(NSString *)imageName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitleColor:textColor?textColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    return button;
}

/**
 *  计算两点经纬度之间的距离
 *
 *  @param coordinate1 经度
 *  @param coordinate2 纬度
 *
 *  @return 返回距离
 */
+ (double)calculateDistanceCoordinateFrom:(CLLocationCoordinate2D)coordinate1 to:(CLLocationCoordinate2D)coordinate2
{
    
    if (coordinate1.longitude >0  && coordinate1.longitude < 180)
    {
        if (coordinate2.longitude >0  && coordinate2.longitude < 180)
        {
            CLLocation  *currentLocation = [[CLLocation alloc]initWithLatitude:coordinate1.latitude longitude:coordinate2.longitude];
            CLLocation *otherLocation = [[CLLocation alloc]initWithLatitude:coordinate2.latitude longitude:coordinate1.longitude];
            CLLocationDistance distance = [currentLocation distanceFromLocation:otherLocation];
            return distance;
        }
    }
    else
    {
        return 0.00;
    }
    
    return 0.00;
}

/**
 *  校验手机号
 *
 *  @param mobileNum 入参string
 *
 *  @return 返回bool
 */
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    if(mobileNum.length == 0 || mobileNum == nil || mobileNum.length < 11) return NO;
    
    NSString *Regex = @"^(13[0-9]|15[0-9]|18[0-9]|17[0-9]|147)\\d{8}$";//以前用的
    NSPredicate *phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    return [phone evaluateWithObject:mobileNum];
}


/**
 *	@brief	隐藏电话号码
 *
 *	@param 	pNum 	电话号码
 *
 *	@return 186****1325
 */

+ (NSString *)securePhoneNumber:(NSString *)pNum
{
    if (pNum.length != 11)
    {
        return pNum;
    }
    NSString *result = [NSString stringWithFormat:@"%@****%@",[pNum substringToIndex:3],[pNum substringFromIndex:7]];
    return result;
}

/**
 *  反转数组
 *
 *  @param targetArray 传入可变数组
 */

+ (void)reverseArray:(NSMutableArray *)targetArray
{
    for (int i = 0; i < targetArray.count / 2.0f; i++)
    {
        [targetArray exchangeObjectAtIndex:i withObjectAtIndex:(targetArray.count - 1 - i)];
    }
}


/**
 *  将时间戳转换为指定格式时时间
 *
 *  @param strTimestamp  传入的时间戳
 *  @param strDateFormat 时间的格式
 *
 *  @return 返回的时间
 */
+ (NSString *)getTimeWithTimestamp:(NSString *)strTimestamp WithDateFormat:(NSString *)strDateFormat
{
    if ([strTimestamp isEqualToString:@"0"]||[strTimestamp length]==0)
    {
        return @"";
    }
    
    
    long long time = 0;
    if (strTimestamp.length == 10) {
        time = [strTimestamp longLongValue];
    }
    else if (strTimestamp.length == 13){
        time = [strTimestamp longLongValue]/1000;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:strDateFormat];
    NSString *strTime = [formatter stringFromDate:date];
    return strTime;
}


/**
 *  通过时间获得时间戳     传入时间格式为YYYY-MM-dd HH:mm:ss
 *
 *  @param strDate 时间戳
 *
 *  @return 时间
 */
+ (NSString *)getTimeStampWithDate:(NSString *)strDate
{
    NSDateFormatter*formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:strDate];
    
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    NSString * str  = [NSString stringWithFormat:@"%@000",timeStamp];
    return str;
}


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
+(CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font string:(NSString*)string withSpacing:(CGFloat)spacing
{
    NSMutableParagraphStyle * paragraphSpaceStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphSpaceStyle setLineSpacing:spacing];
    NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphSpaceStyle};
    
    CGSize fitSize = [string boundingRectWithSize:size
                                          options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    
    return fitSize;
}


/**
 *  设置文字行间距
 *
 *  @param string   字符串
 *  @param font     字体大小
 *  @param spacing  间距大小
 *
 *  @return NSAttributedString
 */

+(NSAttributedString *)setLineSpacingWithString:(NSString *)string withFont:(CGFloat)font spacing:(CGFloat)spacing{
    if (string.length == 0) {
        string = @" ";
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, [string length])];
    
    return attributedString;
}

/**
 *  获得屏幕图像
 *
 *  @param theView view
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromView:(UIView *)theView
{
    //    UIGraphicsBeginImageContext(theView.frame.size);
    UIGraphicsBeginImageContextWithOptions(theView.frame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

//!!!!: 获得某个范围内的屏幕图像
/**
 *  获得某个范围内的屏幕图像
 *
 *  @param theView view
 *  @param r       坐标
 *
 *  @return       UIImage
 */
+ (UIImage *)imageFromView:(UIView *)theView atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}


/**
 *  提示框
 *
 *  @param message  提示内容
 *
 */
+ (void)showToastWithMessage:(NSString *)message{
    if (!message)return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:1.2];
}

+ (void)showToastWithImageName:(NSString *)imageName message:(NSString *)message{

    if (!message || !imageName) {
        
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 156, 50)];
    UIImageView *pictureImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    pictureImage.image = [UIImage imageNamed:imageName];
    [customView addSubview:pictureImage];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.text = message;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    [customView addSubview:titleLabel];
    
    
    [pictureImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.centerY.equalTo(customView.mas_centerY);
        
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(pictureImage.mas_right).offset(8);
        make.centerY.equalTo(pictureImage.mas_centerY);
        
    }];
    
    hud.customView = customView;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:1.2];

}



/**
 *  风火轮加载信息
 *
 *  @param targetView 对象
 *  @param msg        提示信息
 */
+ (void)showMBProgress:(UIView *)targetView message:(NSString *)msg{
    if (!targetView) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:targetView];
        progressHUD.mode = MBProgressHUDModeIndeterminate;
        [progressHUD show:YES];
        progressHUD.labelText = msg;
        [targetView addSubview:progressHUD];
    });
}


/**
 *  隐藏风火轮
 *
 *  @param targetView 对象
 */
+ (void)hideMBProgress:(UIView*)targetView{
    [MBProgressHUD hideHUDForView:targetView animated:YES];
}
/**
 *  判断第一次启动
 *
 *
 */
+ (BOOL)isFirstLaunch
{
    BOOL fistTimeOpen;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *storedAppVersion = [userDefaults objectForKey:DEF_StoredAppVersion];
    
    if (!storedAppVersion || ![storedAppVersion isEqualToString:DEF_APP_VERSION]) {
        fistTimeOpen = YES;
    } else {
        fistTimeOpen = NO;
    }
    [userDefaults setObject:DEF_APP_VERSION forKey:DEF_StoredAppVersion];
    [userDefaults synchronize];
    
    return fistTimeOpen;
}
/**
 返回字体的宽高
 **/
+(CGSize)getTextWith:(NSString *)text withFont:(NSInteger)font withWidth:(float)width withHeight:(float)height;
{
    CGSize stringSize ;
    CGSize size = CGSizeMake(width, height);
    if (text.length > 0) {
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        stringSize =[text
                      boundingRectWithSize:size
                      options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                      context:nil].size;
        
#else
        stringSize = [text sizeWithFont:[UIFont systemFontOfSize:font]
                      constrainedToSize:size
                          lineBreakMode:NSLineBreakByCharWrapping];
       
#endif
    }
    return stringSize;
}

/**
 *  修改字体颜色

 *
 *
 *  @param string       字符串
 *  @param font         字体大小
 *  @param textColor    字体颜色
 *
 *  @return             NSAttributedString
 */
+ (NSAttributedString *)getAttributedStringWithString:(NSString *)string font:(CGFloat)font textColor:(UIColor *)textColor{
    NSDictionary *textStyle = @{NSFontAttributeName: [UIFont systemFontOfSize:font], NSForegroundColorAttributeName:textColor};
    NSAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(string, nil) attributes:textStyle];
    
    return attributedString;
}

/**
 *  修改某个范围里面的字体颜色
 
 *
 *
 *  @param string       字符串
 *  @param font         字体大小
 *  @param textColor    字体颜色
 *  @param  range       修改字体的范围
 *  @return             NSAttributedString
 */

+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string  range:(NSRange)range font:(CGFloat)font textColor:(UIColor *)textColor{

    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *textStyle = @{NSFontAttributeName: [UIFont systemFontOfSize:font], NSForegroundColorAttributeName:textColor};
    [attributedStr addAttributes:textStyle range:range];
    
    return attributedStr;

}

+(void)showGifProgressViewInView:(UIView *)view{
    [JHUtility showGifProgressViewInView:view andOffsetValue:0];
}

+(void)showGifProgressViewInView:(UIView *)view andOffsetValue:(CGFloat)value{
    [JHUtility hiddenGifProgressViewInView:view];
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:view];
    progressHUD.mode = MBProgressHUDModeCustomView;
    progressHUD.color = [UIColor clearColor];
    
    CGFloat offsetValue = value > 0 ? value :value *-1;
    CGSize gifImageSize = [UIImage imageNamed:@"boss_loading_1"].size;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, gifImageSize.width, gifImageSize.height + offsetValue)];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 9; i++) {
        [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"boss_loading_%d",i]]];
    }
    CGRect frame = value > 0
    ? CGRectMake(0, 0, gifImageSize.width, gifImageSize.height)
    : CGRectMake(0,value * -1, gifImageSize.width, gifImageSize.height);
    
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:frame];
    imgV.animationImages = arr;
    imgV.animationDuration = arr.count*0.13;
    imgV.tag = 10000;
    [imgV startAnimating];
    [bgView addSubview:imgV];
    
    progressHUD.customView = bgView;
    [progressHUD show:YES];
    [view addSubview:progressHUD];
}

+(void)hiddenGifProgressViewInView:(UIView *)view
{
    UIImageView *imgV = (UIImageView *)[view viewWithTag:10000];
    if (imgV) {
        imgV.alpha = 0;
        [imgV removeFromSuperview];
    }
    [MBProgressHUD hideHUDForView:view animated:YES];
}

//获取系统版本号
+ (NSInteger)getSystemVersion{

    NSString *sysVersion = [UIDevice currentDevice].systemVersion;
    NSArray *sysArr = [sysVersion componentsSeparatedByString:@"."];
    
    NSInteger sysV = [sysArr[0] integerValue];
    return sysV;
}

@end
