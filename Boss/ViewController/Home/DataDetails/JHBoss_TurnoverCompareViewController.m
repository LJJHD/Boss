//
//  JHBoss_TurnoverCompareViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/6/28.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_TurnoverCompareViewController.h"
#import "JHBoss_TurnoverCompareLineTableViewCell.h"
#import "JHBoss_TurnoverCompareHistogramTableViewCell.h"
#import "JHBoss_ChoiceRestView.h"
#import "JHBoss_RestPickerAppearance.h"
#import "HCGDatePickerAppearance.h"
#import "JHUserInfoData.h"
#import "JHBoss_RestaurantModel.h"
#import "JHBoss_TurnoverCompareModel.h"
@interface JHBoss_TurnoverCompareViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHBoss_TurnoverCompareModel *turnoverCompareMD;

//筛选栏
@property (nonatomic, strong) JHBoss_ChoiceRestView *choiceRestView;//选择餐厅的view
@property (nonatomic, strong) JHBoss_RestPickerAppearance *restPicker;//餐厅选择器
@property (nonatomic, strong) HCGDatePickerAppearance *datePicker;//时间选择器
@property (nonatomic, copy) NSString *BegainSelectedDate;//选中的开始日期
@property (nonatomic, copy) NSString *EndSelectedDate;//选中的结束日期
@property (nonatomic, strong) JHUserInfoData *userInfo;
@property (nonatomic, strong) NSDictionary *restInfoDic;//存储选择的餐厅信息(从本地取的)
@property (nonatomic, copy)   NSString *restaurantId;
//动画效果属性
@property (nonatomic, assign) CGFloat lastContentOffSetY;
//记录改变值
@property (nonatomic, assign) CGFloat changeOffset;
//
@property (nonatomic, assign) BOOL directionUP;
@end

@implementation JHBoss_TurnoverCompareViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


//获取同环比数据
- (void)requestData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@(25) forKey:@"merchantId"];
    [param setValue:self.BegainSelectedDate forKey:@"startTime"];
    [param setValue:self.EndSelectedDate forKey:@"endTime"];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_turnoverCompareURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            self.turnoverCompareMD = [JHBoss_TurnoverCompareModel mj_objectWithKeyValues:dic[@"data"]];
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *date = [NSDate date];
    NSString *today = [date transformDateFromFormatterString:@"YYYY-MM-dd"];
    self.BegainSelectedDate = today;
    self.EndSelectedDate = today;
    self.restInfoDic = [JHUserInfoData getCurrentSelectRestInfo];
    if (isObjNotEmpty(self.restInfoDic)) {
        self.restaurantId = self.restInfoDic[@"restId"];
    }
    [self requestData];
    [self setUpUI];
}

-(void)setUpUI{

    self.jhtitle = @"营业额同比环比";
     @weakify(self);
    //init 店铺和日期选择
    [self.view addSubview:self.choiceRestView];
    [self.choiceRestView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.height.mas_equalTo(kDEF_HEIGHT);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.choiceRestView.mas_bottom);
        make.left.and.right.and.bottom.mas_equalTo(0);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.turnoverCompareMD.thisYearTurnover ? 2 : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!indexPath.row) {
        static NSString *reuse = @"JHBoss_TurnoverCompareHistogramTableViewCell";
        JHBoss_TurnoverCompareHistogramTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        cell.model = self.turnoverCompareMD;
        return cell;
        
    }else{
        
        static NSString *reuse = @"JHBoss_TurnoverCompareLineTableViewCell";
        JHBoss_TurnoverCompareLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        cell.model = self.turnoverCompareMD;
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

   
    if (!indexPath.row) {
        
        return 338.5;
    }else{
    
        return 318.5;
    }
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
            [self requestData];
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
            [self requestData];
        }];
        _datePicker.titleStr = @"时段选择";
    }
    
    return _datePicker;
}


-(UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[JHBoss_TurnoverCompareLineTableViewCell class] forCellReuseIdentifier:@"JHBoss_TurnoverCompareLineTableViewCell"];
          [_tableView registerClass:[JHBoss_TurnoverCompareHistogramTableViewCell class] forCellReuseIdentifier:@"JHBoss_TurnoverCompareHistogramTableViewCell"];
    }
    return _tableView;
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
