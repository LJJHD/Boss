//
//  JHBoss_GestureCodeSettingViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_GestureCodeSettingViewController.h"
#import "JHBoss_PersonalCenterTableViewCell.h"
#import "JHBoss_SwitchTableViewCell.h"
#import "JHBoss_GesturePasswordSettingViewController.h"
#import "JHLoginState.h"
#import "JHUserInfoData.h"
#import "JHBoss_SettingViewController.h"

@interface JHBoss_GestureCodeSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JHBoss_GestureCodeSettingViewController

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
    self.jhtitle = @"手势密码设置";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.row) {
        static NSString *reuseId = @"JHBoss_SwitchTableViewCell";
        JHBoss_SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell) {
            cell = [[JHBoss_SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.title = @"手势密码开关";
        cell.switchSW.on = [JHLoginState isOpenGesturePassword:nil] == 2;
        cell.switchHandler = ^(UISwitch *sender) {
            
            if (sender.on) {
                
                [JHLoginState setGesturePassword:@""];
                
            }else{
                
                [JHLoginState closeGesturePassword:@""];
                
            }
        };
        
        return cell;
    } else {
        static NSString *reuseId = @"JHBoss_PersonalCenterTableViewCell";
        JHBoss_PersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell) {
            cell = [[JHBoss_PersonalCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.showIndicate = YES;
        }
        cell.title = @"修改手势密码";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row) {
        JHBoss_GesturePasswordSettingViewController *gesturePasswordSettingVC = [[JHBoss_GesturePasswordSettingViewController alloc] init];
        gesturePasswordSettingVC.validateOver = YES;
        [self.navigationController pushViewController:gesturePasswordSettingVC animated:YES];
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

- (void)onClickLeftNavButton:(UIButton *)leftNavButton
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
}

@end
