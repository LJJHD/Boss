//
//  JHCRM_ShowViewViewController.m
//  Boss
//
//  Created by 晶汉mac on 2017/3/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHCRM_ShowViewViewController.h"
#define CUSTONVIEWSALCE (272/302.0)
#define SELFWIDTH      (DEF_WIDTH-100)
@interface JHCRM_ShowViewViewController ()
/**输入弹框**/
@property (nonatomic,strong) UITextField  *inputTF;
@property (nonatomic,strong) UIButton     *addBtn;
/****/

@end

@implementation JHCRM_ShowViewViewController
- (instancetype)initWithViewType:(NSInteger)viewType
{
    if (self = [super init]) {
        self.viewType = viewType;
//        if (viewType==ShowViewCustomType||viewType==ShowViewCommitSuccessType||viewType==ShowViewCommitFialType)
//        {
            if (DEF_HEIGHT<667) {
                
                self.contentSizeInPopup = CGSizeMake((DEF_WIDTH-80), (DEF_WIDTH-80)/CUSTONVIEWSALCE);
            }else
            {
                
                self.contentSizeInPopup = CGSizeMake(SELFWIDTH, SELFWIDTH/CUSTONVIEWSALCE);
            }
  
//        }
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navBar.hidden = YES;
    
    self.popupController.containerView.backgroundColor = [UIColor clearColor];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    if (self.viewType == ShowViewCommitSuccessType)
    {
        [self commitSuccessView];
        
    }else if (self.viewType == ShowViewCommitFialType)
    {
        [self creatCustomViewWithImageName:@"image_home_popup_certification_fail" withWarningStr:@"资料认证失败哦" withBtnTitle:@"重新提交资料" withIsMore:NO];
        
    }else if(self.viewType == ShowViewCustomType)
    {
        [self creatCustomViewWithImageName:@"image_login_fail_popup" withWarningStr:@"手机号已验证" withBtnTitle:@"去完善资料" withIsMore:YES];
        
    }else
    {
        [self creatInputView];
    }

}
/**创建输入视图**/
- (void)creatInputView
{
    UILabel *label =[[UILabel alloc] init];
    label.textColor = DEF_COLOR_RGB(120, 120, 120);
    label.font = [UIFont systemFontOfSize:17];
    label.text = self.inputTitleStr;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.centerX.mas_equalTo(0);
        
    }];
    
    self.inputTF = [[UITextField alloc] init];
    self.inputTF.textAlignment = NSTextAlignmentCenter;
    self.inputTF.font = [UIFont systemFontOfSize:15];
    self.inputTF.textColor = DEF_COLOR_RGB(40, 40, 40);
    [self.view addSubview:self.inputTF];
    [self.inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(label.mas_bottom).offset(30);
        make.height.mas_equalTo(25);
        make.leading.mas_equalTo(5);
        make.trailing.mas_equalTo(-5);
        
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = DEF_COLOR_RGB(220, 220, 220);
    [self.view addSubview:lineView];
    @weakify(self);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(self.inputTF.mas_bottom).offset(3);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(96);
        make.height.mas_equalTo(1);
    }];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setTitle:@"添加"];
    [self.addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.addBtn.backgroundColor = [DEF_COLOR_RGB(73,144, 226) colorWithAlphaComponent:0.5];
    self.addBtn.clipsToBounds = YES;
    self.addBtn.layer.cornerRadius = 4;
    [self.view addSubview:self.addBtn];
    [self.addBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(lineView.mas_bottom).offset(30);
        make.leading.mas_equalTo(25);
        make.trailing.mas_equalTo(-25);
        make.height.mas_equalTo(40);
    }];

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:view atIndex:0];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(self.addBtn.mas_bottom).offset(40);
        
    }];
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 8;
    
    UIButton *dissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dissBtn setImage:[UIImage imageNamed:@"icon_login_fail_popup_close"] forState:UIControlStateNormal];
    [view addSubview:dissBtn];
    [dissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.trailing.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [dissBtn addTarget:self action:@selector(disMissClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];

    [self changeContentSizeInPopupWihtView:view withSp:0];
   
    [self.inputTF.rac_textSignal subscribeNext:^(id x){
        @strongify(self);
        NSLog(@"%@",x);//这里的X就是文本框的文字
        [self textChange:self.inputTF];
    }];
}
/**提交资料成功**/
- (void)commitSuccessView
{
 
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.view addSubview:iconImageView];
    UIImage *image = [UIImage imageNamed:@"image_home_popup_re-certification_success"];
    iconImageView.image = image;
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.view);
        
    }];
    
    UILabel *label =[[UILabel alloc] init];
    label.textColor = DEF_COLOR_RGB(90, 90, 90);
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"提交成功";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImageView.mas_bottom).offset(25);
        make.centerX.mas_equalTo(0);
        
    }];
    
    UILabel *warninglabel =[[UILabel alloc] init];
    warninglabel.textColor = DEF_COLOR_RGB(160, 160, 160);
    warninglabel.font = [UIFont systemFontOfSize:15];
    warninglabel.text = @"我们会在3个工作日内审核您公司资料，请耐心等待";
    warninglabel.numberOfLines = 0;
     warninglabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:warninglabel];
    [warninglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label.mas_bottom).offset(19);
        make.leading.mas_equalTo(25);
        make.trailing.mas_equalTo(-25);
        make.centerX.mas_equalTo(0);
        
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"好的"];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:DEF_COLOR_RGB(14, 180, 114)];
    sureBtn.clipsToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(warninglabel.mas_bottom).offset(30);
        make.leading.mas_equalTo(25);
        make.trailing.mas_equalTo(-25);
        make.height.mas_equalTo(40);
    }];
    [sureBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:view atIndex:0];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(iconImageView.mas_centerY);
        make.leading.mas_equalTo(0);
        make.trailing.mas_equalTo(0);
        make.bottom.mas_equalTo(sureBtn.mas_bottom).offset(30);
        
    }];
    
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 8;
    
    [self changeContentSizeInPopupWihtView:view withSp:0];

}
//**创建登录提交资料弹框,和资料认证失败**/
- (void)creatCustomViewWithImageName:(NSString*)imageName withWarningStr:(NSString*)warningStr withBtnTitle:(NSString*)btnTitle withIsMore:(BOOL)isMore

{
   
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [self.view addSubview:iconImageView];
    UIImage *image = [UIImage imageNamed:imageName];
    iconImageView.image = image;
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.view).offset(30);
        
    }];
    
    UILabel *label =[[UILabel alloc] init];
    label.textColor = DEF_COLOR_RGB(90, 90, 90);
    label.font = [UIFont systemFontOfSize:15];
    label.text = warningStr;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(iconImageView.mas_bottom).offset(25);
        make.centerX.mas_equalTo(0);
        
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:btnTitle];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:DEF_COLOR_RGB(14, 180, 114)];
    sureBtn.clipsToBounds = YES;
    sureBtn.layer.cornerRadius = 4;
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(label.mas_bottom).offset(30);
        make.leading.mas_equalTo(25);
        make.trailing.mas_equalTo(-25);
        make.height.mas_equalTo(40);
    }];
     [sureBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:view atIndex:0];
   
    if (isMore)
    {
        UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetBtn setTitle:@"忘记密码？"];
        forgetBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [forgetBtn setTitleColor:DEF_COLOR_RGB(180, 180, 180) forState:UIControlStateNormal];
        [self.view addSubview:forgetBtn];
         [forgetBtn addTarget:self action:@selector(forgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(sureBtn.mas_bottom).offset(12);
            make.leading.mas_equalTo(25);
            make.trailing.mas_equalTo(-25);
            make.height.mas_equalTo(30);
        }];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(0);
            make.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(forgetBtn.mas_bottom).offset(15);
            
        }];
    }else
    {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(0);
            make.leading.mas_equalTo(0);
            make.trailing.mas_equalTo(0);
            make.bottom.mas_equalTo(sureBtn.mas_bottom).offset(30);
            
        }];
    }
   

    view.clipsToBounds = YES;
    view.layer.cornerRadius = 8;
    
    UIButton *dissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [dissBtn setImage:[UIImage imageNamed:@"icon_login_fail_popup_close"] forState:UIControlStateNormal];
    [view addSubview:dissBtn];
    [dissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.trailing.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [dissBtn addTarget:self action:@selector(disMissClick) forControlEvents:UIControlEventTouchUpInside];
 
    [self changeContentSizeInPopupWihtView:view withSp:30];
}
#pragma mark --- textChange ---
- (void)textChange:(UITextField*)textField
{
    if (isObjNotEmpty(textField.text)) {
        self.addBtn.backgroundColor = DEF_COLOR_RGB(73,144, 226);
    }else{
        self.addBtn.backgroundColor = [DEF_COLOR_RGB(73,144, 226) colorWithAlphaComponent:0.5];
    }
}
#pragma mark ---修改视图的contentSizeInPopup ---
- (void)changeContentSizeInPopupWihtView:(UIView*)view withSp:(CGFloat)sp
{
    [self.view setNeedsLayout];
    
    [self.view layoutIfNeeded];
    
    if (DEF_HEIGHT<667) {
        
        self.contentSizeInPopup = CGSizeMake((DEF_WIDTH-80), CGRectGetMaxY(view.frame)+sp);
    }else
    {
        
        self.contentSizeInPopup = CGSizeMake(SELFWIDTH, CGRectGetMaxY(view.frame)+sp);
    }

}
#pragma mark --- 按钮点击方法 ---
//几个弹出视图按钮方法用一个方法：并且代理也是一个代理，根据不同的type去判断执行什么操作
- (void)btnClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(showView:with:)]) {
        if (self.viewType == ShowViewInputType) {
          [self.delegate showView:self with:self.inputTF.text];
        }else{
            [self.delegate showView:self with:nil];

        }
        
    }
}
//忘记密码按钮点击方法，单独代理方法
- (void)forgetBtnClick:(UIButton*)sender
{
    if ([self.delegate respondsToSelector:@selector(forgetPassWordShowView:with:)]) {
        [self.delegate forgetPassWordShowView:self with:nil];
    }
}
- (void)disMissClick
{
    [self.popupController dismiss];
}

@end
