//
//  JHBoss_GesturePasswordSettingViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_GesturePasswordSettingViewController.h"
#import "YLSwipeLockView.h"
#import "JHLoginState.h"
#import "JHBoss_GestureCodeSettingViewController.h"
#import "JHCRM_LoginViewController.h"

@interface JHBoss_GesturePasswordSettingViewController ()<YLSwipeLockViewDelegate>

@property (nonatomic, weak) YLSwipeLockView *lockView;
@property (nonatomic, weak) UILabel *tipLB;
@property (nonatomic, copy) NSString *passwordString;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UIButton *resetBtn;

@property (nonatomic, strong) UILabel *bottomLB;

@end

@implementation JHBoss_GesturePasswordSettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup
{
    @weakify(self);
    
    self.jhtitle = @"手势密码";
    self.navBar.backgroundColor = DEF_COLOR_333339;
    self.view.backgroundColor = DEF_COLOR_333339;
    
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
        if (pwdErrorCount <= 0) {
            [JHLoginState setLoginOuted];
            [JHLoginState cleanGesturePassword:nil];
            JHCRM_LoginViewController *loginVC = [[JHCRM_LoginViewController alloc] init];
            [self.navigationController pushViewController:loginVC animated:YES];
        } else {
            [self.lockView cleanNodesIfNeeded];
            self.passwordString = nil;
            self.tipLB.text = @"请设置您的新手势密码";
            self.tipView.hidden = YES;
        }
    }];
    
    if (_validateOver) {
        self.tipLB.text = @"请设置您的新手势密码";
    } else {
        if (pwdErrorCount <= 0) {
            self.tipLB.text = [NSString stringWithFormat:@"还有%zd次输入机会", pwdErrorCount];
            self.lockView.userInteractionEnabled = NO;
            self.tipView.hidden = NO;
            self.bottomLB.text = @"请通过短信方式重新设置手势密码";
            //清空手势密码
            [JHLoginState cleanGesturePassword:nil];
        } else {
            self.tipLB.text = @"请输入手势密码，以验证身份";
        }
    }
}

-(YLSwipeLockViewState)swipeView:(YLSwipeLockView *)swipeView didEndSwipeWithPassword:(NSString *)password
{
    if (!_validateOver) {
        if ([password isEqualToString:[JHLoginState getGesturePassword:nil]]) {
            [self.lockView cleanNodesIfNeeded];
            self.passwordString = nil;
            self.tipLB.text = @"请设置您的新手势密码";
            self.validateOver = YES;
            pwdErrorCount = PwdErrorMaxCount;
            JHBoss_GestureCodeSettingViewController *GCSettingVC = [[JHBoss_GestureCodeSettingViewController alloc] init];
            [self.navigationController pushViewController:GCSettingVC animated:YES];
            return YLSwipeLockViewStateNormal;
        } else {
            self.passwordString = nil;
            [self.lockView cleanNodesIfNeeded];
            pwdErrorCount --;
            self.tipLB.text = [NSString stringWithFormat:@"还有%zd次输入机会", pwdErrorCount];
            if(pwdErrorCount <= 0)
            {
                self.lockView.userInteractionEnabled = NO;
                self.tipView.hidden = NO;
                self.bottomLB.text = @"请通过短信方式重新设置手势密码";
                //清空手势密码
                [JHLoginState cleanGesturePassword:nil];
                return YLSwipeLockViewStateNormal;
            }
            return YLSwipeLockViewStateWarning;
        }
    } else {
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
            self.tipView.hidden = YES;
            pwdErrorCount = PwdErrorMaxCount;
            [JHLoginState saveGesturePassword:nil passWord:password];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            return YLSwipeLockViewStateSelected;
        }else{
            self.tipView.hidden = NO;
            return YLSwipeLockViewStateWarning;
        }
    }
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
        [_tipView addSubview:_bottomLB];
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

@end
