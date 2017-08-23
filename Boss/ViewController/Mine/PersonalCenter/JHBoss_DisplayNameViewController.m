//
//  JHBoss_DisplayNameViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_DisplayNameViewController.h"
#import "JHBoss_TextFieldTableViewCell.h"

@interface JHBoss_DisplayNameViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *name;

@end

@implementation JHBoss_DisplayNameViewController

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
    self.name  = self.model.nickName;
    [self setup];
    // Do any additional setup after loading the view.
}


#pragma mark - request

// 修改昵称
- (void)requestModifyBossNickname
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.name forKey:@"name"];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_ModifyBossNickname isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            self.model.nickName = self.name;
            [JHUtility showToastWithMessage:dic[@"showMsg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}


#pragma mark - UI

- (void)setup
{
    self.jhtitle = @"显示名称";
    [self.navBar.rightBtn setImage:[UIImage imageNamed:@"nav_icon_wancheng"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
}


#pragma mark - rightAction

- (void)onClickRightNavButton:(UIButton *)rightNavButton
{
    if (!self.name.length) {
        [JHUtility showToastWithMessage:@"请输入名称"];
        return;
    }
    [self requestModifyBossNickname];
}


#pragma mark - tableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"JHBoss_TextFieldTableViewCell";
    JHBoss_TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[JHBoss_TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.inputTF.text = self.name;
    @weakify(self, cell);
    [[cell.inputTF rac_textSignal] subscribeNext:^(NSString *x) {
        @strongify(self, cell);
        if (x.length >10) {
            self.name = [x substringToIndex:10];
            cell.inputTF.text = [x substringToIndex:10];
            [JHUtility showToastWithMessage:@"最多显示10位哦"];
        }else{
            self.name = x;
        }
    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
