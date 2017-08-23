//
//  JHBoss_ResultDisplayViewController.m
//  Boss
//
//  Created by sftoday on 2017/6/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ResultDisplayViewController.h"

@interface JHBoss_ResultDisplayViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *restartBtn;
@property (nonatomic, strong) UIImageView *headerIV;

@end

@implementation JHBoss_ResultDisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
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
}


#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kScreenWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    [header addSubview:self.headerIV];
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] init];
    [footer addSubview:self.restartBtn];
    [self.restartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(37.5);
        make.right.mas_equalTo(-37.5);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(40);
    }];
    return footer;
}


#pragma mark - setter/getter

- (UIImageView *)headerIV
{
    if (!_headerIV) {
        _headerIV = [[UIImageView alloc] initWithImage:DEF_IMAGENAME(@"1.1.5.2_icon_100fen")];
    }
    return _headerIV;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (UIButton *)restartBtn
{
    if (!_restartBtn) {
        _restartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _restartBtn.titleLabel.font = DEF_SET_FONT(17);
        _restartBtn.titleLabel.textColor = [UIColor whiteColor];
        _restartBtn.backgroundColor = DEF_COLOR_CDA265;
        _restartBtn.layer.cornerRadius = 20;
        _restartBtn.layer.masksToBounds = YES;
        [_restartBtn setTitle:@"重新体检"];
        @weakify(self);
        [[_restartBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _restartBtn;
}

@end
