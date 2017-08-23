//
//  JHBoss_NoDisturbModeViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_NoDisturbModeViewController.h"
#import "JHBoss_PersonalCenterTableViewCell.h"
#import "JHBoss_SwitchTableViewCell.h"
#import "JHBoss_NoDisturbModel.h"
#import "HCGDatePickerAppearance.h"

@interface JHBoss_NoDisturbModeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHBoss_NoDisturbModel *model;

@end

@implementation JHBoss_NoDisturbModeViewController

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

#pragma mark - request

// 获取勿扰设置详情
- (void)requestReviewSettingDetail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [JHHttpRequest postRequestWithParams:param path:JH_NotDisturbSettingDetail isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            self.model = [JHBoss_NoDisturbModel mj_objectWithKeyValues:dic[@"data"]];
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

// 修改勿扰模式
- (void)requestModifyReminderSetting
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(self.model.state) forKey:@"state"];
    [param setObject:self.model.startTime forKey:@"startTime"];
    [param setObject:self.model.endTime forKey:@"endTime"];
    
    [JHHttpRequest postRequestWithParams:param path:JH_ChangeNotDisturbSetting isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}


#pragma mark - UI

- (void)setup
{
    self.jhtitle = @"勿扰设置";
    
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
        cell.title = @"勿扰模式";
        cell.showTipBtn = YES;
        cell.switchSW.on = self.model.state;
        @weakify(self);
        [[[cell.switchSW rac_newOnChannel] distinctUntilChanged] subscribeNext:^(id x) {
            @strongify(self);
            self.model.state = [x boolValue];
            [self requestModifyReminderSetting];
        }];
        cell.tipBlock = ^(UIButton *btn){
            @strongify(self);
            [JH_Menu createMenuInView:self.view fromRect:[btn convertRect:btn.bounds toView:self.view] textItems:@[@"开启后，在设定时间段内不会", @"收到系统提醒。"].copy];
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
        cell.title = @"定时开启勿扰模式";
        cell.descTitle = [NSString stringWithFormat:@"%@至%@", self.model.startTime, self.model.endTime];
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
    if (indexPath.row == 1) {
        HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerTwoTime completeBlock:^(NSArray *time) {
            @strongify(self);
            self.model.startTime = time[0];
            self.model.endTime = time[1];
            [self requestModifyReminderSetting];
            [self.tableView reloadData];
        }];
        [picker show];
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
