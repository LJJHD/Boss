//
//  JHBoss_ReportFormsPushViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ReportFormsPushViewController.h"
#import "JHBoss_SwitchTableViewCell.h"
#import "JHBoss_PersonalCenterTableViewCell.h"
#import "JHBoss_SubscribeFormsViewController.h"
#import "JHBoss_PushAddressViewController.h"
#import "JHBoss_PushSettingModel.h"
#import "HCGDatePickerAppearance.h"

@interface JHBoss_ReportFormsPushViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHBoss_PushSettingModel *model;
@property (nonatomic, assign) BOOL receiveState;

@end

@implementation JHBoss_ReportFormsPushViewController

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
    self.receiveState = 0;
    [self requestReportPushSettingDetail];
    [self setup];
}


#pragma mark - request

// 获取报表推送设置
- (void)requestReportPushSettingDetail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [JHHttpRequest postRequestWithParams:param path:JH_ReportPushSettingDetail isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            self.model = [JHBoss_PushSettingModel mj_objectWithKeyValues:dic[@"data"]];
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

// 修改报表推送设置
- (void)requestSetReportPushSetting
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(self.receiveState) forKey:@"receiveState"];
    [param setObject:self.model.pushTime forKey:@"pushTime"];
    
    [JHHttpRequest postRequestWithParams:param path:JH_SetReportPushSetting isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}


#pragma mark - UI


- (void)setup
{
    self.jhtitle = @"报表推送设置";
    
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
    return 4;
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
        cell.title = @"接收经营报表";
        cell.switchSW.on = self.model.state;
        [[[cell.switchSW rac_newOnChannel] distinctUntilChanged] subscribeNext:^(id x) {
            @strongify(self);
            self.receiveState = [x boolValue];
            [self requestSetReportPushSetting];
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
        switch (indexPath.row) {
            case 1:
            {
                cell.title = @"订阅报表类型";
                NSMutableString *desc = [NSMutableString string];
                for (JHBoss_PushReportSettingModel *model in self.model.subscribeReports) {
                    model.state ? [desc appendString:[NSString stringWithFormat:@"  %@", model.reportName]] : nil;
                }
                cell.descTitle = desc;
                cell.showTipBtn = NO;
            }
                break;
            case 2:
                cell.title = @"推送时间";
                cell.descTitle = self.model.pushTime;
                cell.showTipBtn = NO;
                break;
            case 3:
            {
                cell.title = @"推送至";
                NSMutableString *desc = [NSMutableString string];
                for (JHBoss_PushTargetsSettingModel *model in self.model.pushTargets) {
                    model.state ? [desc appendString:[NSString stringWithFormat:@"  %@", model.name]] : nil;
                }
                cell.descTitle = desc;
                cell.showTipBtn = YES;
                cell.tipBlock = ^(UIButton *btn){
                    @strongify(self);
                    [JH_Menu createMenuInView:self.view fromRect:[btn convertRect:btn.bounds toView:self.view] textItems:@[@"将报表推送至您常用的平台,随时随地查看经营状况。"].copy];
                };
            }
                break;
                
            default:
                break;
        }
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
    @weakify(self);
    switch (indexPath.row) {
        case 1:
        {
            JHBoss_SubscribeFormsViewController *subscribeFormsVC = [[JHBoss_SubscribeFormsViewController alloc] init];
            subscribeFormsVC.model = self.model;
            [self.navigationController pushViewController:subscribeFormsVC animated:YES];
        }
            break;
        case 2:
        {
            HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerOneTime completeBlock:^(NSArray *time) {
                @strongify(self);
                self.model.pushTime = time[0];
                [self requestSetReportPushSetting];
                [self.tableView reloadData];
            }];
            [picker show];
        }
            break;
        case 3:
        {
            JHBoss_PushAddressViewController *pushAddressVC = [[JHBoss_PushAddressViewController alloc] init];
            pushAddressVC.model = self.model;
            [self.navigationController pushViewController:pushAddressVC animated:YES];
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

@end
