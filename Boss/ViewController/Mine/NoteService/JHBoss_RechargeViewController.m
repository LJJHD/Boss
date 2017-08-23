//
//  JHBoss_RechargeViewController.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_RechargeViewController.h"

#import "JHBoss_PayMehtodItem.h"
#import "JHBoss_PayMethodHelper.h"

#import "JHBoss_PayMethodFooterView.h"

#import "JHBoss_EmployeesRewardCell.h"
#import "JHBoss_PayCountTableViewCell.h"
#import "JHBoss_RechargeTableViewCell.h"
#import "JHBoss_PayMethodTableViewCell.h"

#import "JHUserInfoData.h"
#import "JHBoss_rewardMoneyListModel.h"

#import "JHBoss_AppreciationServiceFeeViewController.h"
#import "JHBoss_PayResultAlertView.h"
#import "JHBoss_PayResultCheckout.h"
#import "JHBoss_WalletBalanceModel.h"

#import <AlipaySDK/AlipaySDK.h>
#import <WXApi.h>
static NSString * const kRechargeTableViewCellID     = @"kRechargeTableViewCellID";
static NSString * const kPayCountTableViewCellID     = @"kPayCountTableViewCellID";
static NSString * const kPayMethodTableViewCellID    = @"kPayMethodTableViewCellID";
static NSString * const kPayEmployeesTableViewCellID = @"kPayEmployeesTableViewCellID";

@interface JHBoss_RechargeViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) JHBoss_PayMethodFooterView *footView;

//支付方法(默认为NO 微信支付  YES:支付宝支付)
@property (nonatomic, assign, getter=isPayMethod) BOOL payMethod;

@property (nonatomic, copy)  NSString *userId;

@property (nonatomic, strong) JHUserInfoData *userInfo;

@property (nonatomic, strong) NSMutableArray<JHBoss_rewardMoneyListModel *> *rewardMoneyArr;
@property (nonatomic, strong) JHBoss_WalletBalanceModel *walletBalanceMd;
@property (nullable, nonatomic, copy) NSString *moneyCount;
@property (nullable, nonatomic, copy) NSString * residueMessageCount;

//钱包数量数组
@property (nonatomic, strong) NSMutableArray *moneyArray;
@property (nonatomic, strong)   NSDictionary *wxPrepaymentDic;//保存微信预支付结果，用于查询支付结果
@property (nonatomic, assign) BOOL isStalledWX;//是否安装微信
@end

@implementation JHBoss_RechargeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
    _isStalledWX =  [JHBoss_UserWarpper shareInstance].isInstallWX;
    if (!_isStalledWX) {
        //没有安装微信默认支付宝支付
        self.payMethod = YES;
    }

}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:alipayChectoutNotifiction object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WXPayChectoutNotifiction object:nil];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
    [self defaultConfig];
    [self fetchPayMethod];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payResultNotification:) name:alipayChectoutNotifiction object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(WXPayResultNotifiction:) name:WXPayChectoutNotifiction object:nil];
}

//alipay支付通知
-(void)payResultNotification:(NSNotification *)notification{
    NSDictionary *dic = notification.userInfo;
    [self payResultReminderIsSucc:dic[@"isSucc"]];
}

//wxpay支付通知
-(void)WXPayResultNotifiction:(NSNotification *)notification{

    NSDictionary *dic = notification.userInfo;
    //请求后台校验支付结果
    if ([dic[@"isSucc"] integerValue]) {
       
    [JHBoss_PayResultCheckout checkoutWXPayResult:@{@"appId":self.wxPrepaymentDic[@"appid"],@"mchId":self.wxPrepaymentDic[@"partnerid"],@"outTradeNo":self.wxPrepaymentDic[@"outtradeno"]} checkResut:^(BOOL isSucc) {
        
        [self payResultReminderIsSucc:isSucc];
    }];
    }else{
    
      [self payResultReminderIsSucc:NO];
    }
    
}

#pragma mark - Private Method

- (void)defaultConfig {
    switch (self.payType) {
        case KPayMethodType_Top_UP:
        {
            self.jhtitle = @"钱包充值";
        }
            break;
            
        case kPayMethodType_Employees_Reward:
        {
            self.jhtitle = @"员工打赏";
        }
            break;
    }
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
}

- (void)createUI {

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
    
}

//组装数据
- (void)fetchPayMethod {
    
    [JHUtility showGifProgressViewInView:DEF_Window];
    switch (self.payType) {
        case KPayMethodType_Top_UP:
        {
            [self loadFetchMoneyCount];
        }
            break;
            
        case kPayMethodType_Employees_Reward:
        {
        
            [self loadRewardList];
            
        }
            break;
    }
    
  //请求用户ID
    [self requestUserInfo];
}


//获取用户userId信息
-(void)requestUserInfo{
    
    @weakify(self);
    [self.userInfo getUserInfoIdentify:saveUserIdentify result:^(NSDictionary *result) {
        @strongify(self);
        self.userId = result[@"accountId"];
        
    }];
}

/**
 获取钱余额和短信余额
 */
- (void)requestWalletOrNoteNumber
{
   
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.merchanId forKey:@"merchantId"];
    [JHHttpRequest postRequestWithParams:param path:JH_WalletURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            self.walletBalanceMd = [JHBoss_WalletBalanceModel mj_objectWithKeyValues:dic[@"data"]];
            
            float balance = self.walletBalanceMd.balance.floatValue / 100;
            self.moneyCount = [NSString stringWithFormat:@"%g",balance];
            self.residueMessageCount = self.walletBalanceMd.remainderAmount.stringValue;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [JHUtility hiddenGifProgressViewInView:DEF_Window];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
         [JHUtility hiddenGifProgressViewInView:DEF_Window];
    }];
}

//获取打赏金额
- (void)loadRewardList {
    
    [JHHttpRequest postRequestWithParams:@{}
                                    path:JH_rewardMoneyListURL
                           isShowLoading:NO
                             isNeedCache:NO
                                 success:^(id object) {
                                     
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            self.rewardMoneyArr = [JHBoss_rewardMoneyListModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
 
            JHBoss_PayMethodHelper *hepler = [[JHBoss_PayMethodHelper alloc] init];
            NSMutableArray *payArr         = [hepler fetchPayMethodDataSourcesWithoutZFB:YES];
            
            NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
            
            for (JHBoss_rewardMoneyListModel *model in self.rewardMoneyArr) {
                [tmpArray addObject:[NSString stringWithFormat:@"¥ %g",model.amount/100]];
            }
            
            JHBoss_rewardMoneyListModel *listModel = self.rewardMoneyArr.firstObject;
            
            self.footView.payCount = listModel.amount/100;
             self.footView.payID = listModel.ID.integerValue;
            [self.dataSources addObjectsFromArray:@[@[],tmpArray,payArr]];

            [self.tableView reloadData];
        }
          [JHUtility hiddenGifProgressViewInView:DEF_Window];

    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {

        [JHUtility hiddenGifProgressViewInView:DEF_Window];

        JHBoss_PayMethodHelper *hepler = [[JHBoss_PayMethodHelper alloc] init];
        NSMutableArray *payArr         = [hepler fetchPayMethodDataSourcesWithoutZFB:YES];
        
        [self.dataSources addObjectsFromArray:@[@[],@[],payArr]];
        
        [self.tableView reloadData];
    }];
}

//获取打赏订单号和金额
- (void)rewardStr:(NSString *)contentStr {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:contentStr   forKey:@"bountyId"];
    [param setValue:self.userId  forKey:@"customerId"];
    [param setValue:self.staffId forKey:@"waiterId"];
    [param  setValue:@(3) forKey:@"dataSource"];//表示boss打赏
    [JHUtility showGifProgressViewInView:self.view];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param
                                    path:JH_rewardMoneyURL
                           isShowLoading:NO
                             isNeedCache:NO
                                 success:^(id object) {
                                     
        @strongify(self);
                                     
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            [self wxorder:@{@"tradeCode":dic[@"data"][@"orderNo"]}];
            
        }else{
        
            [JHUtility hiddenGifProgressViewInView:self.view];

        }
        
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];
    }];
}


//微信统一下单接口
- (void)wxorder:(NSDictionary *)dic {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"APP"           forKey:@"tradeType"];//订单类型 APP支付
    [param setValue:dic[@"tradeCode"]  forKey:@"orderNo"];//订单号
    if (self.payType == KPayMethodType_Top_UP ) {
        
      [param setValue:@"7" forKey:@"billType"];//支付类型，此次钱包充值
    }else{
    
      [param setValue:@"8" forKey:@"billType"];//支付类型，此次打赏
    }
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param
                                    path:JH_WXPayURL
                           isShowLoading:NO
                             isNeedCache:NO
                                 success:^(id object) {
        
        @strongify(self);
        
        NSDictionary *dic = object;
        
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            [self WXpayOrderInfo:dic[@"data"]];
        }else{
        
         [JHUtility hiddenGifProgressViewInView:self.view];
        }
            
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];
    }];
}

//调取微信支付
-(void)WXpayOrderInfo:(NSDictionary *)dic{
     self.wxPrepaymentDic = dic;
    PayReq *request = [[PayReq alloc] init] ;
    request.partnerId = dic[@"partnerid"];
    request.prepayId  = dic[@"prepayid"];
    request.package   = @"Sign=WXPay";
    request.nonceStr  = dic[@"noncestr"];
    request.timeStamp = [dic[@"timestamp"] intValue];
    request.sign      = dic[@"sign"];
    [WXApi sendReq:request];
    [JHUtility hiddenGifProgressViewInView:self.view];
}


#pragma mark -- Alipay-----
//阿里下单接口
- (void)alipayOrder:(NSDictionary *)dic {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:@"APP"           forKey:@"tradeType"];//订单类型 APP支付
    [param setValue:dic[@"tradeCode"]  forKey:@"orderNo"];//订单号
    [param setValue:@(7) forKey:@"billType"];//支付类型，此次为钱包充值
    
    @weakify(self);
    
    [JHHttpRequest postRequestWithParams:param
                                    path:JH_AlipayURL
                           isShowLoading:NO
                             isNeedCache:NO
                                 success:^(id object) {
                                     
                                     @strongify(self);
                                     
                                     NSDictionary *dic = object;
                                     
                                     if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
                                         
                                         
                                         [self alipayOrderInfo:dic[@"data"]];
                                     }else{
                                     
                                       [JHUtility hiddenGifProgressViewInView:self.view];
                                     }
                                     
                                     
                                     
                                     
                                 } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
                                             [JHUtility hiddenGifProgressViewInView:self.view];
                                 }];
}

//调起阿里支付
-(void)alipayOrderInfo:(NSString *)orderInfo{
 
    [JHUtility hiddenGifProgressViewInView:self.view];
    @weakify(self)
    [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:@"JHBossAliPay" callback:^(NSDictionary *resultDic) {
        @strongify(self)
        DPLog(@"resultDic=====%@",resultDic);
        if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
            
           
            [JHBoss_PayResultCheckout checkoutAlipayResult:resultDic[@"result"] checkResut:^(BOOL isSucc) {
                
                [self payResultReminderIsSucc:isSucc];
            }];
        }
    }];
}

//向用户展示支付结果
-(void)payResultReminderIsSucc:(BOOL)isSucc{

    if (self.payType == kPayMethodType_Employees_Reward) {
        //员工打赏
        NSString *title;
        NSString *imageStr;
        if (isSucc) {
            
            title = @"打赏成功!";
            imageStr = @"4.2.2_icon_chenggon";
        }else{
        
            title = @"支付失败 请重试";
            imageStr = @"4.2.2_icon_shibai";
        }
        JHBoss_PayResultAlertView *alert = [[JHBoss_PayResultAlertView alloc]initWithTitle:title image:imageStr btnTitle:@"确定"];
        [alert show];
        
    }else{
        NSString *title;
        NSString *imageStr;
        if (isSucc) {
            
            [self requestWalletOrNoteNumber];
            
            title = @"钱包充值成功!";
            imageStr = @"4.2.2_icon_chenggon";
        }else{
            
            title = @"支付失败 请重试";
            imageStr = @"4.2.2_icon_shibai";
        }
        JHBoss_PayResultAlertView *alert = [[JHBoss_PayResultAlertView alloc]initWithTitle:title image:imageStr btnTitle:@"确定"];
        [alert show];
    
    }
}

//获取钱包充值金额
- (void)loadFetchMoneyCount {
    [JHHttpRequest postRequestWithParams:@{}
                                    path:JH_WalletRechargeMoneyListURL
                           isShowLoading:NO
                             isNeedCache:NO
                                 success:^(id object) {
                                     
                                     NSDictionary *dic = object;
                                     
                                     if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
                                         
                                         self.moneyArray = dic[@"data"];
                                         
                                         JHBoss_PayMethodHelper *hepler = [[JHBoss_PayMethodHelper alloc] init];
                                         NSMutableArray *payArr         = [hepler fetchPayMethodDataSourcesWithoutZFB:NO];
                                         
                                         NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
                                         
                                         for (NSDictionary *moneyDic in self.moneyArray) {
                                             [tmpArray addObject:[NSString stringWithFormat:@"¥ %g",[moneyDic[@"name"] floatValue]/100]];
                                         }
                                         NSString *normalMoney = self.moneyArray.firstObject[@"name"];
                                         
                                         self.footView.payCount = [normalMoney floatValue]/100;
                                         self.footView.payID = (NSInteger)self.moneyArray.firstObject[@"bountyId"];
                                         [self.dataSources addObjectsFromArray:@[@[],tmpArray,payArr]];
                                         
                                         [self.tableView reloadData];
                                     }
                                     
                                     [self requestWalletOrNoteNumber];

                                 } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
                                     [JHUtility hiddenGifProgressViewInView:DEF_Window];

                                     JHBoss_PayMethodHelper *hepler = [[JHBoss_PayMethodHelper alloc] init];
                                     NSMutableArray *payArr         = [hepler fetchPayMethodDataSourcesWithoutZFB:NO];
                                     [self.dataSources addObjectsFromArray:@[@[],@[],payArr]];
                                     
                                    [self.tableView reloadData];
                                     
                                    [self requestWalletOrNoteNumber];
                                
                                 }];
    
}

//请求钱包充值获取订单号
- (void)requestTopUPWithCount:(CGFloat)count {

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:@"1"             forKey:@"tradeType"];//充值类型
    [param setValue:self.userId      forKey:@"userAccount"];//用户ID
    [param setValue:self.merchanId   forKey:@"merchantId"];//商户ID
    //转成分
    [param setValue:[NSString stringWithFormat:@"%g",count] forKey:@"tradeAmount"];//充值金额
    
    
    [JHUtility showGifProgressViewInView:self.view];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param
                                    path:JH_WalletOrBuyURL
                           isShowLoading:NO isNeedCache:NO
                                 success:^(id object) {
                                     @strongify(self);
                                     NSDictionary *dic = object;
                                     
                                     if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
                                     
                                         if (self.payMethod) {
                                             
                                           [self alipayOrder:dic[@"data"]];
                                         }else{
                                         
                                             [self wxorder:dic[@"data"]];
                                         }
                                         
                                         
                                     }else{
                                     
                                     [JHUtility hiddenGifProgressViewInView:self.view];
                                     }
                                     
                                                                          
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];

    }];
}

#pragma mark - Delegate
//MARK:UITableViewDataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.payType) {
        case KPayMethodType_Top_UP:
        {
            return section == 2 && _isStalledWX ? 2 : 1;
        }
            break;
            
        case kPayMethodType_Employees_Reward:
        {
            return 1;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0;
    
    switch (indexPath.section) {
        case 0:
        {
            switch (self.payType) {
                case KPayMethodType_Top_UP:
                {
                    height = 80;
                }
                    break;
                    
                case kPayMethodType_Employees_Reward:
                {
                    height = 100;
                }
                    break;
            }
        }
            break;
        case 1:
        {
            CGFloat tmpHeight = ceilf([self.dataSources[indexPath.section] count]/3.0) * 60;
            
            height = (tmpHeight < 70) ? 70 : tmpHeight;
        }
            break;
        case 2:
        {
            height = 60;
        }
            break;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *baseCell  = nil;
    
    switch (indexPath.section) {
        case 0:
        {
        
            switch (self.payType) {
                case KPayMethodType_Top_UP:
                {
                    JHBoss_RechargeTableViewCell *rechargeCell = [tableView dequeueReusableCellWithIdentifier:kRechargeTableViewCellID];
                    
                    rechargeCell.rechargeDetail = _moneyCount;
                    
                    baseCell = rechargeCell;
                
                }
                    break;
                    
                case kPayMethodType_Employees_Reward:
                {
                    JHBoss_EmployeesRewardCell *employeesCell = [tableView dequeueReusableCellWithIdentifier:kPayEmployeesTableViewCellID];
                    
                    [employeesCell showDetailWithNickName:self.staffName iconStr:self.staffPictureUrl];
                    
                    baseCell = employeesCell;
                }
                    break;
            }
        }
            break;
            
        case 1:
        {
            JHBoss_PayCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPayCountTableViewCellID];

            @weakify(self);
            [cell showPayCountWithDataSource:self.dataSources[indexPath.section]];
            
            [cell setPayCountBlock:^(CGFloat payCount, NSInteger payID){
            
                @strongify(self);
                
                self.footView.payCount = payCount;
                self.footView.payID    = payID;
                
            }];
            
            baseCell = cell;
            
        }
            break;
        case 2:
        {
            JHBoss_PayMethodTableViewCell *payCell = [tableView dequeueReusableCellWithIdentifier:kPayMethodTableViewCellID];
            
            payCell.payItem = self.dataSources[indexPath.section][indexPath.row];
            baseCell        = payCell;

        }
            break;
    }
    
    baseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return baseCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return section == 2?100:10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return section == 2?self.footView:nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        JHBoss_PayMehtodItem *changeItem = self.dataSources[indexPath.section][indexPath.row];
        
        for (JHBoss_PayMehtodItem *item in self.dataSources[indexPath.section]) {
            item.hight = NO;
        }
        
        changeItem.hight = YES;
        NSIndexSet *set  = [NSIndexSet indexSetWithIndex:indexPath.section];
        if (_isStalledWX) {
            
            self.payMethod = (indexPath.row != 0);
        }else{
            self.payMethod = YES;
        }
        
        
        [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma mark - Setter And Getter

- (NSMutableArray *)dataSources {
    
    if (!_dataSources) {
        
        _dataSources = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSources;
}

- (JHBoss_PayMethodFooterView *)footView {
    
    if (!_footView) {
        _footView          = [[JHBoss_PayMethodFooterView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 100)];
        switch (self.payType) {
            case KPayMethodType_Top_UP:
            {
                _footView.methodType = kChooseMethodType_TOP_UP;;
                _footView.payCount   = 0;
            }
                break;
                
            case kPayMethodType_Employees_Reward:
            {
                _footView.methodType = kChooseMethodType_Employees;
                _footView.payCount   = 0;
            }
                break;
        }
        
        @weakify(self);
        
        [_footView setFootViewBlock:^(NSInteger tag, CGFloat payCount){
            @strongify(self);
            switch (tag) {
                case 100:
                {
                    NSLog(@"进入了解详情页面");
                }
                    break;
                    
                case 200:
                {
                    if (self.payMethod) {
                        NSLog(@"支付宝:支付 %f",payCount);
                        switch (self.payType) {
                            case KPayMethodType_Top_UP:
                            {
                                //调用充值接口
                                [self requestTopUPWithCount:payCount];
                            }
                                break;
                                
                            case kPayMethodType_Employees_Reward:
                            {
                                //调用员工打赏
                                 [self rewardStr:[NSString stringWithFormat:@"%ld",(long)self.footView.payID]];
                            }
                                break;
                        }
                        
                    } else {
                        NSLog(@"微信:支付 %f",payCount);
                        switch (self.payType) {
                            case KPayMethodType_Top_UP:
                            {
                                //调用充值接口
                                 [self requestTopUPWithCount:(NSInteger)payCount];
                            }
                                break;
                                
                            case kPayMethodType_Employees_Reward:
                            {
                                //调用员工打赏
                                 [self rewardStr:[NSString stringWithFormat:@"%ld",(long)self.footView.payID]];
                            }
                                break;
                        }
                        
                    }
                    
                }
                    break;
            }
            
        }];
        
    }
    
    return _footView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];

        [_tableView registerClass:[JHBoss_RechargeTableViewCell class] forCellReuseIdentifier:kRechargeTableViewCellID];
        [_tableView registerClass:[JHBoss_PayCountTableViewCell class] forCellReuseIdentifier:kPayCountTableViewCellID];
        [_tableView registerClass:[JHBoss_PayMethodTableViewCell class] forCellReuseIdentifier:kPayMethodTableViewCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"JHBoss_EmployeesRewardCell"
                                               bundle:nil] forCellReuseIdentifier:kPayEmployeesTableViewCellID];
    }
    
    return _tableView;
}

- (JHUserInfoData *)userInfo {
    
    if (!_userInfo) {
        _userInfo = [[JHUserInfoData alloc]init];
    }
    
    return _userInfo;
}

- (NSMutableArray *)moneyArray {

    if (!_moneyArray) {
        
        _moneyArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _moneyArray;
}

-(void)onClickLeftNavButton:(UIButton *)leftNavButton{

    if (self.refreshWalletMoneyHanlder) {
        self.refreshWalletMoneyHanlder(self.moneyCount, self.residueMessageCount);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Dealloc




@end
