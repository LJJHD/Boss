//
//  JHBoss_PushAddressViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PushAddressViewController.h"
#import "JHBoss_SwitchTableViewCell.h"
#import "JHBoss_SwitchTextFieldTableViewCell.h"

@interface JHBoss_PushAddressViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *mailAddress; // 邮箱地址

@end

@implementation JHBoss_PushAddressViewController

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


#pragma mark - request

// 修改报表推送设置
- (void)requestSetReportPushSetting
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@([self.model.pushTargets[0] state]) forKey:@"appState"];
    [param setObject:@([self.model.pushTargets[1] state]) forKey:@"wxState"];
    [param setObject:@([self.model.pushTargets[2] state]) forKey:@"mailState"];
    [param setObject:self.mailAddress forKey:@"mailAddress"];
    
    [JHHttpRequest postRequestWithParams:param path:JH_SetReportPushSetting isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            ((JHBoss_PushTargetsSettingModel *)self.model.pushTargets[2]).address = self.mailAddress;
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}


#pragma mark - UI

- (void)setup
{
    self.jhtitle = @"推送至";
    
    [self.view addSubview:self.tableView];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
}


#pragma mark - tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"JHBoss_SwitchTextFieldTableViewCell";
    JHBoss_SwitchTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[JHBoss_SwitchTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    @weakify(self, cell);
    [cell.switchSW setOn:[self.model.pushTargets[indexPath.row] state] animated:YES];
    
    [[cell.switchSW rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISwitch *x) {
        @strongify(self, cell);
        if (self.mailAddress.length && ![self validateEmail:self.mailAddress]) {
            [JHUtility showToastWithMessage:@"请填写正确的邮箱号"];
            [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.25];
            return;
        }
        [self.model.pushTargets[indexPath.row] setState:x.on];
        if (indexPath.row == 2 && x.on) {
            [cell.descTF becomeFirstResponder];
        }
        [self requestSetReportPushSetting];
    }];
    
    switch (indexPath.row) {
        case 0:
            cell.title = @"APP";
            cell.enableTextField = NO;
            break;
        case 1:
            cell.title = @"微信";
            cell.descTitle = @"Mia6300";
            cell.enableTextField = NO;
            break;
        case 2:
        {
            cell.title = @"邮箱";
            cell.enableTextField = YES;
            cell.descTitle = [self.model.pushTargets[indexPath.row] address];
            [cell.descTF.rac_textSignal subscribeNext:^(NSString *x) {
                @strongify(self);
                self.mailAddress = x;
            }];
            cell.textFieldEndEditBlock = ^(NSString *text) {
                @strongify(self);
                if (self.mailAddress.length && ![self validateEmail:self.mailAddress]) {
                    [JHUtility showToastWithMessage:@"请填写正确的邮箱号"];
                    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.25];
                    return;
                }
                [self requestSetReportPushSetting];
            };
        }
            break;
            
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
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
        _tableView.allowsMultipleSelection = YES;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}


#pragma mark - other

- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    emailRegex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
