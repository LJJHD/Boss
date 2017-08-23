//
//  JHBoss_SubbranchViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/6/21.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_SubbranchViewController.h"
#import "JHBoss_DishesRangkingTableViewCell.h"
#import "JHBoss_ChoiceRestView.h"
#import "JHBoss_RestPickerAppearance.h"
#import "HCGDatePickerAppearance.h"
#import "JHBoss_AllRestRangkingModel.h"
#import "JHBoss_StaffRankingConditionModel.h"
#import "JHUserInfoData.h"
@interface JHBoss_SubbranchViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSMutableArray<JHBoss_AllRestRangkingModel *> *restaurantArray; // 餐厅数组
@property (nonatomic, copy) NSMutableArray<JHBoss_StaffRankingConditionModel *> *restRangkingConditionArr; // 员工排行条件
@property (nonatomic, copy) NSString *sortCodition;//筛选条件
@property (nonatomic, copy) NSString *merchanId;
//加载动画和空页面处理
@property (nonatomic, assign) BOOL loading; // 是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView; // 数据加载过程中显示加载动画的view

//筛选栏
@property (nonatomic, strong) JHBoss_ChoiceRestView *choiceRestView;//选择餐厅的view
@property (nonatomic, strong) JHBoss_RestPickerAppearance *restRankingPicker;//餐厅排序条件选择器
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

@implementation JHBoss_SubbranchViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"分店"];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"分店"];
}


//获取用户登录信息
-(void)requestUserInfo{
    
    @weakify(self);
    
    [self.userInfo getUserInfoIdentify:saveUserIdentify result:^(NSDictionary *result) {
        @strongify(self);
        self.merchanId = result[@"merchantId"];
         [self requestRestRangkingCondition];
    }];
}

//获取分店排行条件
- (void)requestRestRangkingCondition
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_AllRestRangkingCondition isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            self.restRangkingConditionArr = [JHBoss_StaffRankingConditionModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            JHBoss_StaffRankingConditionModel *model = self.restRangkingConditionArr.firstObject;
            self.sortCodition = model.attribute;
            [self requestRestaurants];
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

// 请求餐厅列表
- (void)requestRestaurants
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //self.merchanId
    [param setValue:self.merchanId forKey:@"merchantId"];
    [param setValue:self.sortCodition forKey:@"orderBy"];
    [param setValue:@(0) forKey:@"sortType"];
    [param setValue:_BegainSelectedDate forKey:@"startTime"];
    [param setValue:_EndSelectedDate forKey:@"endTime"];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_getAllRestRangking isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
        self.restaurantArray = [JHBoss_AllRestRangkingModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"branchDetail"]];
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
    [self requestUserInfo];
   
    [self setUpUI];
}

-(void)setUpUI{

    //init 店铺和日期选择
    @weakify(self);
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
        make.top.equalTo(self.choiceRestView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);//-29
    }];
    
    [self.view bringSubviewToFront:self.tableView];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_DishesRangkingTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_DishesRangkingTableViewCell"];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.restaurantArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"JHBoss_DishesRangkingTableViewCell";
    JHBoss_DishesRangkingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    cell.rangkingType = enterIntoType_restRangking;
    cell.restRangkingModel = self.restaurantArray[indexPath.row];
    if (indexPath.row <= 3) {
        cell.rangkingImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"1.1_icon_%ld",indexPath.row+1]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 90;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}


-(JHBoss_ChoiceRestView *)choiceRestView{
    
    if (!_choiceRestView) {
        _choiceRestView = [[JHBoss_ChoiceRestView alloc]initWithFrame:CGRectZero];
        _choiceRestView.restImageStr = @"2.2.2.1_icon_paihang";
        _choiceRestView.restName = @"按营业额";
        @weakify(self);
        _choiceRestView.choiceRestHandler = ^{
            @strongify(self);
            [self restRankingPicker];
            self.restRankingPicker.titleStr = @"筛选条件";
            [self.restRankingPicker show];
        };
        
        _choiceRestView.selectTimeHandler = ^{
            @strongify(self);
            
            [self.datePicker show];
            
        };
    }
    
    return _choiceRestView;
}

//餐厅排序懒加载
-(JHBoss_RestPickerAppearance *)restRankingPicker{
    
    if (!_restRankingPicker) {
        
      __block  NSMutableArray *restNames = [NSMutableArray array];
        [self.restRangkingConditionArr enumerateObjectsUsingBlock:^(JHBoss_StaffRankingConditionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [restNames addObject:obj.sortName];
        }];
        @weakify(self);
        _restRankingPicker = [[JHBoss_RestPickerAppearance alloc]initWithPickerType:JHBoss_PickerType_Rest param:restNames completeBlock:^(int index) {
            @strongify(self);
            JHBoss_StaffRankingConditionModel *Model = self.restRangkingConditionArr[index];
            self.choiceRestView.restName = Model.sortName;
            self.sortCodition = Model.attribute;
            [self requestRestaurants];
        }];
    }
    
    return _restRankingPicker;
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
            [self requestRestaurants];
        }];
        _datePicker.titleStr = @"时段选择";
    }
    
    return _datePicker;
}

-(JHUserInfoData *)userInfo{

    if (!_userInfo) {
        _userInfo = [[JHUserInfoData alloc]init];
    }
    return _userInfo;
}


#pragma mark - scrollView delegate  动画效果用

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
                make.bottom.equalTo(self.view).offset(-29);
                make.top.equalTo(self.choiceRestView.mas_bottom).offset(changeT_Y);
            }];
            
            self.choiceRestView.selectTimeBackView.alpha = kALPHA_SPACE/contentOffY;
            self.choiceRestView.restNameBackView.alpha = kALPHA_SPACE*4/contentOffY;
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
                make.bottom.equalTo(self.view).offset(-29);
            }];
            
            if (contentOffY > 0) {
                self.choiceRestView.selectTimeBackView.alpha = kALPHA_SPACE/contentOffY;
                self.choiceRestView.restNameBackView.alpha = kALPHA_SPACE*4/contentOffY;
            }
        }
    }
    
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
    [self requestRestaurants];
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



- (BOOL)disableAutomaticSetNavBar
{
    return YES;
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
