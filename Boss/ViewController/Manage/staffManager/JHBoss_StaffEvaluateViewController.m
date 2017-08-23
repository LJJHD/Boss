//
//  JHBoss_StaffEvaluateViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffEvaluateViewController.h"
#import "JHBoss_StaffEvaluateTableViewCell.h"
#import "JHBoss_staffEvaluateHeaderView.h"
#import "JHBoss_MoreStaffEvaluateListModel.h"
#import "JHCRM_LoadDataView.h"
#import "JHBoss_MoreStaffEvaluateHeaderView.h"
@interface JHBoss_StaffEvaluateViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) JHBoss_MoreStaffEvaluateHeaderView *headerView;

@property (nonatomic, strong) UILabel *staffEvaluateLab;//员工评价label

@property (nonatomic, assign) int pageNum;//当前页码
@property (nonatomic, assign)  JH_RefreshType refreshType;
@property (nonatomic, assign) BOOL loading; //是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView;//数据加载过程中显示加载动画的view

@property (nonatomic, strong) MyFlowLayout *flowLayout;
@property (nonatomic, strong) MyLinearLayout *linearLayout;
@property (nonatomic, strong) UIButton *moreBtn;
@end

@implementation JHBoss_StaffEvaluateViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArr = [NSMutableArray array];
     _loading = YES;
    _pageNum = 1;
    [self loadData];
    [self setUI];
    
    //下拉刷新
    @weakify(self);
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.pageNum = 1;
        self.refreshType = JH_RefreshType_pullDown;
        [self loadData];
    }];
    
    
    //上提加载
    [self.tableView addCustomGifFooterWithRefreshingBlock:^{
        @strongify(self);
        self.refreshType = JH_RefreshType_pullUp;
        [self loadData];
    }];

}


-(void)setUI{

    self.jhtitle = @"查看更多评价";
//    [self.view addSubview:[UIView new]];
    [self.view addSubview:self.tableView];
   
    self.tableView.tableHeaderView.backgroundColor = DEF_COLOR_ECECEC;
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.trailing.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    
    //设置tableHeaderView
    /*
     老的
     self.headerView = [[JHBoss_staffEvaluateHeaderView alloc]initWithFrame:CGRectZero];
     self.headerView.staffDetailModel = self.staffDetailModel;
     self.tableView.tableHeaderView = self.headerView;
     */
    
    if (isObjNotEmpty(self.staffDetailModel.evaluationList)) {
        
        self.headerView = [[JHBoss_MoreStaffEvaluateHeaderView alloc]initWithFrame:CGRectMake(0, 0,  CGRectGetWidth(self.view.bounds), 0) orientation:MyOrientation_Vert flagArr:self.staffDetailModel.evaluationList];
        self.headerView.frame = CGRectMake(0, 0,  CGRectGetWidth(self.view.bounds), 0);
        self.headerView.backgroundColor = [UIColor whiteColor];
        [self.headerView layoutIfNeeded];
        self.tableView.tableHeaderView = self.headerView;
        
        self.headerView.showMoreBlock = ^(UIButton *sender) {
            @strongify(self);
            
            sender.selected = !sender.selected;
            self.headerView.flowLayout.wrapContentHeight = sender.selected;
            
            if (!sender.selected) {
                
                self.headerView.flowLayout.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 105);
                
            }
            [self.tableView beginUpdates];
            //因为tableHeaderView的特殊情况。如果需要调整tableHeaderView的高度时需要编写如下代码！！！！！
            [self.tableView.tableHeaderView layoutIfNeeded];
            self.tableView.tableHeaderView = self.tableView.tableHeaderView;
            [self.tableView endUpdates];
            
        };
 
    }
   
 //    self.headerView = [[JHBoss_MoreStaffEvaluateHeaderView alloc]initWithFrame:CGRectMake(0, 0,  CGRectGetWidth(self.tableView.bounds), 259) orientation:MyOrientation_Vert];
    
//     NSArray *arr = @[@"sdfadsfd 33 ",@"水电费第三方 66",@"是否 34",@"对方水电费是 12"];
   
    
//    [self headView];
}

//暂时不要

-(void)headView{
    
    
     NSArray *arr = @[@"sdfadsfd 33 ",@"水电费第三方 66",@"是否 34",@"对方水电费是 12"];

    self.linearLayout = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Vert];
    self.linearLayout.wrapContentWidth = NO;
    self.linearLayout.wrapContentHeight = YES;
    self.linearLayout.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0);
    self.linearLayout.backgroundColor = [UIColor yellowColor];
    
    
    self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
    
    if (arr.count >= 12) {
        
         self.flowLayout.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 105);
        self.flowLayout.wrapContentHeight = NO;
    }else{
    
      
        self.flowLayout.wrapContentHeight = YES;
       
    }
    self.flowLayout.wrapContentWidth = NO;
    self.flowLayout.padding = UIEdgeInsetsMake(10, 25, 10, 25);
    self.flowLayout.backgroundColor = [UIColor whiteColor];
    self.flowLayout.subviewSpace = 8; //流式布局里面的子视图的水平和垂直间距都设置为10
    self.flowLayout.myHorzMargin = 0;
    self.flowLayout.layer.masksToBounds = YES;
    
    for (int i = 0 ; i < arr.count; i++) {
        
        UILabel *showLabel = [UILabel new];
        showLabel.text = arr[i];
        showLabel.textAlignment = NSTextAlignmentCenter;
        showLabel.textColor = DEF_COLOR_RGB(161, 161, 161);
        showLabel.layer.borderWidth = 0.5;
        showLabel.layer.borderColor = DEF_COLOR_RGB(161, 161, 161).CGColor;
        showLabel.layer.cornerRadius = 2;
        showLabel.layer.masksToBounds = YES;
        showLabel.widthSize.equalTo(showLabel.widthSize).add(15);
        showLabel.font = DEF_SET_FONT(13);
        showLabel.heightSize.equalTo(@25);
        [showLabel sizeToFit];
        [self.flowLayout addSubview:showLabel];
    }
    
    self.flowLayout.autoArrange = YES;
    [self.linearLayout addSubview:self.flowLayout];
    
    
    if (arr.count >= 12) {
        
        self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreBtn.myLeft = self.moreBtn.myRight = 0;
        self.moreBtn.myHeight = 44;
        self.moreBtn.myBottom = 0;
        self.moreBtn.backgroundColor = [UIColor whiteColor];
        [self.moreBtn setimage:@"1.1_btn_dropdown_default"];
        [self.moreBtn addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
        [self.linearLayout addSubview:self.moreBtn];
        
    }

    [self.linearLayout layoutIfNeeded];
      DPLog(@"self.linearLayout.frame====%@",NSStringFromCGRect(self.linearLayout.frame));
    self.tableView.tableHeaderView = self.linearLayout;
    
  
}

-(void)showMore:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    self.flowLayout.wrapContentHeight = sender.selected;
    
    if (!sender.selected) {
        
     self.flowLayout.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 105);
       
    }
    
    [self.tableView beginUpdates];
    
    //因为tableHeaderView的特殊情况。如果需要调整tableHeaderView的高度时需要编写如下代码！！！！！
    [self.tableView.tableHeaderView layoutIfNeeded];
     self.tableView.tableHeaderView = self.tableView.tableHeaderView;
    [self.tableView endUpdates];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"StaffEvaluateTableViewCell";
    JHBoss_StaffEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    JHBoss_MoreStaffEvaluateListModel *model = self.dataArr[indexPath.row];
    
    cell.EvaluationListModel = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    return 60;
    return  [tableView fd_heightForCellWithIdentifier:@"StaffEvaluateTableViewCell" cacheByIndexPath:indexPath configuration:^(JHBoss_StaffEvaluateTableViewCell * cell) {
        
        [self configuration:cell indexPath:indexPath];
    }];
}

-(void)configuration:(JHBoss_StaffEvaluateTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{

    JHBoss_MoreStaffEvaluateListModel *model = self.dataArr[indexPath.row];
    cell.EvaluationListModel = model;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 45;
    }
    return 0.0001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.0001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *reuseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 45)];
   
    reuseView.backgroundColor = [UIColor whiteColor];

    UIView *toplineView = [[UIView alloc]initWithFrame:CGRectZero];
     toplineView.backgroundColor = DEF_COLOR_ECECEC;
    [reuseView addSubview:toplineView];
    [toplineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
   
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]init];
    [attrStr appendAttributedString:[JHUtility getAttributedStringWithString:@"员工评价" font:14 textColor: DEF_COLOR_RGB(91, 91, 91)]];
    [attrStr appendAttributedString:[JHUtility getAttributedStringWithString:@"(" font:14 textColor: DEF_COLOR_RGB(144, 144, 144)]];
    [attrStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%ld",self.staffDetailModel.evaluationCount] font:14 textColor: DEF_COLOR_RGB(193, 145, 83)]];
    [attrStr appendAttributedString:[JHUtility getAttributedStringWithString:@")" font:14 textColor: DEF_COLOR_RGB(144, 144, 144)]];
    _staffEvaluateLab = [[UILabel alloc]initWithFrame:CGRectZero];
    _staffEvaluateLab.attributedText = attrStr;
    _staffEvaluateLab.font = [UIFont systemFontOfSize:14];
    [reuseView addSubview:_staffEvaluateLab];
    [_staffEvaluateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.centerY.equalTo(reuseView.mas_centerY).offset(5);
    }];
    
    UIView *bottomlineView = [[UIView alloc]initWithFrame:CGRectZero];
    bottomlineView.backgroundColor = DEF_COLOR_ECECEC;
    [reuseView addSubview:bottomlineView];
    [bottomlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    return reuseView;
}

//获取评价内容
-(void)loadData{

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:self.currentSelectShop forKey:@"restId"];
    [parmDic setValue:[NSString stringWithFormat:@"%ld",self.staffDetailModel.ID] forKey:@"staffId"];
    [parmDic setValue:[NSString stringWithFormat:@"%d",_pageNum] forKey:@"page"];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_MoreStaffEvaluate isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
      
        [self commonConfiguration];
    
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            _pageNum ++;
            if (self.refreshType == JH_RefreshType_pullDown && self.dataArr.count > 0 ) {
                
                [self.dataArr removeAllObjects];
            }
            
            
            if (isObjNotEmpty(dic[@"data"][@"list"])) {
                                
                [self.dataArr addObjectsFromArray:[JHBoss_MoreStaffEvaluateListModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"list"]]];
            }
            
        }
        
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        [self commonConfiguration];
        if (errorState == JH_HttpRequestFailState_NetworkBreak && isObjEmpty(self.dataArr)) {
            [self.tableView reloadEmptyDataSet];
            
        }
    }];

}

-(void)commonConfiguration{
    
    _loading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.loadDataView stopAnimation];
    
}


#pragma mark - Getter/Settrt
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
          [_tableView registerNib:[UINib nibWithNibName:@"JHBoss_StaffEvaluateTableViewCell" bundle:nil] forCellReuseIdentifier:@"StaffEvaluateTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setCellLineUIEdgeInsetsZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = DEF_COLOR_ECECEC;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
      
    }
    return _tableView;
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
        
        
        //        return ([self.loadDataView startAnimation], self.loadDataView);
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
    
    [self loadData];
    
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
