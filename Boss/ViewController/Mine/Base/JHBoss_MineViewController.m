//
//  JHBoss_MineViewController.m
//  Boss
//
//  Created by sftoday on 2017/4/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_MineViewController.h"
#import "JHBoss_PersonalCenterViewController.h"
#import "JHBoss_SuggestViewController.h"
#import "JHBoss_SettingViewController.h"
#import "JHBoss_AboutUsViewController.h"
#import "JHBoss_UserInfoModel.h"
#import "JHBoss_TemsForUsageViewController.h"
#import "JHCRM_MineMainModel.h"
#import "JHCRM_MineMainCell.h"
#import "JHBoss_AppreciationServiceViewController.h"
#import "JHUserInfoData.h"
#import "JHBoss_WalletBalanceModel.h"
@interface JHBoss_MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *bossNameLabel;
@property (nonatomic, strong) UILabel *positionLB;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UILabel *settingLB;
@property (nonatomic, strong) JHBoss_UserInfoModel *userModel;
@property (nonatomic, strong) JHUserInfoData *userInfo;
@property (nonatomic, copy)    NSString *merchanId;//商户id
@property (nonatomic, strong) JHBoss_WalletBalanceModel *walletBalanceMd;
@property (nonatomic, assign) BOOL isShow;//是否显示增值服务
@end

@implementation JHBoss_MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 消除状态栏20像素偏移影响
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:view];
    [self userInfoData];
    [self requestGetUserInfo];
    
    [self displayControl];
   
    [self setup];
}


#pragma mark - request
//获取用户登录信息
-(void)requestMerchanId{

    @weakify(self);
    [self.userInfo getUserInfoIdentify:saveUserIdentify result:^(NSDictionary *result) {
        @strongify(self);
        self.merchanId = result[@"merchantId"];
        
        [self requestWalletOrNoteNumber];
        
    }];
}

// 获取个人信息
- (void)requestGetUserInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [JHHttpRequest postRequestWithParams:param path:JH_GetUserInfo isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            self.userModel = [JHBoss_UserInfoModel mj_objectWithKeyValues:dic[@"data"]];
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

// 是否显示增值服务，用于苹果审核
- (void)displayControl
{
    @weakify(self)
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [JHHttpRequest postRequestWithParams:param path:JH_IsShow_appreciationURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self)
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if ([dic[@"data"] intValue] == 1) {
                //审核中
                self.isShow = NO;
                
            }else if ([dic[@"data"] intValue] == 0){
                //审核通过
                self.isShow = YES;
                [self requestMerchanId];
            }
        }
         [self userInfoData];
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
//        [self displayControl];
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
            NSArray *arr = self.dataArray.firstObject;
            JHCRM_MineMainModel *model = arr.firstObject;
            NSString *walletMoneyStr = @"钱包余额 ";
            float balance = self.walletBalanceMd.balance.floatValue / 100;
            model.titleDel = [[walletMoneyStr stringByAppendingString:[NSString stringWithFormat:@"%g",balance]] stringByAppendingString:@"元"];
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

#pragma mark - UI

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [MobClick beginLogPageView:@"我的"];
}

-(void)viewDidDisappear:(BOOL)animated{

    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"我的"];
}

- (void)setup
{
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(-470);
    }];
}

-(JHUserInfoData *)userInfo{

    if (!_userInfo) {
        _userInfo = [[JHUserInfoData alloc]init];
    }
    return _userInfo;
}


#pragma mark - tableviewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _isShow ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isShow) {
      
        if (!section) {
            return [self.dataArray[0] count];
        }else{
            
            return [self.dataArray[1] count];
        }
        
    } else {

        return [self.dataArray[0] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    JHCRM_MineMainCell *cell = [JHCRM_MineMainCell cellWithTableView:tableView];
    cell.model = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isShow) {
     
        if (!section) {
            return 654;
        }else{
        
          return 0.0001;
        }

    } else {
        
        return 654;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_isShow) {
     
        if (!section) {
            return 10;
        }else{
            
            return 0.001;
        }
        
    }else{
    
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (!section) {
        
        UIView *view = [[UIView alloc] init];
        
        [view addSubview:self.headerView];
        [_headerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.top.mas_equalTo(0);
            make.height.mas_equalTo(644);
        }];
        
        return view;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!indexPath.section && _isShow) {
        
        JHBoss_AppreciationServiceViewController *appSVC = [[JHBoss_AppreciationServiceViewController alloc]init];
        appSVC.merchanId = self.merchanId;
        appSVC.moneyCount = [NSString stringWithFormat:@"%g",self.walletBalanceMd.balance.floatValue];
        appSVC.residueMessageCount = self.walletBalanceMd.remainderAmount.stringValue;
        appSVC.refreshWalletMoneyHanlder = ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self requestWalletOrNoteNumber];
            });
        };
        [self.navigationController pushViewController:appSVC animated:YES];
        
    }else{
        
        switch (indexPath.row) {
            case 0:
            {
                JHBoss_PersonalCenterViewController *personalCenterVC = [[JHBoss_PersonalCenterViewController alloc] init];
                personalCenterVC.model = self.userModel;
                [self.navigationController pushViewController:personalCenterVC animated:YES];
            }
                break;
            case 1:
            {
                JHBoss_SuggestViewController *suggestVC = [[JHBoss_SuggestViewController alloc] init];
                [self.navigationController pushViewController:suggestVC animated:YES];
            }
                break;
            case 2:
            {
                JHBoss_TemsForUsageViewController *temsFUVC = [[JHBoss_TemsForUsageViewController alloc]init];
                temsFUVC.protocalType = JHBoss_protocalType_UseProtocal;
                [self.navigationController pushViewController:temsFUVC animated:YES];
            }
                break;
            case 3:
            {
                JHBoss_AboutUsViewController *aboutUsVC = [[JHBoss_AboutUsViewController alloc] init];
                [self.navigationController pushViewController:aboutUsVC animated:YES];
            }
                break;
                
            default:
                break;
        }

       
    }
}


#pragma mark - setter/getter

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//给dataArr赋值
-(void)userInfoData{
    
     NSMutableArray *shopArr = [[NSMutableArray alloc] init];
    if (_isShow ) {
        NSArray *shopTitleArr = @[@"增值服务"];
        NSArray *shopInfoArr =  @[@""];
        NSArray *shopTypeArr =  @[[NSNumber numberWithInteger:PersonalCenterCellType_Icon_Title_DescribeLb_Arrow]];
        for (int i = 0; i < shopTitleArr.count; i++) {
            JHCRM_MineMainModel *model = [[JHCRM_MineMainModel alloc] init];
            model.title = shopTitleArr[i];
            model.iconName = @"4.0_icon_zengzhi";
            model.personalCenterCellType = [shopTypeArr[i] integerValue];
            model.titleDel = shopInfoArr[i];
            model.titleFont = [UIFont systemFontOfSize:15];
            model.titleDelFont = [UIFont systemFontOfSize:13];
            model.titleColor = DEF_COLOR_6E6E6E;
            model.titleDelColor = DEF_COLOR_A1A1A1;
            [shopArr addObject:model];
        }
        
    }
   
    NSMutableArray *contactInfoArr = [[NSMutableArray alloc] init];
    NSArray *titleArr = @[@"个人资料",@"意见建议",@"使用条款",@"关于晶汉"];
    NSArray *iconArr = @[@"5.1_icon_gerenziliao",@"5.1_icon_yijianjianyi",@"5.1_icon_shiyongtiaokuan",@"5.1_icon_guanyjinghan"];
    NSArray *typeArr = @[[NSNumber numberWithInteger:PersonalCenterCellType_Icon_Title_DescribeLb_Arrow],[NSNumber numberWithInteger:PersonalCenterCellType_Icon_Title_DescribeLb_Arrow],[NSNumber numberWithInteger:PersonalCenterCellType_Icon_Title_DescribeLb_Arrow],[NSNumber numberWithInteger:PersonalCenterCellType_Icon_Title_DescribeLb_Arrow]];
    for (int i = 0; i < titleArr.count; i++) {
        JHCRM_MineMainModel *model = [[JHCRM_MineMainModel alloc] init];
        model.title = titleArr[i];
        model.iconName = iconArr[i];
        model.personalCenterCellType = [typeArr[i] integerValue];
        model.titleFont = [UIFont systemFontOfSize:15];
        model.titleColor = DEF_COLOR_6E6E6E;
        [contactInfoArr addObject:model];
    }
    if (_isShow) {
        [self.dataArray removeAllObjects];
      self.dataArray = [NSMutableArray arrayWithObjects:shopArr,contactInfoArr, nil];
  
    }else{
    
      self.dataArray = [NSMutableArray arrayWithObjects:contactInfoArr, nil];
    }
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

- (UIView *)headerView
{
    if (!_headerView) {
        @weakify(self);
        _headerView = [[UIView alloc] init];
        UIImage *image = [UIImage imageNamed:@"5.1_bg_bg"];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(DEF_WIDTH, 644), NO, 0.f);
        [image drawInRect:CGRectMake(0, 0, DEF_WIDTH, 644)];
        UIImage *lastImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _headerView.backgroundColor = [UIColor colorWithPatternImage:lastImage];
        
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
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
        [[_settingBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self settingAction];
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
        _settingLB.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] init];
        [tapGR addTarget:self action:@selector(settingAction)];
        [_settingLB addGestureRecognizer:tapGR];
        
    }
    // init
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.userModel.photo] placeholderImage:DEF_IMAGENAME(@"5.1_icon_gerenziliao")] ;
    _bossNameLabel.text = self.userModel.nickName ? self.userModel.nickName : self.userModel.userName;
    _positionLB.text = self.userModel.userName;
    [_settingBtn setimage:@"5.1_icon_setting"];
    _settingLB.text = @"设置";
    return _headerView;
}


#pragma mark - other

- (void)settingAction
{
    JHBoss_SettingViewController *settingVC = [[JHBoss_SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

//隐藏导航条
-(BOOL)disableAutomaticSetNavBar{
    
    return YES;
}


@end
