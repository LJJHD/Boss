//
//  JHBoss_GestureLoginViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/16.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_GestureLoginViewController.h"
#import "YLSwipeLockView.h"
#import "JHLoginState.h"
#import "JHUserInfoData.h"
#import "JHBoss_GesturePasswordSuccessViewController.h"
#import "JHTabBarController.h"
#import "JHBaseNavigationController.h"
#import "JHCRM_LoginViewController.h"
@interface JHBoss_GestureLoginViewController ()<YLSwipeLockViewDelegate>
@property (nonatomic, weak) YLSwipeLockView *lockView;
@property (nonatomic, weak) UILabel *tipLB;
@property (nonatomic, copy) NSString *passwordString;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UILabel *bottomLB;//密码手势错误4次 弹出的tipview上面的提示语

@property (nonatomic, assign) int gestureStaute;//手势密码设置状态
@property (nonatomic, strong) NSString *account;
@property (nonatomic, assign) int gestureCount;//手势密码输入次数
@property (nonatomic, strong) NSString *gesturePwd;//手势密码

@property (nonatomic, strong) UIView *maskView;//遮盖手势密码的view
@end

@implementation JHBoss_GestureLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    JHUserInfoData *userInfoData = [JHUserInfoData new];
    _account = [userInfoData account];
    _gestureCount = 1;
    _gesturePwd = [JHLoginState getGesturePassword:_account];
    [self setup];
}

- (void)setup
{
    @weakify(self);
    
    JHUserInfoData *userInfoData = [JHUserInfoData new];
    NSString *accountStr = [userInfoData account];
    _gestureStaute = [JHLoginState isOpenGesturePassword:accountStr];
    
    self.navBar.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = DEF_COLOR_333339;
    
    UIImageView *backImageView = [UIImageView new];
    backImageView.image = DEF_IMAGENAME(@"0.3_bg_bg");
    [self.view addSubview:backImageView];
    
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.bottom.mas_equalTo(0);
    }];
    
    
    CGFloat viewWidth = self.view.bounds.size.width - 40;
    CGFloat viewHeight = viewWidth;
    
    YLSwipeLockView *lockView = [[YLSwipeLockView alloc] init];
    self.lockView = lockView;
    self.lockView.delegate = self;
    [self.view addSubview:lockView];
    [self.lockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(44);
        make.size.mas_equalTo(CGSizeMake(viewWidth, viewHeight));
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    titleLabel.font = DEF_SET_FONT(15);
    self.tipLB = titleLabel;
    [self.view addSubview:titleLabel];
    [self.tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.lockView.mas_top).with.offset(-84);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.tipView];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(120);
    }];
    
    [[self.resetBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        if (_gestureCount >= 5  && _gestureStaute == 2) {
            
            //清空手势密码
            [JHLoginState cleanGesturePassword:_account];
            //退出登录，
            [JHLoginState setLoginOuted];
            
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            JHCRM_LoginViewController * rootVc = [[JHCRM_LoginViewController alloc]init];
            JHBaseNavigationController *nav= [[JHBaseNavigationController alloc]initWithRootViewController:rootVc];
            nav.navigationBarHidden = YES;
            window.rootViewController  = nav;
            
        }else{
        
            [self.lockView cleanNodesIfNeeded];
            self.passwordString = nil;
            self.tipLB.text = @"请设置您的新手势密码";
            self.tipView.hidden = YES;
        
        }
    }];
    
    
    if (_gestureStaute == 2 ) {
        
        self.jhtitle = @"手势密码";
        titleLabel.text = @"请输入手势密码，以验证身份";
        
        
    }else if(_gestureStaute == 1) {
        
       
    }else if(_gestureStaute == 3) {
        
        titleLabel.text = @"请重新设置手势密码\n连接至少四个点";
        self.leftNavButton.hidden = YES;
        
    }else {
        
        titleLabel.text = @"初次登录，请设置手势密码\n连接至少四个点";
        self.leftNavButton.hidden = YES;

       
    }

}


-(YLSwipeLockViewState)swipeView:(YLSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password
{
    
    if (_gestureStaute == 2 ) {
        
        BOOL isSucc = false;
        switch (_gestureCount) {
            case 1:{
                isSucc =  [self judgeGesturePwd:password];
                break;
            }
            case 2:{
                isSucc =   [self judgeGesturePwd:password];
                break;
            }
            case 3:{
                isSucc =  [self judgeGesturePwd:password];
                break;
            }
            case 4:{
                isSucc =   [self judgeGesturePwd:password];
                break;
            }
            case 5:{
                isSucc =   [self judgeGesturePwd:password];
                if (!isSucc) {
                    self.tipView.hidden = NO;
                    _bottomLB.text = @"请通过短信方式重新设置手势密码";
                    
                    //清空手势密码
                    [JHLoginState cleanGesturePassword:_account];
                    //退出登录，
                    [JHLoginState setLoginOuted];
                }
                break;
            }
        }
        _gestureCount ++;
        
        if (_gestureCount > 5) {
            
            [self.view addSubview:self.maskView];
            
            @weakify(self);
            [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.right.and.top.mas_equalTo(0);
                make.bottom.equalTo(self.tipView.mas_top);
                
            }];
            [swipeView cleanNodesIfNeeded];
            return YLSwipeLockViewStateNormal;
        }

       
        if (isSucc) {
            return YLSwipeLockViewStateSelected;
        }else{
            return YLSwipeLockViewStateWarning;
        }
    }else if(_gestureStaute == 1) {
        
        
    }else if(_gestureStaute == 3) {
        
        if (self.passwordString == nil) {
            if (password.length < 4) {
                self.tipLB.text = @"请至少连接四个点";
                return YLSwipeLockViewStateWarning;
            }
            self.passwordString = password;
            self.tipLB.text = @"再次输入手势密码";
            return YLSwipeLockViewStateNormal;
        }else if ([self.passwordString isEqualToString:password]){
            self.tipLB.text = @"设置成功";
            self.passwordString = nil;
            pwdErrorCount = PwdErrorMaxCount;
            
            [JHLoginState setGesturePassword:_account];
            [JHLoginState saveGesturePassword:_account passWord:password];
            
            
            JHBoss_GesturePasswordSuccessViewController *succ = [[JHBoss_GesturePasswordSuccessViewController
                                                                  alloc]init];
            [self presentViewController:succ animated:YES completion:nil];
            
            return YLSwipeLockViewStateSelected;
        }else{
            self.tipView.hidden = NO;
            return YLSwipeLockViewStateWarning;
        }
        
        
    }else {
        
        if (self.passwordString == nil) {
            if (password.length < 4) {
                self.tipLB.text = @"请至少连接四个点";
                return YLSwipeLockViewStateWarning;
            }
            self.passwordString = password;
            self.tipLB.text = @"再次输入手势密码";
            return YLSwipeLockViewStateNormal;
        }else if ([self.passwordString isEqualToString:password]){
            self.tipLB.text = @"设置成功";
            self.passwordString = nil;
            pwdErrorCount = PwdErrorMaxCount;
            
            [JHLoginState setGesturePassword:_account];
            [JHLoginState saveGesturePassword:_account passWord:password];
            
            JHBoss_GesturePasswordSuccessViewController *succ = [[JHBoss_GesturePasswordSuccessViewController
                                                                  alloc]init];
            [self presentViewController:succ animated:YES completion:nil];
            
            return YLSwipeLockViewStateSelected;
        }else{
            self.tipView.hidden = NO;
            return YLSwipeLockViewStateWarning;
        }
        
    }
    
    
    return YLSwipeLockViewStateNormal;
}


//判断手势密码是否正确
-(BOOL)judgeGesturePwd:(NSString *)pwd{


    if ([pwd isEqualToString:_gesturePwd]) {
        
        
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        JHTabBarController * rootVc = [[JHTabBarController alloc]init];
        JHBaseNavigationController *nav= [[JHBaseNavigationController alloc]initWithRootViewController:rootVc];
        nav.navigationBarHidden = YES;
        window.rootViewController  = nav;
        return YES;
    }else{
        
         self.tipLB.text = [NSString stringWithFormat:@"还有%d次输入机会", 5 - _gestureCount];
        
        return NO;
    }

    return nil;
}



- (UIView *)tipView
{
    if (!_tipView) {
        _tipView = [[UIView alloc] init];
        _tipView.hidden = YES;
        _tipView.backgroundColor = [UIColor whiteColor];
        
        UILabel *topLB = [[UILabel alloc] init];
        topLB.font = DEF_SET_FONT(15);
        topLB.textColor = DEF_COLOR_333339;
        topLB.text = @"温馨提示";
        [_tipView addSubview:topLB];
        [topLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.centerX.mas_equalTo(0);
        }];
        
        UILabel *bottomLB = [[UILabel alloc] init];
        bottomLB.font = DEF_SET_FONT(13);
        bottomLB.textColor = DEF_COLOR_333339;
        bottomLB.text = @"两次输入不一致";
        _bottomLB = bottomLB;
        [_tipView addSubview:bottomLB];
        [bottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(40);
            make.centerX.mas_equalTo(0);
        }];
        
        [_tipView addSubview:self.resetBtn];
        [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(67);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(150, 33));
        }];
    }
    return _tipView;
}

- (UIButton *)resetBtn
{
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetBtn.titleLabel.font = DEF_SET_FONT(16);
        _resetBtn.titleLabel.textColor = [UIColor whiteColor];
        _resetBtn.backgroundColor = DEF_COLOR_FF4747;
        _resetBtn.layer.cornerRadius = 16.5;
        _resetBtn.layer.masksToBounds = YES;
        [_resetBtn setTitle:@"重新设置"];
    }
    return _resetBtn;
}
//5次密码输入错误后遮盖手势密码不让输入
-(UIView *)maskView{

    if (!_maskView) {
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = [UIColor clearColor];
       
    }

    return _maskView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
