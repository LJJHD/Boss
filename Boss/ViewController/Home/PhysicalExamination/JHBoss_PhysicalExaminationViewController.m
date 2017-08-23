//
//  JHBoss_PhysicalExaminationViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PhysicalExaminationViewController.h"
#import "JHBoss_PhysicalExaminationTableViewCell.h"
#import "ZZCircleProgress.h"
#import "JHBoss_ExaminationResultViewController.h"
#import "JHBoss_ResultDisplayViewController.h"
#import "JHLoginState.h"
#import "JHUserInfoData.h"
@interface JHBoss_PhysicalExaminationViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ZZCircleProgress *circleView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isStartAnimation;
@property (nonatomic, strong) JHBoss_PhysicalExaminationModel *model;
@property (nonatomic, assign) BOOL allowStart;
@property (nonatomic, strong) JHUserInfoData *userInfo;
@property (nonatomic, copy)   NSString *merchanId;
@end

@implementation JHBoss_PhysicalExaminationViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.stopBtn setTitle:@"开始体检"];
    self.circleView.notAnimated = YES;
    self.circleView.progress = 0;
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}


//获取用户merchantId信息
-(void)requestUserInfo{
    
    @weakify(self);
    
    [self.userInfo getUserInfoIdentify:saveUserIdentify result:^(NSDictionary *result) {
        @strongify(self);
        self.merchanId = result[@"merchantId"];
        dispatch_async(dispatch_get_main_queue(), ^{
           [self requestStoreTestInfo];
        });
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.allowStart = YES;
    [self requestUserInfo];
    
    [self setUI];
}


#pragma mark - request

// 获取店铺体检结果
- (void)requestStoreTestInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.merchanId forKey:@"bossId"];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_StoreTestInfo isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            self.model = [JHBoss_PhysicalExaminationModel mj_objectWithKeyValues:dic[@"data"]];
            self.allowStart = YES;
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        @strongify(self);
        self.allowStart = NO;
    }];
}


#pragma mark - UI


- (void)setUI
{
    @weakify(self);
    
    self.jhtitle = @"店铺体检";
    
    // init tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
    
    [[self.stopBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (!self.allowStart) {
            [JHUtility showToastWithMessage:@"网络情况不良"];
            return;
        }
        if ([self.stopBtn.titleLabel.text isEqualToString:@"停止体检"]) {
            [self.stopBtn setTitle:@"开始体检"];
            self.circleView.notAnimated = YES;
            self.circleView.progress = 0;
            [self stopAnimation];
        } else {
            [self.stopBtn setTitle:@"停止体检"];
            [self startAnimation];
        }
    }];
}

- (void)startAnimation
{
    self.isStartAnimation = YES;
    self.circleView.progress = 1;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self requestStoreTestInfo];
    
    [self performSelector:@selector(endAnimation) withObject:nil afterDelay:3];
}

- (void)stopAnimation
{
    self.isStartAnimation = NO;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(endAnimation) object:nil];
}

- (void)endAnimation
{
    [self stopAnimation];
    if (self.model.score.integerValue == 75 && [JHLoginState isOpenGesturePassword:@""] == 2) {
        JHBoss_ResultDisplayViewController *resultDisplayVC = [[JHBoss_ResultDisplayViewController alloc] init];
        [self.navigationController pushViewController:resultDisplayVC animated:YES];
    } else {
        JHBoss_ExaminationResultViewController *resultVC = [[JHBoss_ExaminationResultViewController alloc] init];
        resultVC.model = self.model;
        [self.navigationController pushViewController:resultVC animated:YES];
    }
}


#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"JHBoss_PhysicalExaminationTableViewCell";
    JHBoss_PhysicalExaminationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[JHBoss_PhysicalExaminationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (!indexPath.row) {
        cell.title = @"检查店铺设置";
    } else {
        cell.title = @"检查数据异常";
    }
    cell.startAnimation = self.isStartAnimation;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 300 + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    [header addSubview:self.whiteView];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] init];
    [footer addSubview:self.stopBtn];
    [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(37.5);
        make.right.mas_equalTo(-37.5);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(40);
    }];
    return footer;
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
    }
    return _tableView;
}

- (ZZCircleProgress *)circleView
{
    if (!_circleView) {
        //无小圆点、同动画时间
        _circleView = [[ZZCircleProgress alloc] initWithFrame:CGRectMake((DEF_WIDTH - 216) / 2, 42, 216, 216) pathBackColor:DEF_COLOR_F5F5F5 pathFillColor:DEF_COLOR_CDA265 startAngle:-90 strokeWidth:15];
        _circleView.showPoint = NO;
        _circleView.animationModel = CircleIncreaseByProgress;
        _circleView.progress = 0.0;
    }
    _circleView.notAnimated = NO;
    return _circleView;
}

- (UIView *)whiteView
{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 300)];
        _whiteView.backgroundColor = [UIColor whiteColor];
        [_whiteView addSubview:self.circleView];
    }
    return _whiteView;
}

- (UIButton *)stopBtn
{
    if (!_stopBtn) {
        _stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _stopBtn.titleLabel.font = DEF_SET_FONT(17);
        _stopBtn.titleLabel.textColor = [UIColor whiteColor];
        _stopBtn.backgroundColor = DEF_COLOR_CDA265;
        _stopBtn.layer.cornerRadius = 20;
        _stopBtn.layer.masksToBounds = YES;
        [_stopBtn setTitle:@"开始体检"];
    }
    return _stopBtn;
}

-(JHUserInfoData *)userInfo{

    if (!_userInfo) {
        _userInfo = [[JHUserInfoData alloc]init];
    }
    return _userInfo;
}

@end
