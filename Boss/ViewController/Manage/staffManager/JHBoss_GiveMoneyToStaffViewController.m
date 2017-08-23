//
//  JHBoss_GiveMoneyToStaffViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_GiveMoneyToStaffViewController.h"
#import "JHBossGiveStaffMoneyView.h"
#import "JHUserInfoData.h"
#import "JHBoss_rewardMoneyListModel.h"
#import "JHBoss_PrepaymentOrderModel.h"
@interface JHBoss_GiveMoneyToStaffViewController ()
@property (nonatomic, strong)JHBossGiveStaffMoneyView *staffView;
@property (nonatomic, copy)  NSString *userId;
@property (nonatomic, strong) JHUserInfoData *userInfo;
@property (nonatomic, strong) JHBoss_PrepaymentOrderModel *prepaymentModel;
@property (nonatomic, strong) NSMutableArray<JHBoss_rewardMoneyListModel *> *rewardMoneyArr;
@end

@implementation JHBoss_GiveMoneyToStaffViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}


//获取打赏金额
-(void)loadRewardList{

    [JHUtility showGifProgressViewInView:self.view];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [JHHttpRequest postRequestWithParams:param path:JH_rewardMoneyListURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            self.rewardMoneyArr = [JHBoss_rewardMoneyListModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            
            self.staffView.rewardMoneyArr = self.rewardMoneyArr;
            
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];
    }];
}

//获取用户userId信息
-(void)requestUserInfo{
    
    @weakify(self);
    [self.userInfo getUserInfoIdentify:saveUserIdentify result:^(NSDictionary *result) {
        @strongify(self);
        self.userId = result[@"accountId"];
       
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestUserInfo];
    [self loadRewardList];
    [self setUI];
}
-(void)setUI{

    self.jhtitle = @"员工打赏";

    self.staffView = [[JHBossGiveStaffMoneyView alloc]initWithFrame:CGRectZero];
    @weakify(self);
    self.staffView.payBlock = ^(NSString *staffId) {
        @strongify(self);
        [self rewardStr:staffId];
    };
    
    [self.view addSubview:self.staffView];
    [self.staffView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.and.bottom.mas_equalTo(0);
    }];
}
//获取订单号和金额
-(void)rewardStr:(NSString *)contentStr{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.userId forKey:@"customerId"];
    [param setValue:contentStr forKey:@"bountyId"];
    [param setValue:self.staffId forKey:@"waiterId"];
    [JHUtility showGifProgressViewInView:self.view];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_rewardMoneyURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            self.prepaymentModel = [JHBoss_PrepaymentOrderModel mj_objectWithKeyValues:dic[@"data"]];
            [self order:self.prepaymentModel];
        }else{
        
         [JHUtility hiddenGifProgressViewInView:self.view];
        }
        
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
         [JHUtility hiddenGifProgressViewInView:self.view];
    }];
}

//统一下单接口
-(void)order:(JHBoss_PrepaymentOrderModel *)model{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:model.orderNo forKey:@"orderNo"];//订单号
    [param setValue:@"APP" forKey:@"tradeType"];//订单类型 APP支付
    [param setValue:model.billType.stringValue forKey:@"billType"];//支付类型，此次为打赏
     @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_WXPayURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            
        }else{
        
         [JHUtility hiddenGifProgressViewInView:self.view];
        }
        
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
         [JHUtility hiddenGifProgressViewInView:self.view];
    }];
}

-(JHUserInfoData *)userInfo{

    if (!_userInfo) {
        _userInfo = [[JHUserInfoData alloc]init];
    }
    return _userInfo;
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
