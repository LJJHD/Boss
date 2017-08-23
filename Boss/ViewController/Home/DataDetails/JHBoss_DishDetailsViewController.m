//
//  JHBoss_DishDetailsViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_DishDetailsViewController.h"
#import "JHBoss_DishValuationHeaderTableViewCell.h"
#import "JHBoss_DishValuationTableViewCell.h"
#import "JHBoss_DishDetailTableViewCell.h"
#import "JHBoss_AbnormalReminderViewController.h"
#import "PNChart.h"
#import "JHBoss_RestaurantModel.h"
#import "JHBoss_ChoiceRestView.h"
#import "JHBoss_RestPickerAppearance.h"
#import "HCGDatePickerAppearance.h"
#import "JHUserInfoData.h"
@interface JHBoss_DishDetailsViewController ()
<
   UITableViewDelegate,
   UITableViewDataSource,
   PNChartDelegate
>

@property (nonatomic, strong) UIScrollView *chartView;
@property (nonatomic, strong) UIView *chartHeaderView;
@property (nonatomic, strong) UILabel *unitLB;
@property (nonatomic, strong) PNLineChart *lineChart;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *time; // 日期
@property (nonatomic, copy) NSMutableArray<JHBoss_RestaurantModel *> *restaurantArray; // 餐厅数组
@property (nonatomic, strong) JHBoss_DishDetailModel *model;

//筛选栏
@property (nonatomic, strong) JHBoss_ChoiceRestView *choiceRestView;//选择餐厅的view
@property (nonatomic, strong) JHBoss_RestPickerAppearance *restPicker;//餐厅选择器
@property (nonatomic, strong) HCGDatePickerAppearance *datePicker;//时间选择器

//动画效果属性
@property (nonatomic, assign) CGFloat lastContentOffSetY;
//记录改变值
@property (nonatomic, assign) CGFloat changeOffset;
//
@property (nonatomic, assign) BOOL directionUP;

@end

@implementation JHBoss_DishDetailsViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"菜品详情"];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"菜品详情"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self requestAll];
    [self setUI];
}


#pragma mark - request

- (void)requestAll
{
    
    [self requestDishesDetailsInfo];
}


// 获取菜品详情
- (void)requestDishesDetailsInfo
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:self.restaurantId forKey:@"merchantId"];
    [param setObject:self.dishModel.dishId.stringValue forKey:@"dishId"];
    [param setObject:self.BegainSelectedDate forKey:@"startTime"];
     [param setObject:self.EndSelectedDate forKey:@"endTime"];
    [JHHttpRequest postRequestWithParams:param path:JH_DishesDetailsInfo isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            self.model = [JHBoss_DishDetailModel mj_objectWithKeyValues:dic[@"data"]];
            
            self.unitLB.text = [NSString stringWithFormat:@"单位: %@", self.model.unit];
            [self lineChartUI];
            
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
        [JHUtility hiddenGifProgressViewInView:self.view];
        
    }];
}


#pragma mark - UI



- (void)setUI
{
    @weakify(self);
    
    self.jhtitle = self.dishModel.dishName;
    //init 店铺和日期选择
    [self.view addSubview:self.choiceRestView];
    [self.choiceRestView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.height.mas_equalTo(kDEF_HEIGHT);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    // init tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(self.choiceRestView.mas_bottom);
    }];
    /*
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
       
        [self requestAll];
        [self.tableView.mj_header endRefreshing];
    }];
    
    [self.tableView addCustomGifFooterWithRefreshingBlock:^{
        @strongify(self);
        
        [self requestAll];
        [self.tableView.mj_footer endRefreshing];
    }];
     */
}

- (void)lineChartUI
{
    // added an example to show how yGridLines can be enabled
    // the color is set to clearColor so that the demo remains the same
    self.lineChart.showGenYLabels = YES;
    self.lineChart.showYGridLines = NO;
    self.lineChart.showLabel = YES;
    self.lineChart.showXMark = YES;
    self.lineChart.showYMark = YES;
    self.lineChart.chartMarginTop = 0;
    self.lineChart.chartInnerMarginLeft = 16;
    self.lineChart.chartInnerMarginRight = 32;
    self.lineChart.chartInnerMarginTop = 16;
    self.lineChart.yLabelFormat = @"%.0f";
    [self.lineChart setXLabels:self.model.xlist];
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
//    self.lineChart.yFixedValueMax = [[self.model.dataList valueForKeyPath:@"@max.floatValue"] floatValue];
    if ([[self.model.ylist valueForKeyPath:@"@max.floatValue"] floatValue] > 0.0) {
        
        self.lineChart.yFixedValueMax = [[self.model.ylist valueForKeyPath:@"@max.floatValue"] floatValue];
    }

    self.lineChart.yFixedValueMin = 0.0;
    
    // Line Chart #1
    NSArray *data01Array = self.model.ylist;
    PNLineChartData *data01 = [PNLineChartData new];
    
    data01.dataTitle = @"Alpha";
    data01.color = DEF_COLOR_CDA265;
    data01.lineWidth = 1.5;
    data01.pointLabelColor = [UIColor blackColor];
    data01.alpha = 1.0;
    data01.showPointLabel = YES;
    data01.pointLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:9.0];
    data01.itemCount = data01Array.count;
    data01.inflexionPointColor = DEF_COLOR_CDA265;
    data01.inflexionPointStyle = PNLineChartPointStyleCircle;
    data01.inflexionPointWidth = 7;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data01];
    [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
        obj.pointLabelColor = [UIColor blackColor];
    }];
    
    
    [self.lineChart strokeChart];
    self.lineChart.delegate = self;
}


#pragma mark - chart delegate

- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex pointIndex:(NSInteger)pointIndex {
    // todo
}

- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex {
    
}


#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section ? 0 : 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!indexPath.section) {
        //售出份数
        static NSString *reuseId = @"JHBoss_DishDetailTableViewCell";
        JHBoss_DishDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell) {
            cell = [[JHBoss_DishDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = self.model;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        return 90;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ? 10 + 250 + 10 : 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return nil;
    }
    
    UIView *header = [[UIView alloc] init];
    
    [header addSubview:self.chartHeaderView];
    [self.chartHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];
    
    [header addSubview:self.chartView];
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.left.and.right.mas_equalTo(0);
        make.height.mas_equalTo(214);
    }];
    
    return header;
}

//餐厅选择view
-(JHBoss_ChoiceRestView *)choiceRestView{
    
    if (!_choiceRestView) {
        _choiceRestView = [[JHBoss_ChoiceRestView alloc]initWithFrame:CGRectZero];
        
        if (self.restName.length > 0) {
            _choiceRestView.restName = self.restName;
        }
        
        if (self.BegainSelectedDate.length > 0) {
            NSDate *begainDate = [NSString dateWithString:self.BegainSelectedDate format:@"YYYY-MM-dd"];
            NSDate *endDate = [NSString dateWithString:self.EndSelectedDate format:@"YYYY-MM-dd"];
            _choiceRestView.selectTime = [NSString compareDate:begainDate endDate:endDate];
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
                    make.bottom.equalTo(self.view).offset(-29);
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
        @weakify(self);
        _restPicker = [[JHBoss_RestPickerAppearance alloc]initWithPickerType:JHBoss_PickerType_Rest param:restNames completeBlock:^(int index) {
            @strongify(self);
            JHBoss_RestaurantModel *restModel = self.restArr[index];
            self.choiceRestView.restName = restModel.name;
            self.restaurantId = restModel.Id.stringValue;
            
            [self requestDishesDetailsInfo];
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
        @weakify(self);
        _datePicker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerYearMonthDaySection MinDate:nil MaxDate:date completeBlock:^(NSArray *time) {
            @strongify(self);
            NSString *showDateStr;
            NSString *begainDateStr = time.firstObject;
            NSString *endDateStr = time.lastObject;
            NSDate *begainDate = [NSString dateWithString:begainDateStr format:@"YYYY年MM月dd日"];
            NSDate *endDate = [NSString dateWithString:endDateStr format:@"YYYY年MM月dd日"];
            showDateStr = [NSString compareDate:begainDate endDate:endDate];
            self.choiceRestView.selectTime = showDateStr;
            self.BegainSelectedDate = [NSString date:begainDate format:@"YYYY-MM-dd"];
            self.EndSelectedDate = [NSString date:endDate format:@"YYYY-MM-dd"];
            [self requestDishesDetailsInfo];
        }];
        _datePicker.titleStr = @"时段选择";
    }
    
    return _datePicker;
}


#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    return;
    if (scrollView.contentOffset.y > _lastContentOffSetY) {
        
        [self heardViewChangeHeight:scrollView.contentOffset.y upChange:YES];
        
    } else {
        
        [self heardViewChangeHeight:scrollView.contentOffset.y upChange:NO];
    }
    
    
    _lastContentOffSetY = scrollView.contentOffset.y;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    return;
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
            tmpValue = kDEF_HEIGHT/2;
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
                make.top.equalTo(self.navBar.mas_bottom);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.height.equalTo(@(changeH));
            }];
            
            CGFloat changeT_Y = (-(contentOffY/(kDEF_HEIGHT/4)) < -1)?-1:-(contentOffY/(kDEF_HEIGHT/4)) < 0? 0 : -(contentOffY/(kDEF_HEIGHT/4));
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-29);
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
        
        if (contentOffY < kDEF_HEIGHT && contentOffY > -(kDEF_HEIGHT/2)) {
            
            CGFloat height = self.choiceRestView.frame.size.height;
            CGFloat tmpH   = height + (contentOffY<10?10:(contentOffY/(kDEF_HEIGHT/4)));
            
            self.changeOffset = tmpH;
            
            [self.choiceRestView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(tmpH>kDEF_HEIGHT?kDEF_HEIGHT:tmpH));
                make.top.equalTo(self.navBar.mas_bottom);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
            }];
            
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.choiceRestView.mas_bottom);
                make.left.equalTo(self.view);
                make.right.equalTo(self.view);
                make.bottom.equalTo(self.view).offset(-29);
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



#pragma mark - setter/getter


- (UIScrollView *)chartView
{
    if (!_chartView) {
        _chartView = [[UIScrollView alloc] init];
        _chartView.backgroundColor= [UIColor whiteColor];
        _chartView.contentSize = CGSizeMake(DEF_WIDTH * 3, 214);
        _chartView.contentOffset = CGPointMake(DEF_WIDTH * 2, 0);
        [_chartView addSubview:self.lineChart];
    }
    return _chartView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (PNLineChart *)lineChart
{
    if (!_lineChart) {
        _lineChart.backgroundColor = [UIColor whiteColor];
        [_lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
            obj.pointLabelColor = [UIColor blackColor];
        }];
        
        _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 3 + 30, 200.0)];
        // 显示坐标轴
        _lineChart.showCoordinateAxis = YES;
        _lineChart.yLabelFormat = @"%1.1f";
        _lineChart.xLabelFont = DEF_SET_FONT(11);
        _lineChart.xLabelColor = DEF_COLOR_6E6E6E;
        _lineChart.yLabelColor = [UIColor blackColor];
    }
    return _lineChart;
}

- (UIView *)chartHeaderView
{
    if (!_chartHeaderView) {
        _chartHeaderView = [[UIView alloc] init];
        _chartHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel *tipLB = [[UILabel alloc] init];
        tipLB.text = @"分时数据";
        tipLB.textColor = DEF_COLOR_6E6E6E;
        tipLB.font = DEF_SET_FONT(14);
        [_chartHeaderView addSubview:tipLB];
        [tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
        
        _unitLB = [[UILabel alloc] init];
//        _unitLB.text = @"单位：份";
        _unitLB.textColor = DEF_COLOR_A1A1A1;
        _unitLB.font = DEF_SET_FONT(12);
        [_chartHeaderView addSubview:_unitLB];
        [_unitLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = DEF_COLOR_LINEVIEW;
        [_chartHeaderView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _chartHeaderView;
}


- (NSString *)time
{
    if (!_time) {
        _time =  [NSString timeIntervalFromDate:[NSDate date]];
    }
    return _time;
}

- (NSMutableArray<JHBoss_RestaurantModel *> *)restaurantArray
{
    if (!_restaurantArray) {
        _restaurantArray = [NSMutableArray array];
    }
    return _restaurantArray;
}

@end
