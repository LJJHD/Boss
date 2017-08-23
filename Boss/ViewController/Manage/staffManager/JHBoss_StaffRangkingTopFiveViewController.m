//
//  JHBoss_StaffRangkingTopFiveViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffRangkingTopFiveViewController.h"
#import "JHBoss_StaffRangkingTopFiveTableViewCell.h"
#import "JHBoss_AllStaffRangkingViewController.h"
#import "JHBoss_StaffRankingModel.h"
#import "JHBoss_GiveMoneyToStaffViewController.h"
#import "JHBoss_ChoiceRestView.h"
#import "JHBoss_RestPickerAppearance.h"
#import "HCGDatePickerAppearance.h"
#import "JHUserInfoData.h"
#import "JHBoss_staffDetailViewController.h"
#import "JHBoss_RechargeViewController.h"
#import "JHBoss_StaffListModel.h"

#import <WXApi.h>
@interface JHBoss_StaffRangkingTopFiveViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *moreBtn;//查看更多
@property (nonatomic, strong) UIView *footBackView;
@property (nonatomic, strong) NSMutableArray *dataArr;//数据
@property (nonatomic, copy) NSString *begainTime;//开始时间
@property (nonatomic, copy) NSString *endTime;//结束时间

@property (nonatomic, assign) BOOL loading; // 是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView; // 数据加载过程中显示加载动画的view

//筛选栏
@property (nonatomic, strong) JHBoss_ChoiceRestView *choiceRestView;//选择餐厅的view
@property (nonatomic, strong) JHBoss_RestPickerAppearance *restPicker;//餐厅选择器
@property (nonatomic, strong) HCGDatePickerAppearance *datePicker;//时间选择器
@property (nonatomic, copy) NSString *restId;//餐厅id

//动画效果属性
@property (nonatomic, assign) CGFloat lastContentOffSetY;
//记录改变值
@property (nonatomic, assign) CGFloat changeOffset;
//
@property (nonatomic, assign) BOOL directionUP;
@end

@implementation JHBoss_StaffRangkingTopFiveViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"前五名员工排行"];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"前五名员工排行"];
}


// 获取员工排行
- (void)requestData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.restId forKey:@"merchantId"];
    [param setValue:self.begainTime forKey:@"startDate"];
    [param setValue:self.endTime forKey:@"endDate"];
    [param setValue:@"perCapitaConsumption" forKey:@"sortAttribute"];
    [param setValue:@(true)forKey:@"sortType"];
    [JHHttpRequest postRequestWithParams:param path:JH_StaffRangkingURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            if (isObjNotEmpty(self.dataArr)) {
                [self.dataArr removeAllObjects];
            }
            [self.dataArr addObjectsFromArray:[JHBoss_StaffRankingModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"list"]]];
            self.tableView.tableFooterView = [self footView];

        }
        
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
       
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArr = [NSMutableArray array];
    NSDate *date = [NSDate date];
    NSString *today = [date transformDateFromFormatterString:@"YYYY-MM-dd"];
    self.begainTime = today;
    self.endTime = today;
    
    NSDictionary *restInfo = [JHUserInfoData getCurrentSelectRestInfo];;
    if (isObjNotEmpty(restInfo)) {
        self.choiceRestView.restName = restInfo[@"restName"];
        self.restId = restInfo[@"restId"];
        [self requestData];
    }

    [self setUpUI];
}

-(void)setUpUI{
    self.jhtitle = @"员工排行";
    
    //init 店铺和日期选择
    @weakify(self);
    [self.view addSubview:self.choiceRestView];
    [self.choiceRestView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.height.mas_equalTo(kDEF_HEIGHT);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 90;
    _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    _tableView.separatorColor = DEF_COLOR_ECECEC;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.choiceRestView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_StaffRangkingTopFiveTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_StaffRangkingTopFiveTableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSUInteger num;
    if (self.dataArr.count > 5) {
        num = 5;
    }else{
    
        num = self.dataArr.count;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"JHBoss_StaffRangkingTopFiveTableViewCell";
    JHBoss_StaffRangkingTopFiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell staffRankingModel:self.dataArr[indexPath.row] indexPath:indexPath];
    @weakify(self)
    cell.rewardHandler = ^(NSIndexPath *index) {
        @strongify(self);
        if (![JHBoss_UserWarpper shareInstance].isInstallWX) {
            
            return;
        }
        
        JHBoss_StaffRankingModel *model = self.dataArr[index.row];
        DPLog(@"headImageUrl===%@++++%ld",model.headImageUrl,(long)index.row);
        //进入充值页面
        JHBoss_RechargeViewController *rechargeVC = [[JHBoss_RechargeViewController alloc] init];
        
        rechargeVC.payType    = kPayMethodType_Employees_Reward;
        rechargeVC.staffId    = model.staffId.stringValue;
        rechargeVC.staffName  = model.name;
        rechargeVC.staffPictureUrl = model.headImageUrl;
        [self.navigationController pushViewController:rechargeVC animated:YES];
    };
    [cell setCellLineUIEdgeInsetsZero];
    if (indexPath.row <= 3) {
        //@"1.1_icon_1"
        cell.rankingImageView.hidden = NO;
        cell.rankingImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.1_icon_%ld",indexPath.row+1]];
    }else{
    
        cell.rankingImageView.hidden = YES;
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JHBoss_StaffRankingModel *model = self.dataArr[indexPath.row];
    JHBoss_staffDetailViewController *staffDetailVC = [[JHBoss_staffDetailViewController alloc]init];
    staffDetailVC.currentSelectShop = self.restId;
    StaffList *staffListModel = [[StaffList alloc]init];
    staffListModel.ID = model.staffId.integerValue;
    staffDetailVC.staffInfo = staffListModel;
    [self.navigationController pushViewController:staffDetailVC animated:YES];
    
}


-(UIView *)footView{
    @weakify(self);
    self.footBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 100)];
     self.footBackView.backgroundColor = DEF_COLOR_F5F5F5;
    _moreBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [_moreBtn setTitle:@"查看更多"];
    [_moreBtn setTitleColor:DEF_COLOR_B48645 forState:UIControlStateNormal];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _moreBtn.layer.borderWidth = 0.5;
    _moreBtn.layer.borderColor = DEF_COLOR_CDA265.CGColor;
    if (self.dataArr.count) {
        
        _moreBtn.hidden = NO;
    } else {
        
        _moreBtn.hidden = YES;
    }
    [ self.footBackView addSubview:_moreBtn];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
        make.centerX.equalTo( self.footBackView.mas_centerX);
        make.centerY.equalTo( self.footBackView.mas_centerY);
    }];
   
    [[_moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        JHBoss_AllStaffRangkingViewController *allStaffRangkingVC = [[JHBoss_AllStaffRangkingViewController alloc]init];
        allStaffRangkingVC.restArr = self.restArr;
        allStaffRangkingVC.restId = self.restId;
        [self.navigationController pushViewController:allStaffRangkingVC animated:YES];
        
    }];
    return self.footBackView;
}


//餐厅选择view
-(JHBoss_ChoiceRestView *)choiceRestView{
    
    if (!_choiceRestView) {
        _choiceRestView = [[JHBoss_ChoiceRestView alloc]initWithFrame:CGRectZero];
        
        @weakify(self);
        _choiceRestView.choiceRestHandler = ^{
            @strongify(self);
            
            if (self.directionUP && self.changeOffset >= kDEF_HEIGHT/3 ) {
                
                [self.choiceRestView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(kDEF_HEIGHT));
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
        
        [self.restArr enumerateObjectsUsingBlock:^(JHBoss_RestaurantModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [restNames addObject:obj.name];
        }];
        
        _restPicker = [[JHBoss_RestPickerAppearance alloc]initWithPickerType:JHBoss_PickerType_Rest param:restNames completeBlock:^(int index) {
            
            JHBoss_RestaurantModel *restModel = self.restArr[index];
            self.choiceRestView.restName = restModel.name;
            self.restId = restModel.Id.stringValue;
            //存储当前选中的餐厅信息
            NSDictionary *restInfo = @{@"restId":restModel.Id.stringValue,@"restName":restModel.name};
            [JHUserInfoData saveCurrentSelectRestInfo:restInfo];
            [self requestData];
        }];
    }
    
    return _restPicker;
}

//懒加载日期选择器
-(HCGDatePickerAppearance *)datePicker{
    
    if (!_datePicker) {
        @weakify(self);
        NSDate *date = [NSDate date];
        _datePicker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerYearMonthDaySection MinDate:nil MaxDate:date completeBlock:^(NSArray *time) {
            @strongify(self);
            NSString *showDateStr;
            NSString *begainDateStr = time.firstObject;
            NSString *endDateStr = time.lastObject;
            NSDate *begainDate = [NSString dateWithString:begainDateStr format:@"YYYY年MM月dd日"];
            NSDate *endDate = [NSString dateWithString:endDateStr format:@"YYYY年MM月dd日"];
            showDateStr = [NSString compareDate:begainDate endDate:endDate];
            self.choiceRestView.selectTime = showDateStr;
            self.begainTime = [NSString date:begainDate format:@"YYYY-MM-dd"];
            self.endTime = [NSString date:endDate format:@"YYYY-MM-dd"];
            [self requestData];
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
    [self requestData];
}

//加载显示加载数据时的动画view
-(JHCRM_LoadDataView *)loadDataView{
    if (!_loadDataView) {
        _loadDataView = [[JHCRM_LoadDataView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    }
    [_loadDataView startAnimation];
    return _loadDataView;
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
