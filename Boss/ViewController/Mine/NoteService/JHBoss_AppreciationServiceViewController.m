//
//  JHBoss_AppreciationServiceViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_AppreciationServiceViewController.h"
#import "JHBoss_DishDetailTableViewCell.h"
#import "JHBoss_NoteServiceTableViewCell.h"
#import "JHBoss_AppreciationServiceHeaderView.h"
#import "JHBoss_AppreciationServiceFeeViewController.h"

#import "JHBoss_RechargeViewController.h"
#import "JHBoss_PayMessageViewController.h"

#import "JHBoss_WalletBalanceModel.h"
#import "JHBoss_RechargeViewController.h"

@interface JHBoss_AppreciationServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHBoss_AppreciationServiceHeaderView *headerView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIButton *rechargeBtn;//充值按钮
@property (nonatomic, strong) JHBoss_WalletBalanceModel *walletBalanceMd;

@end

@implementation JHBoss_AppreciationServiceViewController

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
    // Do any additional setup after loading the view.
    [self setUpUI];
}

-(void)setUpUI{

    self.jhtitle = @"增值服务";
    [self.rightNavButton setimage:@"nav_icon_gengduo"];
    @weakify(self);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    self.tableView.tableFooterView = self.footView;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.and.bottom.right.mas_equalTo(0);
        
    }];
    
    [self.tableView registerClass:[JHBoss_DishDetailTableViewCell class] forCellReuseIdentifier:@"JHBoss_DishDetailTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_NoteServiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_NoteServiceTableViewCell"];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    float height;
    if (!indexPath.section) {
        
       height = 90;
    }else{
       height = 60;
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    float height;
    if (!section) {
        
        height = 10;
    }else{
        height = 0.0001;
    }
    return height;

}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    if (!section) {
//        
//        return 654;
//    }
//    return 0.0000001;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    
//    UIView *view = [[UIView alloc] init];
//    
//    [view addSubview:self.headerView];
//    [_headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.and.top.mas_equalTo(0);
//        make.height.mas_equalTo(644);
//    }];
//    
//    return self.headerView;
//
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (!indexPath.section) {
        static NSString *reuse = @"JHBoss_DishDetailTableViewCell";
        JHBoss_DishDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        cell.enterIntoType = JHBoss_NoteService;
        cell.titleStr = @"钱包余额(元)";
        cell.money = DEF_OBJECT_TO_STIRNG(self.moneyCount);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *reuse = @"JHBoss_NoteServiceTableViewCell";
        JHBoss_NoteServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        cell.residueMessageCount = self.residueMessageCount;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        JHBoss_DishDetailTableViewCell *dishCell = [tableView cellForRowAtIndexPath:indexPath];
        
        //进入充值页面
        JHBoss_RechargeViewController *rechargeVC = [[JHBoss_RechargeViewController alloc] init];
        
        rechargeVC.payType    = KPayMethodType_Top_UP;
        rechargeVC.merchanId  = self.merchanId;
        rechargeVC.refreshWalletMoneyHanlder = ^(NSString * _Nonnull moneyCount, NSString * _Nonnull residueMessageCount) {
            
            self.moneyCount = [NSString stringWithFormat:@"%g",moneyCount.doubleValue * 100];
            self.residueMessageCount = residueMessageCount;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if (self.refreshWalletMoneyHanlder) {
                    self.refreshWalletMoneyHanlder();
                }
            });
        };
        [self.navigationController pushViewController:rechargeVC animated:YES];
        
    } else {
        
        //进入短信充值页面
        JHBoss_PayMessageViewController *payMessageVC = [[JHBoss_PayMessageViewController alloc] init];
        payMessageVC.merchanId                        = self.merchanId;
        payMessageVC.merchanId = self.merchanId;
        payMessageVC.refreshWalletMoneyHanlder = ^(NSString * _Nonnull moneyCount, NSString * _Nonnull residueMessageCount) {
            
             self.moneyCount = [NSString stringWithFormat:@"%g",moneyCount.doubleValue * 100];
            self.residueMessageCount = residueMessageCount;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if (self.refreshWalletMoneyHanlder) {
                    self.refreshWalletMoneyHanlder();
                }
            });
        };
        [self.navigationController pushViewController:payMessageVC animated:YES];
    }
}

-(JHBoss_AppreciationServiceHeaderView *)headerView{

    if (!_headerView) {
        _headerView = [[JHBoss_AppreciationServiceHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, MYDIMESCALEH(160))];
    }
    return _headerView;
}

-(UIView *)footView{

    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), MYDIMESCALE(233))];
        self.rechargeBtn = [UIButton new];
        [self.rechargeBtn setTitle:@"充值"];
        [self.rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        self.rechargeBtn.layer.cornerRadius = 20;
        self.rechargeBtn.layer.masksToBounds = YES;
        self.rechargeBtn.backgroundColor = DEF_COLOR_CDA265;
        @weakify(self);
        [[self.rechargeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            JHBoss_RechargeViewController *rechargeVC = [[JHBoss_RechargeViewController alloc]init];
            rechargeVC.payType = KPayMethodType_Top_UP;
            rechargeVC.merchanId = self.merchanId;
//            rechargeVC.moneyCount = self.walletModel.balance.stringValue;
            [self.navigationController pushViewController:rechargeVC animated:YES];
           
        }];
        [_footView addSubview:self.rechargeBtn];
        [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(37.5);
            make.right.mas_equalTo(-37.5);
            make.height.mas_equalTo(40);
            make.bottom.equalTo(_footView.mas_bottom);
        }];
    }
    return _footView;
}

-(void)onClickRightNavButton:(UIButton *)rightNavButton{

    JHBoss_AppreciationServiceFeeViewController *AppSFVC = [[JHBoss_AppreciationServiceFeeViewController alloc]init];
    AppSFVC.merchanId = self.merchanId;
    [self.navigationController pushViewController:AppSFVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
