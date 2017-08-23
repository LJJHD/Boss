//
//  JHBoss_PayMessageViewController.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PayMessageViewController.h"

#import "JHBoss_PayMessageTableViewCell.h"
#import "JHBoss_ChooseMessageTableViewCell.h"

#import "JHBoss_PayMessageItem.h"
#import "JHBoss_PayMessageHelper.h"

#import "JHBoss_RecordViewController.h"
#import "JHBoss_RechargeViewController.h"
#import "JHBoss_WalletBalanceModel.h"
#import "JHUserInfoData.h"
#import "JHBoss_WalletBalanceModel.h"
#import "JHBoss_PayResultAlertView.h"
static NSString * const kPayMessageTableViewCellID    = @"kPayMessageTableViewCellID";
static NSString * const kChooseMessageTableViewCellID = @"kChooseMessageTableViewCellID";

@interface JHBoss_PayMessageViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    JHBoss_PayMessageTableViewCellDelegate,
    JHBoss_ChooseMessageTableViewCellDelegate
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *messageFooterView;
@property (nonatomic, strong) UIView *payBtnFooterView;

@property (nonatomic, strong) NSMutableArray *payViewDataSources;

@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) NSString *sellCount;//支付的费用
@property (nonatomic, copy)   NSString *buyNoteNumber;//所得短信数量，包括赠送的短信数量
@property (nonatomic, strong) JHUserInfoData *userInfo;
@property (nonatomic, copy)   NSString *userId;

@property (nonatomic, strong) JHBoss_WalletBalanceModel *walletBalanceMd;
//剩余短息条数
@property (nullable, nonatomic, copy) NSString * residueMessageCount;
@property (nullable, nonatomic, copy) NSString *moneyCount;
@end

@implementation JHBoss_PayMessageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}

#pragma mark - Life Cycle

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
    [self requestUserInfo];
    [self defaultConfig];
    [self requestWalletOrNoteNumber];
    [self loadFetchMessageCount];
    
    [self createUI];
}

#pragma mark - Private Method

- (void)defaultConfig {
    
    self.jhtitle              = @"短信购买";
    self.sellCount            = @"100";
    self.view.backgroundColor = [UIColor colorWithRGBValue:244 g:244 b:244];
    
    [self.rightNavButton setimage:@"nav_icon_gengduo"];
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

- (void)onClickRightNavButton:(UIButton *)rightNavButton {
    
    JHBoss_RecordViewController *recordVC = [[JHBoss_RecordViewController alloc] init];
    recordVC.merchanId = self.merchanId;
    recordVC.recordTittle = @"短信使用记录";
    recordVC.recordType = JHBoss_recordType_noteRecord;
    [self.navigationController pushViewController:recordVC animated:YES];
    
}

//改变状态
- (void)changePayItemWithItem:(JHBoss_PayMessageItem *)item {
    
    for (JHBoss_PayMessageItem *tmpItem in self.payViewDataSources) {
        tmpItem.select = NO;
    }
    
    item.select = YES;
}

//进行支付
- (void)clickFooterButton:(UIButton *)btn {
    [self requestTopUPWithCount:[self.sellCount integerValue]];
    
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
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}


//获取钱包数量
- (void)loadFetchMessageCount {
    
    [JHHttpRequest postRequestWithParams:@{}
                                    path:JH_NoteNumAndMoneyListURL
                           isShowLoading:NO
                             isNeedCache:NO
                                 success:^(id object) {
                                     
                                     NSDictionary *dic = object;
                                     
                                     if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
                                         
                                         self.payViewDataSources = [JHBoss_PayMessageItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
                                         
                                         JHBoss_PayMessageItem *lastItem = self.payViewDataSources.firstObject;
                                         lastItem.select = YES;
                                         
                                         [self.payButton setTitle:[NSString stringWithFormat:@"确认支付 ¥%g",([lastItem.sellCount floatValue]/100)]];
                                         self.sellCount = lastItem.sellCount;
                                          self.buyNoteNumber = [NSString stringWithFormat:@"%d",lastItem.messageCount.intValue + lastItem.residueCount.intValue];
                                         [self.tableView reloadData];
                                     }
                                     
                                 } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
                                     
                                     self.payViewDataSources = [@[] mutableCopy];
                                     
                                     [self.tableView reloadData];
                                     
                                 }];
}


//请求短信充值
- (void)requestTopUPWithCount:(NSInteger)count {
    
    [JHUtility showGifProgressViewInView:self.view];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"2"             forKey:@"tradeType"];//充值类型 购买短信
    [param setValue:self.userId      forKey:@"userAccount"];//用户ID
    [param setValue:self.merchanId   forKey:@"merchantId"];//商户ID
    [param setValue:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"tradeAmount"];//充值金额
    [param setValue:self.buyNoteNumber forKey:@"tradeNum"];//购买短信条数
    [JHHttpRequest postRequestWithParams:param
                                    path:JH_WalletOrBuyURL
                           isShowLoading:NO isNeedCache:NO
                                 success:^(id object) {
                                     
                                     NSDictionary *dic = object;
                                     if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
                                     
                                        [self payResultReminderIsSucc:YES message:dic[@"showMsg"]];
                                     }else{
                                     
                                        [self payResultReminderIsSucc:NO message:dic[@"showMsg"]];
                                     }
                                         
                                     [JHUtility hiddenGifProgressViewInView:self.view];
                                     
                                 } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
                                     
                                     [JHUtility hiddenGifProgressViewInView:self.view];
                                      [self payResultReminderIsSucc:YES message:@""];
                                 }];
}

//向用户展示支付结果
-(void)payResultReminderIsSucc:(BOOL)isSucc message:(NSString *)message{
    
    NSString *title;
    NSString *imageStr;
    NSString *btnTitleStr;
    
    if (isSucc) {
        
        [self requestWalletOrNoteNumber];
        title = message;
        imageStr = @"4.2.2_icon_chenggon";
        btnTitleStr = @"确定";
    }else{
        
        title = message;
        imageStr = @"4.2.2_icon_shibai";
        btnTitleStr = @"去充值";
    }
    if (message.length > 0) {
        title = message;
    }
        JHBoss_PayResultAlertView *alert = [[JHBoss_PayResultAlertView alloc]initWithTitle:title image:imageStr btnTitle:btnTitleStr];
    @weakify(self);
       alert.sureHandler = ^{
           @strongify(self);
           if (!isSucc) {
               
               JHBoss_RechargeViewController *rechargeVC = [[JHBoss_RechargeViewController alloc] init];
               rechargeVC.payType    = KPayMethodType_Top_UP;
               rechargeVC.merchanId = self.merchanId;
               [self.navigationController pushViewController:rechargeVC animated:YES];
           }
       };
        [alert show];
        
}



#pragma mark - Public Method

#pragma mark - Delegate

//UITableViewDataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0?160:((ceilf(self.payViewDataSources.count/2.0) * 125) < 60?60:((ceilf(self.payViewDataSources.count/2.0) * 125)));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        JHBoss_PayMessageTableViewCell *payMessageCell = [tableView dequeueReusableCellWithIdentifier:kPayMessageTableViewCellID];
        
        [payMessageCell showMessageCount:self.residueMessageCount moneyCount:self.moneyCount];
        
        payMessageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        payMessageCell.delegate = self;
        
        return payMessageCell;
        
    } else {
    
        JHBoss_ChooseMessageTableViewCell *chooseCell = [tableView dequeueReusableCellWithIdentifier:kChooseMessageTableViewCellID];
        
        chooseCell.selectionStyle = UITableViewCellSelectionStyleNone;

        [chooseCell showDetailWithPayMessageItemArray:self.payViewDataSources indexPath:indexPath];
        
        chooseCell.delegate = self;
        
        return chooseCell;
    }

}

//UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 0?50:80;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return section == 0?self.messageFooterView:self.payBtnFooterView;
    
}

//MARK:JHBoss_PayMessageTableViewCellDelegate

- (void)payMessageTableViewCell:(JHBoss_PayMessageTableViewCell *)messageCell {
    
    JHBoss_RechargeViewController *rechargeVC = [[JHBoss_RechargeViewController alloc] init];
    rechargeVC.payType    = KPayMethodType_Top_UP;
    rechargeVC.merchanId = self.merchanId;
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

//MARK:JHBoss_ChooseMessageTableViewCellDelegate
- (void)chooseMessageTableViewCellDelegate:(JHBoss_ChooseMessageTableViewCell *)chooseCell
                                   payItem:(JHBoss_PayMessageItem *)item
                                 indexPath:(nonnull NSIndexPath *)index {

    //显示
    [self.payButton setTitle:[NSString stringWithFormat:@"确认支付 ¥%g",[item.sellCount floatValue]/100]];
    
    //进行关联
    self.sellCount = item.sellCount;
    self.buyNoteNumber = [NSString stringWithFormat:@"%d",item.messageCount.intValue + item.residueCount.intValue];
}

#pragma mark - Setter And Getter

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate        = self;
        _tableView.dataSource      = self;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[JHBoss_PayMessageTableViewCell class] forCellReuseIdentifier:kPayMessageTableViewCellID];
        [_tableView registerClass:[JHBoss_ChooseMessageTableViewCell class] forCellReuseIdentifier:kChooseMessageTableViewCellID];
    }
    
    return _tableView;
}

- (UIView *)payBtnFooterView {
    
    if (!_payBtnFooterView) {
     
        _payBtnFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 80)];
        
        UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        payBtn           = [UIButton buttonWithType:UIButtonTypeCustom];
        payBtn.frame     = CGRectMake(30, 15, DEF_WIDTH - 30*2, 40);
        payBtn.layer.cornerRadius  = 20;
        payBtn.layer.masksToBounds = YES;
        [payBtn setBackgroundColor:[UIColor colorWithRGBValue:205 g:162 b:101]];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [payBtn addTarget:self
                              action:@selector(clickFooterButton:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        [payBtn setTitle:@"确认支付 ¥0"];
        //进行关联
        self.payButton = payBtn;
        [_payBtnFooterView addSubview:payBtn];
    }
    
    return _payBtnFooterView;
}

- (UIView *)messageFooterView {

    if (!_messageFooterView) {
        
        _messageFooterView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 50)];
        UILabel *messageLbl  = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DEF_WIDTH, 50)];
        
        messageLbl.text          = @"短信购买(0.1元 / 条)";
        messageLbl.font          = [UIFont systemFontOfSize:15];
        messageLbl.textColor     = [UIColor colorWithRGBValue:161 g:161 b:161];
        messageLbl.textAlignment = NSTextAlignmentLeft;
        
        [_messageFooterView addSubview:messageLbl];
        
    }
    
    return _messageFooterView;
}

- (NSMutableArray *)payViewDataSources {
    
    if (!_payViewDataSources) {
        
        _payViewDataSources = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _payViewDataSources;
}

-(JHUserInfoData *)userInfo{

    if (!_userInfo) {
        _userInfo = [[JHUserInfoData alloc]init];
    }
    return _userInfo;
}

#pragma mark - Dealloc

-(void)onClickLeftNavButton:(UIButton *)leftNavButton{
    
    if (self.refreshWalletMoneyHanlder) {
        self.refreshWalletMoneyHanlder(self.moneyCount, self.residueMessageCount);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
