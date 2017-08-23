//
//  JHBoss_AllStaffRangkingViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_AllStaffRangkingViewController.h"
#import "JHBoss_AllStaffRangkingHeaderView.h"
#import "JHBoss_AllStaffRangkingTableViewCell.h"
#import "JHBoss_StaffRankingModel.h"
#import "JHBoss_GiveMoneyToStaffViewController.h"
#import "JHBoss_StaffRankingConditionModel.h"

#import "JHBoss_StaffOrDishsRangkingView.h"
#import "JHBoss_RestPickerAppearance.h"
#import "HCGDatePickerAppearance.h"
#import "JHUserInfoData.h"
#import "JHBoss_RechargeViewController.h"
#import <WXApi.h>
@interface JHBoss_AllStaffRangkingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) JHBoss_AllStaffRangkingHeaderView *staffHeaderView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;//数据
@property (nonatomic, strong) NSMutableArray *staffRangkingConditionArr;
@property (nonatomic, copy) NSString *staffSortConditionStr;//员工排序条件
@property (nonatomic, assign) BOOL sortType;//降 还是升
@property (nonatomic, assign) int page;//单前页数
//筛选栏
@property (nonatomic, strong) JHBoss_StaffOrDishsRangkingView *choiceRestView;//选择餐厅的view
@property (nonatomic, strong) JHBoss_RestPickerAppearance *restPicker;//餐厅选择器
@property (nonatomic, strong) JHBoss_RestPickerAppearance *restRangkingConditionPicker;//餐厅排序条件选择器
@property (nonatomic, strong) HCGDatePickerAppearance *datePicker;//时间选择器
@property (nonatomic, copy) NSString *BegainSelectedDate;//选中的开始日期
@property (nonatomic, copy) NSString *EndSelectedDate;//选中的结束日期
@property (nonatomic, strong) JHUserInfoData *userInfo;
//动画效果属性
@property (nonatomic, assign) CGFloat lastContentOffSetY;
//记录改变值
@property (nonatomic, assign) CGFloat changeOffset;
//
@property (nonatomic, assign) BOOL directionUP;

@end

@implementation JHBoss_AllStaffRangkingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}


// 获取员工排行
- (void)requestData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSDictionary *pageDic = @{@"currentPage":@(self.page),@"pageSize":@"20"};
    [param setObject:pageDic forKey:@"page"];
    [param setValue:self.restId forKey:@"merchantId"];
    [param setValue:self.BegainSelectedDate forKey:@"startDate"];
    [param setValue:self.EndSelectedDate forKey:@"endDate"];
    [param setValue:self.staffSortConditionStr forKey:@"sortAttribute"];
    [param setValue:@(self.sortType)forKey:@"sortType"];
    [JHHttpRequest postRequestWithParams:param path:JH_StaffRangkingURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (self.page == 1) {
                [self.dataArr removeAllObjects];
            }
            self.page ++;
         [self.dataArr addObjectsFromArray:[JHBoss_StaffRankingModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"list"]]];
        }
        
        [self commonConfiguration];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
        
    }];
}
-(void)commonConfiguration{
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

// 获取员工排行条件
- (void)requestStaffRankingConditionData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    @weakify(self)
    [JHHttpRequest postRequestWithParams:param path:JH_StaffRangkingConditionURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self)
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            [self.staffRangkingConditionArr addObjectsFromArray:[JHBoss_StaffRankingConditionModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
            JHBoss_StaffRankingConditionModel *model = self.staffRangkingConditionArr.firstObject;
            self.staffSortConditionStr = model.attribute;
            self.sortType = model.sortType;
            self.choiceRestView.rangkingLbStr = model.sortName;
            [self requestData];
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self);
    _page = 1;
    self.dataArr = [NSMutableArray array];
    self.staffRangkingConditionArr = [NSMutableArray array];
    self.staffSortConditionStr = @"negativeCommentNum";
    self.sortType = true;
    NSDate *date = [NSDate date];
    NSString *today = [date transformDateFromFormatterString:@"YYYY-MM-dd"];
    self.BegainSelectedDate = today;
    self.EndSelectedDate = today;
    [self requestStaffRankingConditionData];
    [self setUpUI];
    
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self requestData];
        [self.tableView.mj_header endRefreshing];
    }];
    [self.tableView addCustomGifFooterWithRefreshingBlock:^{
        @strongify(self);
       
        [self requestData];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}

-(void)setUpUI{

    self.jhtitle = @"员工排行";
     @weakify(self);
    //init 店铺和日期选择
    [self.view addSubview:self.choiceRestView];
    [self.choiceRestView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.height.mas_equalTo(staffRangkingHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 50;
    _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    _tableView.separatorColor = DEF_COLOR_ECECEC;
    _tableView.tableHeaderView = self.staffHeaderView;
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.choiceRestView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self.tableView registerClass:[JHBoss_AllStaffRangkingTableViewCell class] forCellReuseIdentifier:@"JHBoss_AllStaffRangkingTableViewCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"JHBoss_AllStaffRangkingTableViewCell";
    JHBoss_AllStaffRangkingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    cell.model = self.dataArr[indexPath.row];
    cell.numberLB.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (! [JHBoss_UserWarpper shareInstance].isInstallWX) {
        
        return;
    }
    
    JHBoss_StaffRankingModel *model = self.dataArr[indexPath.row];
    //进入充值页面
    JHBoss_RechargeViewController *rechargeVC = [[JHBoss_RechargeViewController alloc] init];
    
    rechargeVC.payType    = kPayMethodType_Employees_Reward;
    rechargeVC.staffId    = model.staffId.stringValue;
    rechargeVC.staffName  = model.name;
    rechargeVC.staffPictureUrl = model.headImageUrl;
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

-(JHBoss_AllStaffRangkingHeaderView *)staffHeaderView{

    if (!_staffHeaderView) {
        _staffHeaderView = [[JHBoss_AllStaffRangkingHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 30)];
    }
    return _staffHeaderView;
}

//餐厅选择view
-(JHBoss_StaffOrDishsRangkingView *)choiceRestView{
    
    if (!_choiceRestView) {
        _choiceRestView = [[JHBoss_StaffOrDishsRangkingView alloc]initWithFrame:CGRectZero];
        @weakify(self);
        NSDictionary *userInfoDic = [JHUserInfoData getCurrentSelectRestInfo];
        if (isObjNotEmpty(userInfoDic)) {
            @strongify(self);
            self.choiceRestView.restName = userInfoDic[@"restName"];
        }
        
        _choiceRestView.choiceRestHandler = ^{
            @strongify(self);
            
            if (self.directionUP && self.changeOffset >= staffRangkingHeight/3 ) {
                
                [self.choiceRestView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(staffRangkingHeight));
                    make.top.equalTo(self.view);
                    make.left.equalTo(self.view);
                    make.right.equalTo(self.view);
                }];
                
                [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.choiceRestView.mas_bottom);
                    make.left.equalTo(self.view);
                    make.right.equalTo(self.view);
                    make.bottom.equalTo(self.view);
                }];
                
                self.choiceRestView.restImageStr = @"2.2.2.1_icon_diapu";
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
            }else{
                self.restPicker.titleStr = @"店铺选择";
                [self.restPicker show];
            }
            
            
        };
        
        _choiceRestView.rangkingHandler = ^{
            @strongify(self);
            
            self.restRangkingConditionPicker.titleStr = @"排序方式";
            [self.restRangkingConditionPicker show];
        };
        
        _choiceRestView.selectTimeHandler = ^{
            @strongify(self);
            self.datePicker.titleStr = @"请选择排序时间";
            [self.datePicker show];
            
        };
    }
    
    return _choiceRestView;
}

//餐厅选择懒加载
-(JHBoss_RestPickerAppearance *)restPicker{
    
    if (!_restPicker) {
        
        @weakify(self);
        NSMutableArray *restNames = [NSMutableArray array];
        [self.restArr enumerateObjectsUsingBlock:^(JHBoss_RestaurantModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [restNames addObject:obj.name];
        }];
        
        _restPicker = [[JHBoss_RestPickerAppearance alloc]initWithPickerType:JHBoss_PickerType_Rest param:restNames completeBlock:^(int index) {
            @strongify(self);
            JHBoss_RestaurantModel *restModel = self.restArr[index];
            self.choiceRestView.restName = restModel.name;
            self.restId = restModel.Id.stringValue;
            self.page = 1;
            //请求数据
            [self requestData];
            //存储当前选中的餐厅信息
            NSDictionary *restInfo = @{@"restId":restModel.Id.stringValue,@"restName":restModel.name};
            [JHUserInfoData saveCurrentSelectRestInfo:restInfo];
        }];
    }
    
    return _restPicker;
}

//餐厅排序条件选择器
-(JHBoss_RestPickerAppearance *)restRangkingConditionPicker{

    if (!_restRangkingConditionPicker) {
        
        
        @weakify(self);
        NSMutableArray *restNames = [NSMutableArray array];
        [self.staffRangkingConditionArr enumerateObjectsUsingBlock:^(JHBoss_StaffRankingConditionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [restNames addObject:obj.sortName];
        }];
        
        _restRangkingConditionPicker = [[JHBoss_RestPickerAppearance alloc]initWithPickerType:JHBoss_PickerType_Rest param:restNames completeBlock:^(int index) {
            @strongify(self);
            JHBoss_StaffRankingConditionModel *Model = self.staffRangkingConditionArr[index];
            self.choiceRestView.rangkingLbStr = Model.sortName;
            self.staffSortConditionStr = Model.attribute;
            self.sortType = Model.sortType;
             self.page = 1;
            //请求数据
            [self requestData];
            
        }];
        
    }

    return _restRangkingConditionPicker;
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
            
            self.BegainSelectedDate = [NSString timeIntervalFromDate:begainDate];
            self.EndSelectedDate = [NSString timeIntervalFromDate:endDate];
             self.page = 1;
            [self requestData];
        }];
        _datePicker.titleStr = @"时段选择";
    }
    
    return _datePicker;
}


#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    if (self.dataArr.count < 10) {
        return;
//    }
    
    if (scrollView.contentOffset.y > _lastContentOffSetY) {
        
        [self heardViewChangeHeight:scrollView.contentOffset.y upChange:YES];
        
    } else {
        
        [self heardViewChangeHeight:scrollView.contentOffset.y upChange:NO];
    }
    
    
    _lastContentOffSetY = scrollView.contentOffset.y;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
//    if (self.dataArr.count < 10) {
        return;
//    }
    
    if(!decelerate) {
        
        if (self.directionUP) {
            
            if (((staffRangkingHeight/1.25) < self.changeOffset) && (self.changeOffset > (staffRangkingHeight/2))) {
                [self changeHeardViewFrameWithDirection:DierctionType_Bottom];
            }
            
            if (((staffRangkingHeight/2) < self.changeOffset) && (self.changeOffset < staffRangkingHeight/1.25)) {
                [self changeHeardViewFrameWithDirection:DierctionType_Middle];
            }
            
            if (((staffRangkingHeight/4) < self.changeOffset) && (self.changeOffset < (staffRangkingHeight/2))) {
                [self changeHeardViewFrameWithDirection:DierctionType_Middle];
            }
            
            if ((self.changeOffset > 5) && (self.changeOffset < (staffRangkingHeight/4))) {
                [self changeHeardViewFrameWithDirection:DierctionType_Top];
            }
            
        } else {
            
            if (self.changeOffset > 0 && (self.changeOffset < (staffRangkingHeight/4))) {
                [self changeHeardViewFrameWithDirection:DierctionType_Top];
                
            }
            
            if ((self.changeOffset > (staffRangkingHeight/4)) && (self.changeOffset < (staffRangkingHeight/2))) {
                [self changeHeardViewFrameWithDirection:DierctionType_Middle];
            }
            
            if (self.changeOffset > (staffRangkingHeight/2) && (self.changeOffset < (staffRangkingHeight/1.25))) {
                [self changeHeardViewFrameWithDirection:DierctionType_Middle];
            }
            
            if (self.changeOffset > (staffRangkingHeight/1.25)) {
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
            tmpValue = staffRangkingHeight/2;
        }
            break;
            
        case DierctionType_Bottom:
        {
            tmpValue = staffRangkingHeight;
        }
            break;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.choiceRestView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(tmpValue>staffRangkingHeight?staffRangkingHeight:tmpValue));
        }];
        
        if (tmpValue >= staffRangkingHeight ) {
            self.choiceRestView.restTimeLB.alpha = 0;
            self.choiceRestView.restImageStr = @"2.2.2.1_icon_diapu";
        }else if (tmpValue == staffRangkingHeight/2){
            
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
            CGFloat tmpH    = height - (contentOffY)/(staffRangkingHeight/4);
            CGFloat changeH = tmpH<10?10:(tmpH>staffRangkingHeight?staffRangkingHeight:tmpH);
            
            self.changeOffset = changeH;
            [self.choiceRestView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.navBar.mas_bottom);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.height.equalTo(@(changeH));
            }];
            
            CGFloat changeT_Y = (-(contentOffY/(staffRangkingHeight/4)) < -1)?-1:-(contentOffY/(staffRangkingHeight/4)) < 0? 0 : -(contentOffY/(staffRangkingHeight/4));
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.bottom.equalTo(self.view);
                make.top.equalTo(self.choiceRestView.mas_bottom).offset(changeT_Y);
            }];
            
            self.choiceRestView.selectTimeBackView.alpha = kALPHA_SPACE/contentOffY;
            self.choiceRestView.restNameBackView.alpha = kALPHA_SPACE*4/contentOffY;
            
            if ((contentOffY / kALPHA_SPACE)<1.0) {
                //控制餐厅后面的时间label的alpha
                self.choiceRestView.restTimeLB.alpha = contentOffY / (kALPHA_SPACE*4);
            }else{
                
                self.choiceRestView.restTimeLB.alpha = 1;
            }
            
        }
        
    } else {
        
        if (contentOffY < staffRangkingHeight && contentOffY > -(staffRangkingHeight/2)) {
            
            CGFloat height = self.choiceRestView.frame.size.height;
            CGFloat tmpH   = height + (contentOffY<10?10:(contentOffY/(staffRangkingHeight/4)));
            
            self.changeOffset = tmpH;
            
            [self.choiceRestView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(tmpH>staffRangkingHeight?staffRangkingHeight:tmpH));
                make.top.equalTo(self.navBar.mas_bottom);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
            }];
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.choiceRestView.mas_bottom);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.bottom.equalTo(self.view);
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
