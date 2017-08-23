//
//  JH_CustomTextView.h
//  JinghanLife
//
//  Created by jinghankeji on 2017/3/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JH_CustomTextView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *residueCharacterLabel;
@property (nonatomic, copy) NSString *placeHolder;//占位字符
@property (nonatomic, assign) int maxNumber;//总字数

@end
