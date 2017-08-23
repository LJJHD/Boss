//
//  JHBoss_ApproveViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ApproveViewController.h"
#import "JHBoss_ApproveHeaderView.h"
#import "JHBoss_ApproveTableViewCell.h"
#import "JHBoss_ApproveModel.h"
#import "JHBoss_CheckSettingViewController.h"

@interface JHBoss_ApproveViewController ()<UITableViewDelegate, UITableViewDataSource, JHBoss_ApproveHeaderViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) JHBoss_ApproveHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *emptyBtn; // 清空按钮
@property (nonatomic, assign) NSInteger displayType; // 0(后台为1) 待审批  1(2) 已通过  2(3) 已拒绝
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSNumber *approvalId; // 条目id
@property (nonatomic, strong) NSNumber *state; // 按钮，是否同意或拒绝 1 已拒绝， 2 已通过
@property (nonatomic, assign) NSInteger row; // 审批的条目

@property (nonatomic, assign) BOOL loading; // 是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView; // 数据加载过程中显示加载动画的view

@end

@implementation JHBoss_ApproveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}


#pragma mark - request

// 获取审核列表
- (void)requestGetApprovalList
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(self.displayType + 1) forKey:@"type"];
    [param setObject:@(self.page) forKey:@"page"];
    
    [JHHttpRequest postRequestWithParams:param path:JH_GetApprovalList isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:[JHBoss_ApproveModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"dataList"]]];
        }
        [self emptyStateChange];
        [self commonConfiguration];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [self commonConfiguration];
        [self emptyStateChange];
    }];
}

// 更新等待审批项目
- (void)requestUpdateApprovalState
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.approvalId forKey:@"approvalId"];
    [param setObject:self.state forKey:@"state"];
    
    [JHHttpRequest postRequestWithParams:param path:JH_UpdateApprovalState isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            [self.dataArray removeObjectAtIndex:self.row];
        }
        [self.tableView reloadData];
        [self emptyStateChange];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [self emptyStateChange];
    }];
}

// 清空已处理审批项目
- (void)requestDeleteApproval
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(self.displayType + 1) forKey:@"type"];
    
    [JHHttpRequest postRequestWithParams:param path:JH_DeleteApproval isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            [self.dataArray removeAllObjects];
        }
        [self emptyStateChange];
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [self emptyStateChange];
    }];
}


#pragma mark - UI

- (void)setup
{
    @weakify(self);
    
    self.jhtitle = @"待我审批";
    [self.rightNavButton setTitle:@"设置"];
    [self.rightNavButton setTitleColor:DEF_COLOR_RGB_A(255, 255, 255, 0.7) forState:UIControlStateNormal];
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
        make.height.mas_equalTo(44);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    // init emptyBtn
    [self.view addSubview:self.emptyBtn];
    [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(-40);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    [[self.emptyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认清空" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        [[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
            if ([x integerValue] == 1) {
                [self requestDeleteApproval];
            }
        }];
    }];
    
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self requestGetApprovalList];
        [self.tableView.mj_header endRefreshing];
    }];
    
    [self.tableView addCustomGifFooterWithRefreshingBlock:^{
        @strongify(self);
        self.page ++;
        [self requestGetApprovalList];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)onClickRightNavButton:(UIButton *)rightNavButton
{
    JHBoss_CheckSettingViewController *checkSettingVC = [[JHBoss_CheckSettingViewController alloc] init];
    [self.navigationController pushViewController:checkSettingVC animated:YES];
}


#pragma mark - JHBoss_ApproveHeaderView delegate

- (void)didSelectMenuBtn:(MenuButton *)menuButton
{
    self.displayType = menuButton.index;
    self.page = 1;
    [self requestGetApprovalList];
}


#pragma mark - tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"JHBoss_ApproveTableViewCell";
    JHBoss_ApproveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[JHBoss_ApproveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.displayType = self.displayType;
    cell.model = self.dataArray[indexPath.row];
    
    @weakify(self);
    cell.leftAction = ^{
        @strongify(self);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认拒绝" message:@"操作后将无法撤销" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        [[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
            if ([x integerValue] == 1) {
                self.approvalId = [self.dataArray[indexPath.row] approvalId];
                self.state = @(1);
                self.row = indexPath.row;
                [self requestUpdateApprovalState];
            }
        }];
    };
    cell.rightAction = ^{
        @strongify(self);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认同意" message:@"操作后将无法撤销" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        [[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
            if ([x integerValue] == 1) {
                self.approvalId = [self.dataArray[indexPath.row] approvalId];
                self.state = @(2);
                self.row = indexPath.row;
                [self requestUpdateApprovalState];
            }
        }];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


#pragma mark - setter/getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}

- (JHBoss_ApproveHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JHBoss_ApproveHeaderView alloc] init];
        _headerView.delegate = self;
        _headerView.itemArray = [NSMutableArray arrayWithObjects:@"待审批",@"已通过",@"已拒绝", nil];
        _headerView.leftSpace = 30;
        _headerView.rightSpace = 30;
        
        [_headerView showApproveHeaderView];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIButton *)emptyBtn
{
    if (!_emptyBtn) {
        _emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emptyBtn setimage:@"1.1.3.1_btn_empty"];
        _emptyBtn.layer.cornerRadius = 32;
        _emptyBtn.layer.masksToBounds = YES;
        _emptyBtn.hidden = YES;
    }
    return _emptyBtn;
}


#pragma ----DZNEmptyDataSet -------datasoure
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (_loading) {
        return nil;
    }
    if (NETWORK_CONNECTION_STAT == NotReachable) {
        return DEF_IMAGENAME(@"0.4_icon_wangluoyichang");
    }
    return DEF_IMAGENAME(@"1.1.4.5_icon_zanwushenpi");
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.loading) {
        return nil;
    }
    
    NSString *text = @"暂无审批";
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0] range:[text rangeOfString:text]];
    
    return attributedTitle;
}


- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    if (_loading) {
        return self.loadDataView;
    }
    return  nil;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -60;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    return DEF_COLOR_F5F5F5;
}


#pragma ----DZNEmptyDataSet -------dataDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    //  从新进行网络请求
    _loading = YES;
    
    //请求没有网络数据时调用，展示空页面
    [self.tableView reloadEmptyDataSet];
    [self.loadDataView startAnimation];
    [self requestGetApprovalList];
}

//加载显示加载数据时的动画view
-(JHCRM_LoadDataView *)loadDataView{
    
    if (!_loadDataView) {
        _loadDataView = [[JHCRM_LoadDataView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    }
    [_loadDataView startAnimation];
    return _loadDataView;
}

-(void)commonConfiguration{
    _loading = NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.loadDataView stopAnimation];
}


#pragma mark - other

- (void)emptyStateChange
{
    if (self.dataArray.count && self.displayType) {
        self.emptyBtn.hidden = NO;
    } else {
        self.emptyBtn.hidden = YES;
    }
}

@end
