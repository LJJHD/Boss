//
//  JHBoss_DishesViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_DishesViewController.h"
#import "JHBoss_DishesTableViewCell.h"
#import "JHBoss_DishDetailsViewController.h"
#import "JHBoss_RestaurantModel.h"

#import "JHBoss_StaffOrDishsRangkingView.h"
#import "JHBoss_RestPickerAppearance.h"
#import "HCGDatePickerAppearance.h"
#import "JHUserInfoData.h"
#import "JHBoss_StaffRankingConditionModel.h"//和员工排序的model是一样的
@interface JHBoss_DishesViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIView *sortView; // 排序
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy)   NSString *time;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray<JHBoss_StaffRankingConditionModel *> *dishRankContionArr;//员工排序arr
@property (nonatomic, copy)   NSString *dishContionStr;//员工排序条件
@property (nonatomic, copy) NSString *selectedDate;

@property (nonatomic, assign) BOOL loading; // 是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView; // 数据加载过程中显示加载动画的view

//筛选栏
@property (nonatomic, strong) JHBoss_StaffOrDishsRangkingView *choiceRestView;//选择餐厅的view
@property (nonatomic, strong) JHBoss_RestPickerAppearance *restPicker;//餐厅选择器
@property (nonatomic, strong) JHBoss_RestPickerAppearance *rankingContion;//菜品排序条件选择器
@property (nonatomic, strong) HCGDatePickerAppearance *datePicker;//时间选择器
@property (nonatomic, strong) JHUserInfoData *userInfo;
@property (nonatomic, strong) NSDictionary *userInfoDic;
//动画效果属性
@property (nonatomic, assign) CGFloat lastContentOffSetY;
//记录改变值
@property (nonatomic, assign) CGFloat changeOffset;
//
@property (nonatomic, assign) BOOL directionUP;
@end


@implementation JHBoss_DishesViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.page = 1;
    [self requestAll];
    [self setUI];
}


#pragma mark - request

- (void)requestAll
{
    [self requestDishesListCondition];
}


// 获取菜品列表  JH_DishListCondition
- (void)requestDishesList
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:@(self.restaurantId) forKey:@"merchantId"];
    [param setValue:@{@"currentPage":@(self.page),@"pageSize":@(20)} forKey:@"page"];
    [param setValue:_BegainSelectedDate forKey:@"startTime"];
    [param setValue:_EndSelectedDate forKey:@"endTime"];
    [param  setValue:self.dishContionStr forKey:@"sortAttribute"];
    [param setValue:@(false) forKey:@"sortType"];
    [JHHttpRequest postRequestWithParams:param path:JH_GetDishesList isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:[JHBoss_DishModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"list"]]];
        }
        [self commonConfiguration];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [self commonConfiguration];
    }];
}

// 获取菜品列表排序条件
- (void)requestDishesListCondition
{
    @weakify(self)
    [JHHttpRequest postRequestWithParams:@{} path:JH_DishListCondition isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
        
            self.dishRankContionArr = [JHBoss_StaffRankingConditionModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            JHBoss_StaffRankingConditionModel *model = self.dishRankContionArr.firstObject;
            self.dishContionStr = model.attribute;
            self.choiceRestView.rangkingLbStr = model.sortName;
            [self requestDishesList];
        }
        
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        
        
    }];
}

#pragma mark - UI

- (void)setUI
{
    @weakify(self);
    self.jhtitle = @"菜品排行";
   
    //init 店铺和日期选择
    [self.view addSubview:self.choiceRestView];
    [self.choiceRestView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.height.mas_equalTo(staffRangkingHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];

    
    // init sortView
    [self.view addSubview:self.sortView];
    [self.sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.mas_equalTo(0);
        make.top.equalTo(self.choiceRestView.mas_bottom);
        make.height.mas_equalTo(30);
    }];
    
    // init tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.equalTo(self.sortView.mas_bottom);
    }];
    
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self requestAll];
        [self.tableView.mj_header endRefreshing];
    }];
    [self.tableView addCustomGifFooterWithRefreshingBlock:^{
        @strongify(self);
        self.page ++;
        [self requestAll];
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"JHBoss_DishesTableViewCell";
    JHBoss_DishesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[JHBoss_DishesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.sortNum = indexPath.row + 1;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JHBoss_DishDetailsViewController *dishDetailsVC = [[JHBoss_DishDetailsViewController alloc] init];
    dishDetailsVC.restaurantId = [NSString stringWithFormat:@"%ld",self.restaurantId];
    dishDetailsVC.dishModel = self.dataArray[indexPath.row];
    dishDetailsVC.restName = self.userInfoDic[@"restName"];
    dishDetailsVC.restArr = self.restArr;
    dishDetailsVC.BegainSelectedDate = self.BegainSelectedDate;
    dishDetailsVC.EndSelectedDate = self.EndSelectedDate;
    [self.navigationController pushViewController:dishDetailsVC animated:YES];
}

#pragma mark - setter/getter

- (UIView *)sortView
{
    if (!_sortView) {
        _sortView = [[UIView alloc] init];
        _sortView.backgroundColor = [UIColor whiteColor];
        
        UILabel *noLB = [[UILabel alloc] init];
        noLB.font = DEF_SET_FONT(12);
        noLB.textColor = DEF_COLOR_A1A1A1;
        noLB.text = @"序号";
        [_sortView addSubview:noLB];
        [noLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(18);
            make.centerY.mas_equalTo(0);
        }];
        
        UILabel *dishNameLB = [[UILabel alloc] init];
        dishNameLB.font = DEF_SET_FONT(12);
        dishNameLB.textColor = DEF_COLOR_A1A1A1;
        dishNameLB.text = @"菜品名称";
        [_sortView addSubview:dishNameLB];
        [dishNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(65);
            make.centerY.mas_equalTo(0);
        }];
        
        UIButton *saleNoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saleNoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [saleNoBtn setTitle:@"销量"];
        saleNoBtn.titleLabel.font = DEF_SET_FONT(12);
        [saleNoBtn setTitleColor:DEF_COLOR_A1A1A1 forState:UIControlStateNormal];
        [_sortView addSubview:saleNoBtn];
        [saleNoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(MYDIMESCALE(150));
            make.centerX.equalTo(_sortView);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(28, 12));
        }];


        UIButton *goodEvaluationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        goodEvaluationBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [goodEvaluationBtn setTitle:@"好评"];
        goodEvaluationBtn.titleLabel.font = DEF_SET_FONT(12);
        [goodEvaluationBtn setTitleColor:DEF_COLOR_A1A1A1 forState:UIControlStateNormal];
        [_sortView addSubview:goodEvaluationBtn];
        [goodEvaluationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(MYDIMESCALE(-105));
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(28, 12));
        }];

        UILabel *compareLB = [[UILabel alloc] init];
        compareLB.font = DEF_SET_FONT(12);
        compareLB.textColor = DEF_COLOR_A1A1A1;
        compareLB.text = @"点选率";
        [_sortView addSubview:compareLB];
        [compareLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(MYDIMESCALE(-30.5));
            make.centerY.mas_equalTo(0);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = DEF_COLOR_LINEVIEW;
        [_sortView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        
        
//        UIView *bottomLine = [[UIView alloc] init];
//        bottomLine.backgroundColor = DEF_COLOR_CDA265;
//        [_sortView addSubview:bottomLine];
//        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-MYDIMESCALE(105));
//            make.bottom.mas_equalTo(0);
//            make.size.mas_equalTo(CGSizeMake(28, 3));
//        }];
        
//        @weakify(bottomLine);
//        [[goodEvaluationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(bottomLine);
//            [UIView animateWithDuration:0.25 animations:^{
//                bottomLine.centerX = [(UIView *)x center].x;
//            }];
//        }];
//        [[saleNoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//            @strongify(bottomLine);
//            [UIView animateWithDuration:0.25 animations:^{
//                bottomLine.centerX = [(UIView *)x center].x;
//            }];
//        }];
    }
    return _sortView;
}


#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (self.dataArray.count < 20) {
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
//    if (self.dataArray.count < 20) {
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
            tmpValue = staffRangkingHeight/3+10;
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

//餐厅选择view
-(JHBoss_StaffOrDishsRangkingView *)choiceRestView{
    
    if (!_choiceRestView) {
        _choiceRestView = [[JHBoss_StaffOrDishsRangkingView alloc]initWithFrame:CGRectZero];
        @weakify(self);
        self.userInfoDic = [JHUserInfoData getCurrentSelectRestInfo];
        if (isObjNotEmpty(self.userInfoDic)) {
            @strongify(self);
            self.choiceRestView.restName = self.userInfoDic[@"restName"];
        }

        if (self.BegainSelectedDate.length > 0) {
            NSDate *begainDate = [NSString dateWithString:self.BegainSelectedDate format:@"YYYY-MM-dd"];
            NSDate *endDate = [NSString dateWithString:self.EndSelectedDate format:@"YYYY-MM-dd"];
            _choiceRestView.selectTime = [NSString compareDate:begainDate endDate:endDate];
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
                
                
                [self restPicker];
                self.restPicker.titleStr = @"店铺选择";
                [self.restPicker show];
            }
            
            
        };
        
        _choiceRestView.selectTimeHandler = ^{
            @strongify(self);
            
            [self.datePicker show];
            
        };
        
        _choiceRestView.rangkingHandler = ^{
            @strongify(self);
            [self.rankingContion show];
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
            self.restaurantId = restModel.Id.integerValue;
            //请求数据
            self.page = 1;
            [self requestDishesList];
            //存储当前选中的餐厅信息
            NSDictionary *restInfo = @{@"restId":restModel.Id.stringValue,@"restName":restModel.name};
            [JHUserInfoData saveCurrentSelectRestInfo:restInfo];
        }];
    }
    
    return _restPicker;
}

//懒加载菜品排序条件选择器 rankingContion
-(JHBoss_RestPickerAppearance *)rankingContion{

    if (!_rankingContion) {
        
        @weakify(self);
       __block NSMutableArray *conditonArr = [NSMutableArray array];

        [self.dishRankContionArr enumerateObjectsUsingBlock:^(JHBoss_StaffRankingConditionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [conditonArr addObject:obj.sortName];
            
        }];
        
        _rankingContion = [[JHBoss_RestPickerAppearance alloc]initWithPickerType:JHBoss_PickerType_Rest param:conditonArr completeBlock:^(int index) {
            @strongify(self);
            JHBoss_StaffRankingConditionModel *model = self.dishRankContionArr[index];
            self.choiceRestView.rangkingLbStr = model.sortName;
            self.dishContionStr = model.attribute;
            //请求数据
             self.page = 1;
            [self requestDishesList];
            
        }];
        _rankingContion.titleStr = @"菜品排序条件";
    }
    return _rankingContion;
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
             self.page = 1;
            [self requestDishesList];
        }];
        _datePicker.titleStr = @"时段选择";
    }
    
    return _datePicker;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 50;
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



- (NSString *)time
{
    if (!_time) {
        _time =  [NSString timeIntervalFromDate:[NSDate date]];
    }
    return _time;
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
    return -60;
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

-(void)commonConfiguration{
    _loading = NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.loadDataView stopAnimation];
}




@end
