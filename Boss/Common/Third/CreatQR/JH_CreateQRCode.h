//
//  JH_CreateQRCode.h
//  二维码生成
//
//  Created by jinghankeji on 2017/4/28.
//  Copyright © 2017年 com.baiduniang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JH_CreateQRCode : NSObject
//ContentString 生成二维码的字符串 imageName如果中间有图片传图片名 没有传nill
+(UIImage *)createQRCodeWithContentString:(NSString *)ContentString imageName:(NSString *)imageName;
@end
