//
//  JHBoss_MineViewController.m
//  Boss
//
//  Created by sftoday on 2017/4/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_MineViewController.h"
#import "JHBoss_MineTableViewCell.h"

@interface JHBoss_MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *bossNameLabel;
@property (nonatomic, strong) UILabel *positionLB;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UILabel *settingLB;

@end

@implementation JHBoss_MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}

- (void)setup
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(-500);
    }];
}


#pragma mark - tableviewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"JHBoss_MineTableViewCell";
    JHBoss_MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[JHBoss_MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tag = 1000 + indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 654;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @weakify(self);
    
    UIView *view = [[UIView alloc] init];
    
    _headerView = [[UIView alloc] init];
    _headerView.backgroundColor = DEF_COLOR_CDA265;
    [view addSubview:_headerView];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(644);
    }];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.layer.cornerRadius = 40;
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.borderWidth = 5;
    _iconImageView.layer.borderColor = DEF_COLOR_CDA265.CGColor;
    [_headerView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.bottom.mas_equalTo(-20);
        make.height.and.width.mas_equalTo(80);
    }];
    
    _bossNameLabel = [[UILabel alloc] init];
    _bossNameLabel.font = DEF_SET_FONT(18);
    _bossNameLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:_bossNameLabel];
    [_bossNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(20);
        make.top.equalTo(self.iconImageView.mas_top).offset(8.5);
    }];
    
    _positionLB = [[UILabel alloc] init];
    _positionLB.font = DEF_SET_FONT(14);
    _positionLB.textColor = [UIColor whiteColor];
    [_headerView addSubview:_positionLB];
    [_positionLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(20);
        make.top.equalTo(self.bossNameLabel.mas_bottom).offset(6);
    }];
    
    _settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headerView addSubview:_settingBtn];
    [_settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.bottom.mas_equalTo(-111);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    _settingLB = [[UILabel alloc] init];
    _settingLB.font = DEF_SET_FONT(15);
    _settingLB.textColor = [UIColor whiteColor];
    [_headerView addSubview:_settingLB];
    [_settingLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.settingBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.settingBtn);
    }];
    
    // init
    _iconImageView.image = DEF_IMAGENAME(@"ceshi");
    _bossNameLabel.text = @"MIA6300";
    _positionLB.text = @"我是老板";
    [_settingBtn setimage:@"5.1_icon_setting"];
    _settingLB.text = @"设置";
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - setter/getter

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"个人资料", @"意见建议", @"使用条款", @"关于晶汉", nil];
    }
    return _dataArray;
}

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

//隐藏导航条
-(BOOL)disableAutomaticSetNavBar{
    
    return YES;
}


@end
