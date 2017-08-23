//
//  JHBoss_GeneralViewController.m
//  Boss
//
//  Created by sftoday on 2017/4/28.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_GeneralViewController.h"
#import "JHBoss_NotificationReminderViewController.h"
#import "JHBoss_DataDetailsViewController.h"
#import "JHBoss_PhysicalExaminationViewController.h"
#import "JHBoss_ExaminationResultViewController.h"
#import "JHBoss_ApproveViewController.h"
#import "JHBoss_RestaurantModel.h"
#import "JHBoss_MenuOrderDetailViewController.h"
#import "JHBoss_AboutUsViewController.h"
#import "JHBoss_OrderListModel.h"
#import "JHBoss_GeneralModel.h"
//1.2
#import "JHBoss_TurnoverTableViewCell.h"
#import "JHBoss_HomeChartTableViewCell.h"
#import "JHBoss_HomeOrderAbnormalView.h"
#import "JHBoss_HomeDishesSectionHeaderView.h"
#import "JHBoss_DishesRangkingTableViewCell.h"
#import "JHBoss_HomeChartTableViewCell.h"
#import "JHBoss_DataDetailsViewController.h"
#import "JHBoss_DishesViewController.h"
#import "JHBoss_DishModel.h"
#import "JHBoss_DishDetailsViewController.h"
#import "JHBoss_OrderAndCommentListViewController.h"
#import "JHBoss_ChoiceRestView.h"
#import "JHBoss_RestPickerAppearance.h"
#import "JHBoss_ClientAnalyzeViewController.h"
#import "HCGDatePickerAppearance.h"
#import "JHUserInfoData.h"
#import "JHBoss_MerchatBusinessDataModel.h"
#import "JHBoss_VersionUpdate.h"
#import <WXApi.h>
//tableview距离屏幕底部的距离
static const float tableBottomDistanc = -62;

@interface JHBoss_GeneralViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *funArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *touchPoints;
@property (nonatomic, strong) UIView *coverHeraderRefreshView;
// 请求参数
@property (nonatomic, assign) BOOL isNoDisturb; // 勿扰
@property (nonatomic, copy) NSString *time; // 日期
@property (nonatomic, strong) NSMutableArray *dataIdList; // 数据排序
@property (nonatomic, copy) NSMutableArray<JHBoss_RestaurantModel *> *restaurantArray; // 餐厅数组
@property (nonatomic, copy) NSString  *restaurantId; // 选中的餐厅id;
@property (nonatomic, copy) NSString *merchanId;
@property (nonatomic, strong) JHBoss_MerchatBusinessDataModel *merchatBusDataModel;//餐厅运营数据model

@property (nonatomic, assign) BOOL loading; // 是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView; // 数据加载过程中显示加载动画的view
//1.2
@property (nonatomic, strong) JHBoss_HomeDishesSectionHeaderView *dishesSectionHeaderView;//菜品排行区头
@property (nonatomic, strong) JHBoss_HomeOrderAbnormalView *orderAbnormalView;//订单异常区尾
@property (nonatomic, strong) JHBoss_HomeOrderAbnormalView *clientFlowView;//客流量
@property (nonatomic, strong) NSMutableArray *dishesDataArr;//菜品排行数组

//筛选栏
@property (nonatomic, strong) JHBoss_ChoiceRestView *choiceRestView;//选择餐厅的view
@property (nonatomic, strong) JHBoss_RestPickerAppearance *restPicker;//餐厅选择器
@property (nonatomic, strong) HCGDatePickerAppearance *datePicker;//时间选择器
@property (nonatomic, copy)   NSString *BegainSelectedDate;//选中的开始日期
@property (nonatomic, copy)   NSString *EndSelectedDate;//选中的结束日期
@property (nonatomic, strong) JHUserInfoData *userInfo;
@property (nonatomic, strong) NSDictionary *restInfoDic;//存储选择的餐厅信息(从本地取的)
//动画效果属性
@property (nonatomic, assign) CGFloat lastContentOffSetY;
//记录改变值
@property (nonatomic, assign) CGFloat changeOffset;
//
@property (nonatomic, assign) BOOL directionUP;
@end

@implementation JHBoss_GeneralViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"首页"];
    if (isObjNotEmpty(self.restInfoDic)) {
         self.restInfoDic = [JHUserInfoData getCurrentSelectRestInfo];
        if (![self.restaurantId isEqualToString:self.restInfoDic[@"restId"]]) {
            //选择的餐厅出现改变，更换restid
            self.restaurantId = self.restInfoDic[@"restId"];
            self.choiceRestView.restName = self.restInfoDic[@"restName"];
            [self requestAll];
        }
    }
}


-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"首页"];
}


//对当前餐厅进行判断
-(void)judgeCurrentRest
{
    self.restInfoDic = [JHUserInfoData getCurrentSelectRestInfo];
    if (isObjNotEmpty(self.restInfoDic)) {
        
        if (self.BegainSelectedDate.length <= 0) {
            //没有选择时间，给时间赋值
            NSDate *date = [NSDate date];
            NSString *today = [date transformDateFromFormatterString:@"YYYY-MM-dd"];
            self.BegainSelectedDate = today;
            self.EndSelectedDate = today;
            self.restaurantId = self.restInfoDic[@"restId"];
            self.choiceRestView.restName = self.restInfoDic[@"restName"];
            self.choiceRestView.restTimeLB.text = @"今日";
            [self requestRestaurants];
        }
        
    } else {
        
        //没有选择时间，给时间赋值
        NSDate *date = [NSDate date];
        NSString *today = [date transformDateFromFormatterString:@"YYYY-MM-dd"];
        self.BegainSelectedDate = today;
        self.EndSelectedDate = today;
        self.choiceRestView.restTimeLB.text = @"今日";
        [self requestRestaurants];
    }
}

//获取用户merchantId信息
-(void)requestUserInfo{
    
    @weakify(self);
    
    [self.userInfo getUserInfoIdentify:saveUserIdentify result:^(NSDictionary *result) {
        @strongify(self);
        self.merchanId = result[@"merchantId"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self judgeCurrentRest];
        });
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dishesDataArr = [NSMutableArray array];
    [self requestUserInfo];
    [self setUI];
    
    //检查版本更新
    [JHBoss_VersionUpdate checkAppStoreVersion:YES];
    
    //判断是否安装微信
    [JHBoss_UserWarpper shareInstance].isInstallWX = [WXApi isWXAppInstalled];
    
    /**
     处理通知的页面跳转
     */
    [self urlSchemeSkip];
}

#pragma mark - request

- (void)requestAll
{
    [self requestBaseDataList];
    [self requestDishesList];
}

// 请求餐厅列表
- (void)requestRestaurants
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.merchanId forKey:@"merchantId"];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_MyRestaurant isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            self.restaurantArray = [JHBoss_RestaurantModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"branchDetailRecordVo"][@"branchDetail"]];
          
            if (isObjNotEmpty(self.restInfoDic)) {
               __block BOOL isEqualt = NO;
                [self.restaurantArray enumerateObjectsUsingBlock:^(JHBoss_RestaurantModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj.Id.stringValue isEqualToString: self.restInfoDic[@"restId"]]) {
                        isEqualt = YES;
                        self.restaurantId = self.restInfoDic[@"restId"];
                        self.choiceRestView.restName = self.restInfoDic[@"restName"];
                    }
                }];
                
                if (!isEqualt) {
                    
                    self.restaurantId = [self.restaurantArray[0] Id].stringValue;
                    JHBoss_RestaurantModel *restModel = self.restaurantArray[0];
                    self.choiceRestView.restName = restModel.name;
                    //存储当前选中的餐厅信息
                    NSDictionary *restInfo = @{@"restId":restModel.Id.stringValue,@"restName":restModel.name};
                    [JHUserInfoData saveCurrentSelectRestInfo:restInfo];
                }
                //获取基本异常数据等
                [self requestAll];
            }else{
                
                self.restaurantId = [self.restaurantArray[0] Id].stringValue;
                JHBoss_RestaurantModel *restModel = self.restaurantArray[0];
                self.choiceRestView.restName = restModel.name;
                //存储当前选中的餐厅信息
                NSDictionary *restInfo = @{@"restId":restModel.Id.stringValue,@"restName":restModel.name};
                [JHUserInfoData saveCurrentSelectRestInfo:restInfo];
                [self requestAll];
            }
          
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

// 请求店铺运营数据
- (void)requestBaseDataList
{
    //需要添加开始时间和结束时间字段
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.restaurantId forKey:@"merchantId"];
    [param setValue:self.BegainSelectedDate forKey:@"startTime"];
    [param setValue:self.EndSelectedDate forKey:@"endTime"];
   
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_BasicDataList isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            self.merchatBusDataModel = [JHBoss_MerchatBusinessDataModel mj_objectWithKeyValues:dic[@"data"][@"record"]];
            self.orderAbnormalView.model = self.merchatBusDataModel;
            self.clientFlowView.clientFlowModel = self.merchatBusDataModel;
        }
        [self commonConfiguration];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [self commonConfiguration];
    }];
}



// 获取菜品列表
- (void)requestDishesList
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.restaurantId forKey:@"merchantId"];
    [param setValue:@{@"currentPage":@(1),@"pageSize":@(20)} forKey:@"page"];
    [param setValue:_BegainSelectedDate forKey:@"startTime"];
    [param setValue:_EndSelectedDate forKey:@"endTime"];
    [param setValue:@"dishSaleNum" forKey:@"sortAttribute"];
    [param setValue:@(false) forKey:@"sortType"];
    [JHHttpRequest postRequestWithParams:param path:JH_GetDishesList isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (isObjNotEmpty(dic[@"data"][@"list"])) {
                [self.dishesDataArr removeAllObjects];
            }
           
            [self.dishesDataArr addObjectsFromArray:[JHBoss_DishModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"list"]]];
           
        }
        [self commonConfiguration];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [self commonConfiguration];
    }];
}


#pragma mark - UI

- (void)setUI
{
    @weakify(self);
    
    //init 店铺和日期选择
    [self.view addSubview:self.choiceRestView];
    [self.choiceRestView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(kDEF_HEIGHT);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    // init tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(@(kDEF_HEIGHT));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(tableBottomDistanc);//-29
    }];
    
      [self.view bringSubviewToFront:self.tableView];
    
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        [self requestAll];
        [self.tableView.mj_header endRefreshing];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_TurnoverTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_TurnoverTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_DishesRangkingTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_DishesRangkingTableViewCell"];
}


#pragma mark - urlSchemeSkip

- (void)urlSchemeSkip
{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"remoteNotifaciotn" object:nil] subscribeNext:^(NSNotification *notification) {
        
        NSDictionary *userInfo = notification.userInfo;
        
        if ([userInfo[@"isBackground"] isEqualToString:@"1"]) {
            NSString *type = userInfo[@"userInfo"][@"type"];
            
            switch ([type intValue]) {
                    
                case 1:{
                    JHBoss_DataDetailsViewController *dataDetailVC = [[JHBoss_DataDetailsViewController alloc] init];
                    JHBoss_GeneralModel *generalModel = [[JHBoss_GeneralModel alloc]init];
                    generalModel.Id = userInfo[@"userInfo"][@"dataId"];
                    [self.navigationController pushViewController:dataDetailVC animated:YES];
                    
                    break;
                }
                case 2:{
                    //跳H5页面
                    
                    break;
                }
                case 3:
                case 4:
                case 5:{
                    
                    JHBoss_MenuOrderDetailViewController *orderDeatilVC = [[JHBoss_MenuOrderDetailViewController alloc]init];
                    JHBoss_OrderListModel *listModel = [[JHBoss_OrderListModel alloc]init];
                    listModel.ID = (NSInteger)userInfo[@"userInfo"][@"orderId"];
                    orderDeatilVC.currentSelectShop = userInfo[@"userInfo"][@"restId"];
                    [self.navigationController pushViewController:orderDeatilVC animated:YES];
                    
                    break;
                }
                case 20:{
                    
                    JHBoss_ApproveViewController *approveVC = [[JHBoss_ApproveViewController alloc] init];
                    [self.navigationController pushViewController:approveVC animated:YES];
                    
                    break;
                }
                    
                default:
                    break;
            }
            
        }else{
            
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"您有一条新的消息" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:sure];
            //[self presentViewController:alert animated:YES completion:nil];
            
        }
    }];
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (self.dishesDataArr.count < 5) {
//        return;
    }
    
    if (scrollView.contentOffset.y > _lastContentOffSetY) {
//        self.tableView.scrollEnabled = NO;
        [self heardViewChangeHeight:scrollView.contentOffset.y upChange:YES];
        
    } else {
        
        [self heardViewChangeHeight:scrollView.contentOffset.y upChange:NO];
    }
    
    
    _lastContentOffSetY = scrollView.contentOffset.y;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.dishesDataArr.count < 5) {
       
//        return;
    }
    if(!decelerate) {
        
        if (self.directionUP) {
            
            if (((kDEF_HEIGHT/1.25) < self.changeOffset) && (self.changeOffset > (kDEF_HEIGHT/2))) {
                [self changeHeardViewFrameWithDirection:DierctionType_Bottom];
            }
            
            if (((kDEF_HEIGHT/2) < self.changeOffset) && (self.changeOffset < kDEF_HEIGHT/1.25)) {
                [self changeHeardViewFrameWithDirection:DierctionType_Middle];
            }
            
            if (((kDEF_HEIGHT/4) < self.changeOffset) && (self.changeOffset < (kDEF_HEIGHT/2))) {
                [self changeHeardViewFrameWithDirection:DierctionType_Middle];
            }
            
            if ((self.changeOffset > 5) && (self.changeOffset < (kDEF_HEIGHT/4))) {
                [self changeHeardViewFrameWithDirection:DierctionType_Top];
            }
            
        } else {
            
            if (self.changeOffset > 0 && (self.changeOffset < (kDEF_HEIGHT/4))) {
                [self changeHeardViewFrameWithDirection:DierctionType_Top];
                
            }
            
            if ((self.changeOffset > (kDEF_HEIGHT/4)) && (self.changeOffset < (kDEF_HEIGHT/2))) {
                [self changeHeardViewFrameWithDirection:DierctionType_Middle];
            }
            
            if (self.changeOffset > (kDEF_HEIGHT/2) && (self.changeOffset < (kDEF_HEIGHT/1.25))) {
                [self changeHeardViewFrameWithDirection:DierctionType_Middle];
            }
            
            if (self.changeOffset > (kDEF_HEIGHT/1.25)) {
                [self changeHeardViewFrameWithDirection:DierctionType_Bottom];
            }
        }
    }
}

- (void)changeHeardViewFrameWithDirection:(DierctionType)directionType {
    
    CGFloat tmpValue = 0;
    
    switch (directionType) {
        case DierctionType_Top:
        {
            tmpValue = 5;
        }
            break;
            
        case DierctionType_Middle:
        {
            tmpValue = kDEF_HEIGHT/2+7;
        }
            break;
            
        case DierctionType_Bottom:
        {
            tmpValue = kDEF_HEIGHT;
        }
            break;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.choiceRestView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(tmpValue>kDEF_HEIGHT?kDEF_HEIGHT:tmpValue));
        }];
        
        if (tmpValue >= kDEF_HEIGHT ) {
            self.choiceRestView.restTimeLB.alpha = 0;
             self.choiceRestView.restImageStr = @"2.2.2.1_icon_diapu";
        }else if (tmpValue == kDEF_HEIGHT/2){
        
            self.choiceRestView.restTimeLB.alpha = 1;
            self.choiceRestView.restImageStr = @"1.1.2.1_icon_sousuo";
        }
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.choiceRestView.mas_bottom).offset(-1);
        }];
        
    } completion:^(BOOL finished) {
        [self.choiceRestView layoutIfNeeded];
    }];
    
}


//头部
- (void)heardViewChangeHeight:(CGFloat)contentOffY upChange:(BOOL)up {
    
    //记录方向
    self.directionUP = up;
    
    if (up) {
        if (contentOffY > 10) {
            
            CGFloat height  = self.choiceRestView.frame.size.height;
            CGFloat tmpH    = height - (contentOffY)/(kDEF_HEIGHT/4);
            CGFloat changeH = tmpH<10?10:(tmpH>kDEF_HEIGHT?kDEF_HEIGHT:tmpH);
            
            self.changeOffset = changeH;
            [self.choiceRestView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.height.equalTo(@(changeH));
            }];
            
            CGFloat changeT_Y = (-(contentOffY/(kDEF_HEIGHT/4)) < -1)?-1:-(contentOffY/(kDEF_HEIGHT/4)) < 0? 0 : -(contentOffY/(kDEF_HEIGHT/4));
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(tableBottomDistanc);
                make.top.equalTo(self.choiceRestView.mas_bottom).offset(changeT_Y);
            }];
            
            self.choiceRestView.selectTimeBackView.alpha = kALPHA_SPACE/(contentOffY > 30 ? 0 : contentOffY);
            self.choiceRestView.restNameBackView.alpha = kALPHA_SPACE*4/contentOffY;
            
            if ((contentOffY / kALPHA_SPACE)<1.0) {
                //控制餐厅后面的时间label的alpha
               self.choiceRestView.restTimeLB.alpha = contentOffY / (kALPHA_SPACE*4);
            }else{
            
               self.choiceRestView.restTimeLB.alpha = 1;
            }
           
        }
        
    } else {
        
        if (contentOffY < kDEF_HEIGHT && contentOffY > -(kDEF_HEIGHT/2)) {
            
            CGFloat height = self.choiceRestView.frame.size.height;
            CGFloat tmpH   = height + (contentOffY<10?10:(contentOffY/(kDEF_HEIGHT/4)));
            
            self.changeOffset = tmpH;
            
            [self.choiceRestView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(tmpH>kDEF_HEIGHT?kDEF_HEIGHT:tmpH));
                make.top.equalTo(self.view);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
            }];
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.choiceRestView.mas_bottom);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(tableBottomDistanc);
            }];
            
            if (contentOffY > 0) {
                self.choiceRestView.selectTimeBackView.alpha = kALPHA_SPACE/contentOffY;
                self.choiceRestView.restNameBackView.alpha = kALPHA_SPACE*4/contentOffY;
                
                if (contentOffY/(kALPHA_SPACE*4) <= 0.3) {
                    
                    self.choiceRestView.restTimeLB.alpha = 0;

                }else{
                
                    self.choiceRestView.restTimeLB.alpha = contentOffY / kALPHA_SPACE;

                }
                
            }
        }
    }
    
}



#pragma mark - tableView delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    if (section == 0) {
        number = 1;
    }else if (section == 1){
        
        number = 0;
       
    }else if (section == 2){
    //self.dishesDataArr.count > 5 ? 5 : (self.dishesDataArr.count <= 3 ? 5 : self.dishesDataArr.count)
        number = 5;
    }
    return number;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        static NSString *reuse = @"JHBoss_TurnoverTableViewCell";
        JHBoss_TurnoverTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.generalModel = self.merchatBusDataModel;
        return cell;
    }else if (indexPath.section == 2){
        
        static NSString *reuse = @"JHBoss_DishesRangkingTableViewCell";
        JHBoss_DishesRangkingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        cell.rangkingType = enterIntoType_dishs;
        if (indexPath.row <= 3) {
            cell.rangkingImage.hidden = NO;
            cell.rangkingImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.1_icon_%ld",indexPath.row+1]];
        }else{
        
            cell.rangkingImage.hidden = YES;
        }
        if ( indexPath.row < self.dishesDataArr.count) {
            JHBoss_DishModel *model = self.dishesDataArr[indexPath.row];
            cell.dishModel = model;
            
        }else{
        
            cell.hidden = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        return cell;
    }
   
    
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 && indexPath.row == 0) {
        return 90;
    }else if (indexPath.section == 1 ){
    
        return 0;
    }else if (indexPath.section == 2){
        return 90;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 2) {
        
       return self.dishesSectionHeaderView;
    }
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if (section == 1) {
        return self.orderAbnormalView;
    }else if (section == 0){
    
        return self.clientFlowView;
    }
   
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    
    if (section == 2) {
        return 44;
    }else if (section == 1){
    
        return 1;
    }
    return 0.00001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == 0 || section == 1) {
        return 109;
    }
    return 0.0001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section && !indexPath.row) {
        JHBoss_GeneralModel *generalModel = [[JHBoss_GeneralModel alloc]init];
        generalModel.Id = [NSNumber numberWithInt:1];
        JHBoss_DataDetailsViewController *dataDVC = [[JHBoss_DataDetailsViewController alloc]init];
        dataDVC.restArr = self.restaurantArray;
        dataDVC.BegainSelectedDate = self.BegainSelectedDate;
        dataDVC.EndSelectedDate = self.EndSelectedDate;
        [self.navigationController pushViewController:dataDVC animated:YES];
        
    }else if (!indexPath.section && indexPath.row){
    
        JHBoss_ClientAnalyzeViewController *clientVC = [[JHBoss_ClientAnalyzeViewController alloc]init];
        clientVC.BegainSelectedDate = self.BegainSelectedDate;
        clientVC.EndSelectedDate = self.EndSelectedDate;
        [self.navigationController pushViewController:clientVC animated:YES];
    
    }else if (indexPath.section){
    
        JHBoss_DishDetailsViewController *dishDetailVC = [[JHBoss_DishDetailsViewController alloc]init];
        dishDetailVC.restaurantId = self.restaurantId;
        dishDetailVC.dishModel = self.dishesDataArr[indexPath.row];
        dishDetailVC.restArr = self.restaurantArray;
        dishDetailVC.restName = self.restInfoDic[@"restName"];
        dishDetailVC.BegainSelectedDate = self.BegainSelectedDate;
        dishDetailVC.EndSelectedDate = self.EndSelectedDate;
        [self.navigationController pushViewController:dishDetailVC animated:YES];
    
    }
}


- (UITableView *)tableView
{
    if (!_tableView) {
        //CGRectMake(0, 0, DEF_WIDTH, DEF_HEIGHT- 64 - 49)
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}

-(JHBoss_HomeDishesSectionHeaderView *)dishesSectionHeaderView{

    if (!_dishesSectionHeaderView) {
        _dishesSectionHeaderView = [[JHBoss_HomeDishesSectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 44)];
        @weakify(self);
        _dishesSectionHeaderView.moreRangkingBlock = ^{
            @strongify(self);
            JHBoss_DishesViewController *dishesVC = [[JHBoss_DishesViewController alloc]init];
            dishesVC.restArr = self.restaurantArray;
            dishesVC.restaurantId = self.restaurantId.integerValue;
            dishesVC.BegainSelectedDate = self.BegainSelectedDate;
            dishesVC.EndSelectedDate = self.EndSelectedDate;
            [self.navigationController pushViewController:dishesVC animated:YES];
        };
    }

    return _dishesSectionHeaderView;
}

//订单异常区尾懒加载
-(JHBoss_HomeOrderAbnormalView *)orderAbnormalView{

    if (!_orderAbnormalView) {
        _orderAbnormalView = [[JHBoss_HomeOrderAbnormalView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 99)];
        _orderAbnormalView.topLine.hidden = YES;
        [_orderAbnormalView leftPicture:@"1.1_icon_yichang" rightPic:@"1.1_icon_chaping" leftTitle:@"订单异常" rightTitle:@"差评数"];
        @weakify(self);
        _orderAbnormalView.orderTurnoverBlock = ^{
            //订单异常
            @strongify(self);
            JHBoss_OrderAndCommentListViewController *orderVC = [[JHBoss_OrderAndCommentListViewController alloc]init];
            orderVC.orderOrCommentEntInto = JHBoss_OrderEnterInto;
            orderVC.merchanId = self.restaurantId;
            orderVC.BegainSelectedDate = self.BegainSelectedDate;
            orderVC.EndSelectedDate = self.EndSelectedDate;
            [self.navigationController pushViewController:orderVC animated:YES];
        };
        _orderAbnormalView.badCommentBlock = ^{
            //差评数
             @strongify(self);
            JHBoss_OrderAndCommentListViewController *orderVC = [[JHBoss_OrderAndCommentListViewController alloc]init];
            orderVC.orderOrCommentEntInto = JHBoss_BadCommentEnterInto;
            orderVC.merchanId = self.restaurantId;
            orderVC.BegainSelectedDate = self.BegainSelectedDate;
            orderVC.EndSelectedDate = self.EndSelectedDate;
            [self.navigationController pushViewController:orderVC animated:YES];
        };
    }
    return _orderAbnormalView;
}

//懒加载客流量
-(JHBoss_HomeOrderAbnormalView *)clientFlowView{

    if (!_clientFlowView) {
        _clientFlowView = [[JHBoss_HomeOrderAbnormalView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 99)];
        _clientFlowView.bottomLineView.hidden = YES;
        [_clientFlowView leftPicture:@"客流量" rightPic:@"客单价" leftTitle:@"客流量(人)" rightTitle:@"客单价(元)"];
        @weakify(self);
        _clientFlowView.orderTurnoverBlock = ^{
            //客流量
            @strongify(self);
            JHBoss_ClientAnalyzeViewController *ClientAVC = [[JHBoss_ClientAnalyzeViewController alloc]init];
            ClientAVC.restArr = self.restaurantArray;
            ClientAVC.clientPricOrFlow = JHBoss_ClientFlow;
            ClientAVC.BegainSelectedDate = self.BegainSelectedDate;
            ClientAVC.EndSelectedDate = self.EndSelectedDate;
            [self.navigationController pushViewController:ClientAVC animated:YES];
        };
        _clientFlowView.badCommentBlock = ^{
            //客单价
            @strongify(self);
            JHBoss_ClientAnalyzeViewController *ClientAVC = [[JHBoss_ClientAnalyzeViewController alloc]init];
            ClientAVC.restArr = self.restaurantArray;
            ClientAVC.clientPricOrFlow = JHBoss_ClientPrice;
            ClientAVC.BegainSelectedDate = self.BegainSelectedDate;
            ClientAVC.EndSelectedDate = self.EndSelectedDate;
            [self.navigationController pushViewController:ClientAVC animated:YES];
        };

    }
    return _clientFlowView;
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSString *)time
{
    if (!_time) {
        _time =  [NSString timeIntervalFromDate:[NSDate date]];
    }
    return _time;
}

- (NSMutableArray *)dataIdList
{
    if (!_dataIdList) {
        _dataIdList = [NSMutableArray array];
    }
    return _dataIdList;
}

- (NSMutableArray *)funArray
{
    if (!_funArray) {
        _funArray = [NSMutableArray array];
    }
    return _funArray;
}

- (NSMutableArray<JHBoss_RestaurantModel *> *)restaurantArray
{
    if (!_restaurantArray) {
        _restaurantArray = [NSMutableArray array];
    }
    return _restaurantArray;
}

-(JHUserInfoData *)userInfo{
    
    if (!_userInfo) {
        _userInfo = [[JHUserInfoData alloc]init];
    }
    return _userInfo;
}

//餐厅选择view
-(JHBoss_ChoiceRestView *)choiceRestView{

    if (!_choiceRestView) {
        _choiceRestView = [[JHBoss_ChoiceRestView alloc]initWithFrame:CGRectZero];
        if (isObjNotEmpty(self.restInfoDic)) {
            _choiceRestView.restName = self.restInfoDic[@"restName"];
        }
       
        @weakify(self);
        _choiceRestView.choiceRestHandler = ^{
            @strongify(self);
            
            if (self.directionUP && self.changeOffset >= kDEF_HEIGHT/3 ) {
                
                [self.choiceRestView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(kDEF_HEIGHT));
                    make.top.equalTo(self.view);
                    make.left.equalTo(self.view);
                    make.right.equalTo(self.view);
                }];
                
                [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.choiceRestView.mas_bottom);
                    make.left.equalTo(self.view);
                    make.right.equalTo(self.view);
                    make.bottom.equalTo(self.view).offset(tableBottomDistanc);
                }];
                
                self.choiceRestView.restImageStr = @"2.2.2.1_icon_diapu";
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
            }else{
            
            
                [self restPicker];
                self.restPicker.titleStr = @"店铺选择";
                [self.restPicker show];
            }
            
            
        }; 
        
        _choiceRestView.selectTimeHandler = ^{
            @strongify(self);
            
            [self.datePicker show];
           
        };
    }

    return _choiceRestView;
}

//餐厅选择懒加载
-(JHBoss_RestPickerAppearance *)restPicker{

    if (!_restPicker) {
        
        NSMutableArray *restNames = [NSMutableArray array];
        
        [self.restaurantArray enumerateObjectsUsingBlock:^(JHBoss_RestaurantModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [restNames addObject:obj.name];
        }];
        
        _restPicker = [[JHBoss_RestPickerAppearance alloc]initWithPickerType:JHBoss_PickerType_Rest param:restNames completeBlock:^(int index) {
            
            JHBoss_RestaurantModel *restModel = self.restaurantArray[index];
            self.choiceRestView.restName = restModel.name;
            [self requestAll];
            //存储当前选中的餐厅信息
            NSDictionary *restInfo = @{@"restId":restModel.Id.stringValue,@"restName":restModel.name};
            [JHUserInfoData saveCurrentSelectRestInfo:restInfo];
        }];
    }
    
    return _restPicker;
}

//懒加载日期选择器
-(HCGDatePickerAppearance *)datePicker{

    if (!_datePicker) {
        
        NSDate *date = [NSDate date];
        _datePicker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerYearMonthDaySection MinDate:nil MaxDate:date completeBlock:^(NSArray *time) {
            
            NSString *showDateStr;
            NSString *begainDateStr = time.firstObject;
            NSString *endDateStr = time.lastObject;
            NSDate *begainDate = [NSString dateWithString:begainDateStr format:@"YYYY年MM月dd日"];
            NSDate *endDate = [NSString dateWithString:endDateStr format:@"YYYY年MM月dd日"];
            showDateStr = [NSString compareDate:begainDate endDate:endDate];
            self.choiceRestView.selectTime = showDateStr;
            self.BegainSelectedDate = [NSString date:begainDate format:@"YYYY-MM-dd"];
            self.EndSelectedDate = [NSString date:endDate format:@"YYYY-MM-dd"];
            self.choiceRestView.restTimeLB.text = [@" • " stringByAppendingString:showDateStr];
            [self requestAll];
        }];
        _datePicker.titleStr = @"时段选择";
    }
    
    return _datePicker;
}


#pragma ----DZNEmptyDataSet -------datasoure
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (_loading) {
        return nil;
    }
    if (NETWORK_CONNECTION_STAT == NotReachable) {
        return DEF_IMAGENAME(@"0.4_icon_wangluoyichang");
    }
    return DEF_IMAGENAME(@"1.1.3.2_icon_zanwutixing");
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.loading) {
        return nil;
    }
    
    NSString *text = @"轻触此处,重新加载数据";
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14.0] range:[text rangeOfString:text]];
    
    return attributedTitle;
}


- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    if (_loading) {
        return self.loadDataView;
    }
    return  nil;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return 0;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    return DEF_COLOR_F5F5F5;
}


#pragma ----DZNEmptyDataSet -------dataDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    //  从新进行网络请求
    _loading = YES;
    
    //请求没有网络数据时调用，展示空页面
    [self.tableView reloadEmptyDataSet];
    [self.loadDataView startAnimation];
    [self requestAll];
}

//加载显示加载数据时的动画view
-(JHCRM_LoadDataView *)loadDataView{
    if (!_loadDataView) {
        _loadDataView = [[JHCRM_LoadDataView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    }
    [_loadDataView startAnimation];
    return _loadDataView;
}


#pragma mark - other

- (BOOL)disableAutomaticSetNavBar
{
    return YES;
}

-(void)commonConfiguration{
    _loading = NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.loadDataView stopAnimation];
}

@end
