//
//  JHBoss_SettingViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_SettingViewController.h"
#import "JHBoss_PersonalCenterTableViewCell.h"
#import "JHBoss_GestureCodeSettingViewController.h"
#import "JHBoss_RemindSettingViewController.h"
#import "JHBoss_CheckSettingViewController.h"
#import "JHBoss_ReportFormsPushViewController.h"
#import "JHBoss_NoDisturbModeViewController.h"
#import "JHLoginState.h"
#import "JHCRM_LoginViewController.h"
#import "JHBoss_GesturePasswordSettingViewController.h"
#import "JHUserInfoData.h"
#import "JHBaseNavigationController.h"
@interface JHBoss_SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *logoutBtn;
@end

@implementation JHBoss_SettingViewController

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
    
    self.jhtitle = @"设置";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
    
    [self.view addSubview:self.logoutBtn];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(37.5);
        make.right.mas_equalTo(-37.5);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-50);
    }];
}

#pragma mark - tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  section ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"JHBoss_PersonalCenterTableViewCell";
    JHBoss_PersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[JHBoss_PersonalCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showIndicate = YES;
    }
    switch (indexPath.section  + indexPath.row) {
        case 0:
            cell.title = @"提醒设置";
            break;
        case 1:
            cell.title = @"手势密码";
            break;
        case 2:
            cell.title = @"勿扰模式";
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section  + indexPath.row) {
        case 0:
        {
            JHBoss_RemindSettingViewController *remindSettingVC = [[JHBoss_RemindSettingViewController alloc] init];
            [self.navigationController pushViewController:remindSettingVC animated:YES];
        }
            break;
        case 1:
        {
            JHBoss_GesturePasswordSettingViewController *GPSettingVC = [[JHBoss_GesturePasswordSettingViewController alloc] init];
            [self.navigationController pushViewController:GPSettingVC animated:YES];
        }
            break;
        case 2:
        {
            JHBoss_NoDisturbModeViewController *noDisturbModeVC = [[JHBoss_NoDisturbModeViewController alloc] init];
            [self.navigationController pushViewController:noDisturbModeVC animated:YES];
        }
            break;
       
            
        default:
            break;
    }
}


#pragma mark - setter/getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 50;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}

- (UIButton *)logoutBtn
{
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutBtn.titleLabel.font = DEF_SET_FONT(17);
        _logoutBtn.titleLabel.textColor = [UIColor whiteColor];
        _logoutBtn.backgroundColor = DEF_COLOR_CDA265;
        _logoutBtn.layer.cornerRadius = 20;
        _logoutBtn.layer.masksToBounds = YES;
        [_logoutBtn setTitle:@"退出登录"];
        
        @weakify(self);
        [[_logoutBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认退出" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertView show];
            [[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
                if ([x integerValue] == 1) {
                    
                    [self quitLogin];
                   
                }
            }];
        }];
    }
    return _logoutBtn;
}

//退出登录
-(void)quitLogin{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    
    
    [JHUtility showGifProgressViewInView:self.view];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_API_quiteLogin isShowLoading:NO isNeedCache:NO success:^(id object) {
        [JHUtility hiddenGifProgressViewInView:self.view];
        @strongify(self);
        NSDictionary *dic = object;
        [JHUtility showToastWithMessage:dic[@"showMsg"]];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            JHUserInfoData *infoData = [[JHUserInfoData alloc]init];
            [infoData removeInfoIdentify:saveUserIdentify];
            
            [JHLoginState setLoginOuted];
        
            JHCRM_LoginViewController *loginVC = [[JHCRM_LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];

        }
        
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];
        //测试
        
    }];
    
}



@end
