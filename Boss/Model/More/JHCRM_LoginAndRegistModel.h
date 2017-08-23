//
//  JHCRM_LoginAndRegistModel.h
//  Boss
//
//  Created by 晶汉mac on 2017/3/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    
    TextFieldKeyTypeNumber = 1,//数字
    
    TextFieldKeyTypeNormal ,//正常
    
} JHTextFileKeyType;


@interface JHCRM_LoginAndRegistModel : NSObject
@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *textFieldStr;
@property (nonatomic,strong) NSString *placeStr;
@property (nonatomic,strong) NSString *codeStr;
@property (nonatomic,assign) JHTextFileKeyType keyType;
@end
