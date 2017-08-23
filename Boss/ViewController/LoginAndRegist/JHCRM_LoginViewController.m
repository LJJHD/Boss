//
//  JHCRM_LoginViewController.m
//  Boss
//
//  Created by 晶汉mac on 2017/3/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//
#import "JHCRM_ShowViewViewController.h"
#import "JHLoginState.h"
#import "JHUserInfoData.h"
#import "JHTabBarController.h"
#import "JHBaseNavigationController.h"
#import "JHLoginState.h"
#import "JHCRM_LoginViewController.h"
#import "JHBoss_GestureLoginViewController.h"
#import "UMMobClick/MobClick.h"
#import "JPUSHService.h"
@interface JHCRM_LoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;
@property (weak, nonatomic) IBOutlet UIView *phoneBgView;
@property (weak, nonatomic) IBOutlet UIView *passBgView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *yzmTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *yzmBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *warnLableBottomConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *logoImagV;
@property (weak, nonatomic) IBOutlet UILabel *warnLab;
@end

@implementation JHCRM_LoginViewController
-(instancetype)init{

   self = [super init];
    if (self) {
        
        self.loginBtn.titleLabel.textColor = DEF_COLOR_RGB_A(255, 255, 255,0.5);

    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
 
    [self setUI];
    
}
#pragma mark ---UI---
- (void)setUI{
    self.viewWidth.constant = DEF_WIDTH;
    
    self.viewHeight.constant = DEF_HEIGHT;
    
    self.phoneBgView.layer.cornerRadius = self.phoneBgView.height/2;
    self.phoneBgView.layer.masksToBounds = YES;
    
    self.passBgView.layer.cornerRadius = self.passBgView.height/2;
    self.passBgView.layer.masksToBounds = YES;
    
    self.yzmBtn.layer.cornerRadius = self.yzmBtn.height/2;
    self.yzmBtn.layer.masksToBounds = YES;
    self.mainScrollView.bounces = NO;
    self.navBar.hidden = YES;
    self.loginBtn.clipsToBounds = YES;
    self.loginBtn.titleLabel.textColor = DEF_COLOR_RGB_A(255, 255, 255,0.5);
    self.loginBtn.layer.cornerRadius = self.loginBtn.height/2;
    
    _logoTopConstraint.constant = MYDIMESCALEH(130);
    
    _warnLableBottomConstraint.constant = MYDIMESCALEH(100);
    
    self.phoneTF.inputAccessoryView = [[UIView alloc]init];
    self.yzmTF.inputAccessoryView = [[UIView alloc]init];
    @weakify(self);
    [self.phoneTF.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        if (text.length > 0) {
            
           self.loginBtn.titleLabel.textColor = DEF_COLOR_RGB_A(255, 255, 255,1);
        }else{
        
           self.loginBtn.titleLabel.textColor = DEF_COLOR_RGB_A(255, 255, 255,0.5);
        }
        
    }];
    
    
    JHUserInfoData *user = [[JHUserInfoData alloc]init];
    self.phoneTF.text = [user account];
}

- (void) viewWillAppear: (BOOL)animated {
    
    //打开键盘事件相应
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [MobClick beginLogPageView:@"登录"];
}

- (void) viewWillDisappear: (BOOL)animated {
    
    //关闭键盘事件相应
    
    [IQKeyboardManager sharedManager].enable = NO;
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登录"];
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
//    DPLog(@"height======%d",height);
    self.logoImagV.hidden = YES;
    self.warnLableBottomConstraint.constant = height + 15;
    
    [UIView animateWithDuration:0.6 animations:^{
        [self.view layoutIfNeeded];
    }];
     self.mainScrollView.scrollEnabled = NO;
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    self.mainScrollView.scrollEnabled = YES;
//     DPLog(@"键盘退出height======%d",height);
   self.warnLableBottomConstraint.constant = MYDIMESCALEH(100);

    [UIView animateWithDuration:0.4 animations:^{
        
        [self.view layoutIfNeeded];
        self.logoImagV.hidden = NO;
    } completion:^(BOOL finished) {
        
        
    }];

}


#pragma mark --- 按钮点击方法 ---
//登录
- (IBAction)loginClick:(id)sender {
    
    if (self.phoneTF.text.length <= 0) {
        
        [JHUtility showToastWithMessage:@"请输入手机号"];
        return;
    }else if (self.yzmTF.text.length <= 0){
    
        [JHUtility showToastWithMessage:@"请输入验证码"];
         return;
    }else if (self.phoneTF.text.length !=  11  ){
        
        [JHUtility showToastWithMessage:@"手机号格式不正确"];
         return;
    }
    
    [self.phoneTF resignFirstResponder];
    [self.yzmTF resignFirstResponder];
    
    //调用登录接口
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:_phoneTF.text forKey:@"account"];
    NSString *url;
    if (jH_Service_Environment == JH_Service_Environment_Test || jH_Service_Environment == JH_Service_Environment_Dev) {
        
         [parmDic setValue:_yzmTF.text  forKey:@"pwd"];
        url = JH_API_lOGINDv;
    }else{
        [parmDic setValue:_yzmTF.text  forKey:@"smsCode"];
        url = JH_API_lOGIN;
    }
    [JHUtility showGifProgressViewInView:self.view];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:url isShowLoading:YES isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        [JHUtility hiddenGifProgressViewInView:self.view];
        [JHUtility showToastWithMessage:dic[@"showMsg"]];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            NSMutableDictionary *saveDic = [NSMutableDictionary dictionary];
            [saveDic setValue:dic[@"token"] forKey:@"token"];
            [saveDic setValue:[dic[@"data"][@"userData"][@"merchantId"] stringValue] forKey:@"merchantId"];
            [saveDic setValue:[dic[@"data"][@"userData"][@"userDetail"][@"userId"] stringValue] forKey:@"accountId"];
            [saveDic setValue:dic[@"data"][@"userData"][@"userDetail"][@"userName"] forKey:@"userName"];
            [saveDic setValue:dic[@"data"][@"userData"][@"userDetail"][@"contactPhone"] forKey:@"account"];
            [saveDic setValue:[dic[@"data"][@"userData"][@"userType"] stringValue] forKey:@"userType"];
            [saveDic setValue:dic[@"data"][@"userData"][@"userDetail"][@"createTime"] forKey:@"createTime"];//商户注册时间

            [MobClick profileSignInWithPUID:[dic[@"data"][@"userData"][@"userDetail"][@"userId"] stringValue]];
            
            [JHLoginState setLogined];
            JHUserInfoData *userInfoData = [JHUserInfoData new];
            [userInfoData saveInfoWithData:saveDic identify:saveUserIdentify];
            //存储用户账号
            [userInfoData saveAccount:_phoneTF.text];
            
            //绑定UserID
            [JHBoss_UserWarpper shareInstance].userID = [dic[@"data"][@"userData"][@"userDetail"][@"userId"] stringValue];
           
            UIViewController *rootVc = nil;
            if ([JHLoginState isOpenGesturePassword:_phoneTF.text] == 2 ) {
                
                rootVc =  [[JHTabBarController alloc] init];
                
            }else if([JHLoginState isOpenGesturePassword:_phoneTF.text] == 1) {
            
                rootVc = [[JHTabBarController alloc]init];
            
            }else {
            
                rootVc = [[JHBoss_GestureLoginViewController alloc]init];
            }
            
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
           
            JHBaseNavigationController *nav= [[JHBaseNavigationController alloc]initWithRootViewController:rootVc];
            nav.navigationBarHidden = YES;
            window.rootViewController  = nav;
            
            [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
                
                DPLog(@"registrationID====%@",registrationID);
                [self uploadRegistrationId:registrationID];
            }];
            
        }
        
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
        [JHUtility hiddenGifProgressViewInView:self.view];
        
    }];
}


//获取验证码
- (IBAction)getYZM:(UIButton *)sender {
   
    if (self.phoneTF.text.length !=  11) {
        
        [JHUtility showToastWithMessage:@"手机号格式不正确"];
        return;
    }
     sender.userInteractionEnabled = NO;
    [self getverificationCode];
    //      计时
    __block int timeout = 59;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer    = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (timeout<=0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                sender.userInteractionEnabled = YES;
                sender.selected = NO;
//                [self settingBtn:_getCodeBtn];
            });
            
        }else{
            int seconds = timeout%60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [sender setTitle:[NSString stringWithFormat:@"已发送%@s",strTime] forState:UIControlStateNormal];
                
                [UIView commitAnimations];
                
            });
            timeout -- ;
        }
    });
    dispatch_resume(timer);

}

//获取验证码
-(void)getverificationCode{
    
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic  setValue:self.phoneTF.text forKey:@"phone"];
    [parmDic setValue:@"1" forKey:@"type"];
    [parmDic setValue:@"110" forKey:@"childType"];
    [parmDic setValue:@"短信登录" forKey:@"context"];
   
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:jh_API_getVerificationCode isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
//        if ((int)dic[@"code"] == 1) {
        
             [JHUtility showToastWithMessage:dic[@"showMsg"]];
//        }
        
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
        //测试
        
    }];
    
}

//上传 registrationId 给后台用于推送
-(void)uploadRegistrationId:(NSString *)registrationId{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:registrationId forKey:@"registrationId"];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_UploadRegistrationid isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (isObjNotEmpty(dic[@"data"])) {
                
                
            }
        }
        
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        
        if (errorState == JH_HttpRequestFailState_NetworkBreak) {
            
        }
    }];
}




@end
