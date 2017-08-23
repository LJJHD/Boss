//
//  JHBoss_AbnormalReminderViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_AbnormalReminderViewController.h"
#import "JHBoss_PersonalCenterTableViewCell.h"
#import "JHBoss_SwitchTableViewCell.h"
#import "JHBoss_AbnormalPercentViewController.h"

@interface JHBoss_AbnormalReminderViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JHBoss_AbnormalReminderViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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

// 设置异常提醒
- (void)requestSetExceptional
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.dataId forKey:@"dataId"];
    [param setObject:@(self.model.state) forKey:@"state"];
    [param setObject:self.model.compare forKey:@"compare"];
    
    [JHHttpRequest postRequestWithParams:param path:JH_SetExceptional isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}


#pragma mark - UI

- (void)setup
{
    self.jhtitle = @"异常提醒设置";
    
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
    @weakify(self);
    if (!indexPath.row) {
        static NSString *reuseId = @"JHBoss_SwitchTableViewCell";
        JHBoss_SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell) {
            cell = [[JHBoss_SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.title = @"异常提醒";
        cell.switchSW.on = self.model.state;
        [[[cell.switchSW rac_newOnChannel] distinctUntilChanged] subscribeNext:^(id x) {
            @strongify(self);
            self.model.state = [x boolValue];
            [self requestSetExceptional];
        }];
        return cell;
    } else {
        static NSString *reuseId = @"JHBoss_PersonalCenterTableViewCell";
        JHBoss_PersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell) {
            cell = [[JHBoss_PersonalCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.showIndicate = YES;
        }
        cell.title = @"该数值与同期相比差异大于";
        cell.descTitle = [NSString stringWithFormat:@"%g%%", self.model.compare.doubleValue * 100];
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
        JHBoss_AbnormalPercentViewController *abnormalPercentVC = [[JHBoss_AbnormalPercentViewController alloc] init];
        abnormalPercentVC.model = self.model;
        abnormalPercentVC.dataId = self.dataId;
        [self.navigationController pushViewController:abnormalPercentVC animated:YES];
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

@end
