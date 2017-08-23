//
//  JHBoss_ClientAnalyzeViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/6/23.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ClientAnalyzeViewController.h"
#import "JHBoss_ClientAnalyzeDataTableViewCell.h"
#import "JHBoss_ClientAnalyzeTasteTableViewCell.h"
#import "JHBoss_ChoiceRestView.h"
#import "JHBoss_RestPickerAppearance.h"
#import "HCGDatePickerAppearance.h"
#import "JHUserInfoData.h"
#import "JHBoss_TurnoverOrFlowOrPriceModel.h"
#import "JHBoss_WelcomeDishsModel.h"
@interface JHBoss_ClientAnalyzeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy)   NSString *restaurantId;
@property (nonatomic, strong) NSDictionary *restInfoDic;
@property (nonatomic, strong) JHBoss_TurnoverOrFlowOrPriceModel *flowModel;//客流量
@property (nonatomic, strong) JHBoss_TurnoverOrFlowOrPriceModel *clientPriceModel;//客单价
@property (nonatomic, strong) NSMutableArray *welcomeDishsArr;//最受欢迎的菜系

//筛选栏
@property (nonatomic, strong) JHBoss_ChoiceRestView *choiceRestView;//选择餐厅的view
@property (nonatomic, strong) JHBoss_RestPickerAppearance *restPicker;//餐厅选择器
@property (nonatomic, strong) HCGDatePickerAppearance *datePicker;//时间选择器

@property (nonatomic, strong) JHUserInfoData *userInfo;
//动画效果属性
@property (nonatomic, assign) CGFloat lastContentOffSetY;
//记录改变值
@property (nonatomic, assign) CGFloat changeOffset;
//
@property (nonatomic, assign) BOOL directionUP;
@end

@implementation JHBoss_ClientAnalyzeViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}


// 获取客流量和客单价数据
- (void)requestData:(int)type
{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.restaurantId forKey:@"merchantId"];
    [param setValue:@(type) forKey:@"requestType"];
    [param setValue:self.BegainSelectedDate forKey:@"startTime"];
    [param setValue:self.EndSelectedDate forKey:@"endTime"];
    [JHUtility showGifProgressViewInView:DEF_Window];
    [JHHttpRequest postRequestWithParams:param path:JH_TurnoverFlowPriceURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (type == 2) {
                
            self.flowModel = [JHBoss_TurnoverOrFlowOrPriceModel mj_objectWithKeyValues:dic[@"data"]];

            }else{
            
            self.clientPriceModel = [JHBoss_TurnoverOrFlowOrPriceModel mj_objectWithKeyValues:dic[@"data"]];
            }

        }
        [JHUtility hiddenGifProgressViewInView:DEF_Window];
      [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
        [JHUtility hiddenGifProgressViewInView:DEF_Window];
        
    }];
}

//最受欢迎的菜系  暂时不用
-(void)welcomeDishs{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.restaurantId forKey:@"merchantId"];
    
    [param setValue:self.BegainSelectedDate forKey:@"startDate"];
    [param setValue:self.EndSelectedDate forKey:@"endDate"];
    
    [JHHttpRequest postRequestWithParams:param path:JH_welcomeDishsURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
        self.welcomeDishsArr = [JHBoss_WelcomeDishsModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            
        }
       
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:YES];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
        [JHUtility hiddenGifProgressViewInView:self.view];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.restInfoDic = [JHUserInfoData getCurrentSelectRestInfo];
    if (isObjNotEmpty(self.restInfoDic)) {
        self.restaurantId = self.restInfoDic[@"restId"];
    }
    if (self.clientPricOrFlow == JHBoss_ClientPrice) {
        self.jhtitle = @"客单价";
    }else if (self.clientPricOrFlow == JHBoss_ClientFlow){
        self.jhtitle = @"客流量";
    }
    [self allRequest];
    [self setUpUI];
}

-(void)allRequest{

    if (self.clientPricOrFlow == JHBoss_ClientPrice) {
       
        [self requestData:3];
    }else if (self.clientPricOrFlow == JHBoss_ClientFlow){
        
        [self requestData:2];
    }

}

-(void)setUpUI{


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
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.choiceRestView.mas_bottom);
        make.left.right.and.bottom.mas_equalTo(0);
    }];
    
    [self.tableView registerClass:[JHBoss_ClientAnalyzeDataTableViewCell class] forCellReuseIdentifier:@"JHBoss_ClientAnalyzeDataTableViewCell"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.flowModel || self.clientPriceModel ? 1 : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"JHBoss_ClientAnalyzeDataTableViewCell";
    JHBoss_ClientAnalyzeDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.clientPricOrFlow == JHBoss_ClientFlow) {
        
     cell.model = self.flowModel;
    }else if(self.clientPricOrFlow == JHBoss_ClientPrice){
        
     cell.model = self.clientPriceModel;
    }
   
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 360;
}


//餐厅选择view
-(JHBoss_ChoiceRestView *)choiceRestView{
    
    if (!_choiceRestView) {
        _choiceRestView = [[JHBoss_ChoiceRestView alloc]initWithFrame:CGRectZero];
        
        if (self.restInfoDic) {
            _choiceRestView.restName = self.restInfoDic[@"restName"];
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
        @weakify(self);
        _restPicker = [[JHBoss_RestPickerAppearance alloc]initWithPickerType:JHBoss_PickerType_Rest param:restNames completeBlock:^(int index) {
            @strongify(self);
            JHBoss_RestaurantModel *restModel = self.restArr[index];
            self.choiceRestView.restName = restModel.name;
            self.restaurantId = restModel.Id.stringValue;
            [self allRequest];
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
            [self allRequest];
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
