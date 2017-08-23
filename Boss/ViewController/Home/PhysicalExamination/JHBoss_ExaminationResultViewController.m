//
//  JHBoss_ExaminationResultViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ExaminationResultViewController.h"
#import "JHBoss_ExaminationResultTableViewCell.h"
#import "JHLoginState.h"
#import "JHBoss_GestureCodeSettingViewController.h"
#import "JHBoss_RemindSettingViewController.h"
#import "JHBoss_CheckSettingViewController.h"
#import "JHBoss_NoDisturbModeViewController.h"
#import "JHBoss_ReportFormsPushViewController.h"
#import "JHBoss_GesturePasswordSettingViewController.h"

@interface JHBoss_ExaminationResultViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UILabel *scoreLB;
@property (nonatomic, strong) UILabel *scoreDescLb;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *restartBtn;

@property (nonatomic, assign) int gestureStaute;//手势状态
@end

@implementation JHBoss_ExaminationResultViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"店铺体检结果"];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"店铺体检结果"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _gestureStaute =  [JHLoginState isOpenGesturePassword:@""];
    
    if (_gestureStaute == 1) {
        
        JHBoss_PhysicalExaminationItemModel *itemModel = [[JHBoss_PhysicalExaminationItemModel alloc]init];
        itemModel.name = @"安全设置";
        itemModel.prompt = @"您关闭了手势密码";
        itemModel.icon = @"1.1.5.2_icon_safety";
        [self.model.checkList addObject:itemModel];
        
    }
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
    return self.model.checkList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"JHBoss_ExaminationResultTableViewCell";
    JHBoss_ExaminationResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[JHBoss_ExaminationResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.model = self.model.checkList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150 + 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] init];
    [header addSubview:self.header];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    JHBoss_PhysicalExaminationItemModel *model = self.model.checkList[indexPath.row];
   
    if ([model.name isEqualToString:@"安全设置"]) {
        
        JHBoss_GesturePasswordSettingViewController *GPSettingVC = [[JHBoss_GesturePasswordSettingViewController alloc]init];
        [self.navigationController pushViewController:GPSettingVC animated:YES];
        
    }else if ([model.name isEqualToString:@"提醒设置"]){
    
        JHBoss_RemindSettingViewController *abnormalVC = [[JHBoss_RemindSettingViewController alloc]init];
        [self.navigationController pushViewController:abnormalVC animated:YES];
    
    }else if ([model.name isEqualToString:@"审批设置"]){
        
        JHBoss_CheckSettingViewController *checkVC = [[JHBoss_CheckSettingViewController alloc]init];
        [self.navigationController pushViewController:checkVC animated:YES];
        
    }else if ([model.name isEqualToString:@"勿扰设置"]){
        
        JHBoss_NoDisturbModeViewController *noCisturbVC = [[JHBoss_NoDisturbModeViewController alloc]init];
        [self.navigationController pushViewController:noCisturbVC animated:YES];
        
    }else if ([model.name isEqualToString:@"报表设置"]){
        
        JHBoss_ReportFormsPushViewController *reportVC = [[JHBoss_ReportFormsPushViewController alloc]init];
        [self.navigationController pushViewController:reportVC animated:YES];
        
    }else if ([model.name isEqualToString:@""]){
        
        
    }

}


#pragma mark - setter/getter

- (UIView *)header
{
    if (!_header) {
        @weakify(self);
        _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 150)];
        _header.backgroundColor = [UIColor whiteColor];
        
        [_header addSubview:self.scoreLB];
        [self.scoreLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(28.5);
            make.centerX.mas_equalTo(0);
        }];
        
        UILabel *fenLB = [[UILabel alloc] init];
        fenLB.text = @"分";
        fenLB.font = DEF_SET_FONT(24);
        fenLB.textColor = DEF_COLOR_965800;
        [_header addSubview:fenLB];
        [fenLB mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.scoreLB.mas_right);
            make.bottom.equalTo(self.scoreLB.mas_bottom).with.offset(-10);
        }];
        
        [_header addSubview:self.scoreDescLb];
        [self.scoreDescLb mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.scoreLB.mas_bottom);
            make.centerX.mas_equalTo(0);
        }];
        
      
        NSUInteger score = self.model.score.integerValue;
        if (_gestureStaute == 1) {
            //关闭手势密码

        }else if (_gestureStaute == 2){
            //打开手势密码
            score += 25;
        }
        
        self.scoreLB.text = [NSString stringWithFormat:@"%ld",score];
        
        NSString *evaluate;
        if ( 49 < score && score < 100) {
            
            evaluate = @"还可以再完善一下~";
        }else if (score == 100){
        
            evaluate = @"太棒了，您超越了全国99.9%的用户~";
        }else if(score <= 49) {
            
             evaluate = @"状况好像不太好，赶紧去完善一下吧~";
        }
        
        self.scoreDescLb.text = evaluate;
    }
    return _header;
}

- (UILabel *)scoreLB
{
    if (!_scoreLB) {
        _scoreLB = [[UILabel alloc] init];
        _scoreLB.font = DEF_SET_FONT(72);
        _scoreLB.textColor = DEF_COLOR_965800;
    }
    return _scoreLB;
}

- (UILabel *)scoreDescLb
{
    if (!_scoreDescLb) {
        _scoreDescLb = [[UILabel alloc] init];
        _scoreDescLb.font = DEF_SET_FONT(13);
        _scoreDescLb.textColor = DEF_COLOR_CDA265;
    }
    return _scoreDescLb;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 70;
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
