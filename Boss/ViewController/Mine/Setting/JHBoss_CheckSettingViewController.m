//
//  JHBoss_CheckSettingViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_CheckSettingViewController.h"
#import "JHBoss_SwitchTableViewCell.h"
#import "JHBoss_CheckSettingModel.h"

@interface JHBoss_CheckSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHBoss_CheckSettingModel *model;

@end

@implementation JHBoss_CheckSettingViewController

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
    [self requestReviewSettingDetail];
    [self setup];
}

- (void)setup
{
    self.jhtitle = @"审核设置";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
}


#pragma mark - request

// 获取审核设置详情
- (void)requestReviewSettingDetail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [JHHttpRequest postRequestWithParams:param path:JH_ReviewSettingDetail isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            self.model = [JHBoss_CheckSettingModel mj_objectWithKeyValues:dic[@"data"]];
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

// 修改审核设置详情
- (void)requestChangeReviewSetting
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(self.model.employeeLeave) forKey:@"employeeLeave"];
    [param setObject:@(self.model.bill) forKey:@"bill"];
    [param setObject:@(self.model.free) forKey:@"free"];
    
    [JHHttpRequest postRequestWithParams:param path:JH_ChangeReviewSetting isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
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
    static NSString *reuseId = @"JHBoss_SwitchTableViewCell";
    JHBoss_SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[JHBoss_SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showTipBtn = NO;
    }
    @weakify(self);
    switch (indexPath.row) {
        case 0:
        {
            cell.title = @"员工请假申请";
            cell.switchSW.on = self.model.employeeLeave;
            [[[cell.switchSW rac_newOnChannel] distinctUntilChanged] subscribeNext:^(id x) {
                @strongify(self);
                self.model.employeeLeave = [x boolValue];
                [self requestChangeReviewSetting];
            }];
        }
            break;
        case 1:
        {
            cell.title = @"挂帐申请";
            cell.switchSW.on = self.model.bill;
            [[[cell.switchSW rac_newOnChannel] distinctUntilChanged] subscribeNext:^(id x) {
                @strongify(self);
                self.model.bill = [x boolValue];
                [self requestChangeReviewSetting];
            }];
        }
            break;
        case 2:
        {
            cell.title = @"免单申请";
            cell.switchSW.on = self.model.free;
            [[[cell.switchSW rac_newOnChannel] distinctUntilChanged] subscribeNext:^(id x) {
                @strongify(self);
                self.model.free = [x boolValue];
                [self requestChangeReviewSetting];
            }];
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
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}

@end
