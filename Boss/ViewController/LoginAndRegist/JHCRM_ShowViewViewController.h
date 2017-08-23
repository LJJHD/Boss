//
//  JHCRM_ShowViewViewController.h
//  Boss
//
//  Created by 晶汉mac on 2017/3/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <STPopup/STPopup.h>
/**
 crm目前所有非系统的弹框（至少3月16所有ui显示的，以后如有请避开这个，自行创建新的视图）
 其中包括这几个弹框：
 1 提交认证资料成功弹框
 2 认证资料成功
 3 资料认证失败
 4 添加商品
 如有其他，请自己再重新创建新的类
 所有权归李
 **/
typedef enum : NSUInteger {

    /**提交认证资料成功弹框**/
    ShowViewCustomType = 1,
    
     /**认证资料成功**/
    ShowViewCommitSuccessType,
    
     /**资料认证失败**/
    ShowViewCommitFialType,
    
    /**添加商品**/
    ShowViewInputType,
    
} ShowViewType;

@class JHCRM_ShowViewViewController;

@protocol JHCRM_ShowViewViewControllerDelegate <NSObject>
@optional
/**
 按钮点击代理
 parma 扩展参数
 **/
- (void)showView:(JHCRM_ShowViewViewController*)showVC with:(id)parma;

/**
 点击忘记密码代理
parma 扩展参数
 **/
- (void)forgetPassWordShowView:(JHCRM_ShowViewViewController*)showVC with:(id)parma;

@end

@interface JHCRM_ShowViewViewController : UIViewController
/**输入弹出视图的title**/
@property (nonatomic,strong) NSString     *inputTitleStr;
/**视图类型**/
@property (nonatomic,assign) ShowViewType viewType;

- (instancetype)initWithViewType:(NSInteger)viewType;

@property (nonatomic,weak) id       delegate;


@end
