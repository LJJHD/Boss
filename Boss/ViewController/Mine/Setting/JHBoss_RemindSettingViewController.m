//
//  JHBoss_RemindSettingViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_RemindSettingViewController.h"
#import "JHBoss_PersonalCenterTableViewCell.h"
#import "JHBoss_SwitchTableViewCell.h"
#import "JHBoss_MessageRemindWaysViewController.h"
#import "JHBoss_ReminderSettingModel.h"

@interface JHBoss_RemindSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHBoss_ReminderSettingModel *model;

@end

@implementation JHBoss_RemindSettingViewController

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

// 获取提醒设置详情
- (void)requestReviewSettingDetail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [JHHttpRequest postRequestWithParams:param path:JH_ReminderSettingDetail isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            self.model = [JHBoss_ReminderSettingModel mj_objectWithKeyValues:dic[@"data"]];
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

// 修改提醒设置详情
- (void)requestModifyReminderSetting
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:@(self.model.business) forKey:@"business"];
    [param setObject:@(self.model.recruitInfo) forKey:@"recruitInfo"];
    [param setObject:@(self.model.waiter) forKey:@"waiter"];
    [param setObject:@(self.model.complaint) forKey:@"complaint"];
    [param setObject:@(self.model.order) forKey:@"order"];
    
    [JHHttpRequest postRequestWithParams:param path:JH_ModifyReminderSetting isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}


#pragma mark - UI

- (void)setup
{
    self.jhtitle = @"提醒设置";
    
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
//    if (!indexPath.row) {
//        static NSString *reuseId = @"JHBoss_PersonalCenterTableViewCell";
//        JHBoss_PersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
//        if (!cell) {
//            cell = [[JHBoss_PersonalCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.showIndicate = YES;
//        }
//        cell.title = @"通知提醒方式";
//        cell.descTitle = @"APP内 微信公众号";
//        return cell;
//    } else {
        static NSString *reuseId = @"JHBoss_SwitchTableViewCell";
        JHBoss_SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell) {
            cell = [[JHBoss_SwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    @weakify(self);
        switch (indexPath.row + 1) {
            case 11:
            {//这个版本不要
                cell.title = @"经营数据有较大差异";
                cell.showTipBtn = NO;
                cell.switchSW.on = self.model.business;
                [[[cell.switchSW rac_newOnChannel] distinctUntilChanged] subscribeNext:^(id x) {
                    @strongify(self);
                    self.model.business = [x boolValue];
                    [self requestModifyReminderSetting];
                }];
            }
                break;
            case 10:
            {
                //这个版本不要
                cell.title = @"招聘信息有新的回应";
                cell.showTipBtn = NO;
                cell.switchSW.on = self.model.recruitInfo;
                [[[cell.switchSW rac_newOnChannel] distinctUntilChanged] subscribeNext:^(id x) {
                    @strongify(self);
                    self.model.recruitInfo = [x boolValue];
                    [self requestModifyReminderSetting];
                }];
            }
                break;
//            case 3:
//                cell.title = @"菜品收到新的差评";
//                cell.showTipBtn = NO;
//                break;
            case 1:
            {
                cell.title = @"服务员收到新的差评";
                cell.showTipBtn = NO;
                cell.switchSW.on = self.model.waiter;
                [[[cell.switchSW rac_newOnChannel] distinctUntilChanged] subscribeNext:^(id x) {
                    @strongify(self);
                    self.model.waiter = [x boolValue];
                    [self requestModifyReminderSetting];
                }];
            }
                break;
            case 2:
            {
                cell.title = @"收到新的投诉建议";
                cell.showTipBtn = NO;
                cell.switchSW.on = self.model.complaint;
                [[[cell.switchSW rac_newOnChannel] distinctUntilChanged] subscribeNext:^(id x) {
                    @strongify(self);
                    self.model.complaint = [x boolValue];
                    [self requestModifyReminderSetting];
                }];
            }
                break;
            case 3:
            {
                cell.title = @"订单异常";
                cell.showTipBtn = YES;
                cell.switchSW.on = self.model.order;
                [[[cell.switchSW rac_newOnChannel] distinctUntilChanged] subscribeNext:^(id x) {
                    @strongify(self);
                    self.model.order = [x boolValue];
                    [self requestModifyReminderSetting];
                }];
                cell.tipBlock = ^(UIButton *btn){
                    @strongify(self);
                    [JH_Menu createMenuInView:self.view fromRect:[btn convertRect:btn.bounds toView:self.view] textItems:@[@"开启后，当订单出现折扣过低、反结账、挂单、逃单、退菜等情况时会发送提醒。"].copy];
                };
            }
                break;
                
            default:
                break;
        }
        return cell;
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (!indexPath.row) {
//        JHBoss_MessageRemindWaysViewController *messageRemindWaysVC = [[JHBoss_MessageRemindWaysViewController alloc] init];
//        [self.navigationController pushViewController:messageRemindWaysVC animated:YES];
//    }
//}


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
