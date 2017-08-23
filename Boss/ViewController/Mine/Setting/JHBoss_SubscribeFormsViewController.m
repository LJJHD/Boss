//
//  JHBoss_SubscribeFormsViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_SubscribeFormsViewController.h"
#import "JHBoss_SelectedTableViewCell.h"

@interface JHBoss_SubscribeFormsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JHBoss_SubscribeFormsViewController

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
    [param setObject:@([self.model.subscribeReports[0] state]) forKey:@"dailyState"];
    [param setObject:@([self.model.subscribeReports[1] state]) forKey:@"weeklyState"];
    [param setObject:@([self.model.subscribeReports[2] state]) forKey:@"monthlyState"];
    
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
    self.jhtitle = @"订阅报表类型";
    
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"JHBoss_SelectedTableViewCell";
    JHBoss_SelectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[JHBoss_SelectedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    @weakify(self);
    [cell setState:[self.model.subscribeReports[indexPath.row] state] block:NO];
    cell.selectedBlock = ^(BOOL selected) {
        @strongify(self);
        [self.model.subscribeReports[indexPath.row] setState:selected];
        [self requestSetReportPushSetting];
    };
    switch (indexPath.row) {
        case 0:
            cell.title = @"日报";
            break;
        case 1:
            cell.title = @"周报";
            break;
        case 2:
            cell.title = @"月报";
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHBoss_SelectedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setState:!cell.state block:YES];
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

@end
