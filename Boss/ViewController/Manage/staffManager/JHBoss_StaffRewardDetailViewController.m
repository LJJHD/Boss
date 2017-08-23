//
//  JHBoss_StaffRewardDetailViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffRewardDetailViewController.h"
#import "JHBoss_StaffRewardDetailTableViewCell.h"
#import "JHBoss_StaffRewardDetailHeaderView.h"
#import "JHBoss_StaffGratuityListModel.h"
#import "JHCRM_LoadDataView.h"
@interface JHBoss_StaffRewardDetailViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) JHBoss_StaffRewardDetailHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) JHBoss_StaffGratuityListModel *staffGratuityModel;

@property (nonatomic, assign) int pageNum;//当前页码
@property (nonatomic, assign)  JH_RefreshType refreshType;
@property (nonatomic, assign) BOOL loading; //是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView;//数据加载过程中显示加载动画的view

@end

@implementation JHBoss_StaffRewardDetailViewController

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
    _loading = YES;
     self.pageNum = 1;
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
    
    self.jhtitle = @"收到打赏";
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
    
    [self.view addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
        make.height.mas_equalTo(80);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_StaffRewardDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_StaffRewardDetailTableViewCell"];
    _tableView.rowHeight = 50;
    _tableView.tableHeaderView.backgroundColor = DEF_COLOR_ECECEC;
    _tableView.separatorColor = DEF_COLOR_ECECEC;
    _tableView.tableFooterView = [UIView new];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.headerView.mas_bottom);
        make.trailing.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

//加载数据
-(void)loadData{

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:self.restId forKey:@"restId"];
    [parmDic setValue:[NSString stringWithFormat:@"%ld",self.staffDetailModel.ID] forKey:@"staffId"];
    [parmDic setValue:[NSString stringWithFormat:@"%d",_pageNum] forKey:@"pageIndex"];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_StaffGratutyListURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        [self commonConfiguration];
         NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
             self.pageNum ++;
            
            if (isObjNotEmpty(dic[@"data"])) {
                
                if (self.refreshType == JH_RefreshType_pullDown && self.dataArr.count > 0 ) {
                    
                    [self.dataArr removeAllObjects];
                }
                
                _staffGratuityModel = [JHBoss_StaffGratuityListModel mj_objectWithKeyValues:dic[@"data"]];
                self.headerView.StaffGratuityListModel = self.staffGratuityModel;
            }
        
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        
         [self commonConfiguration];
    }];

}


-(void)commonConfiguration{
    
    _loading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.loadDataView stopAnimation];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return self.staffGratuityModel.rewardContentModels.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"JHBoss_StaffRewardDetailTableViewCell";
    JHBoss_StaffRewardDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];

    GratuityList *model = self.staffGratuityModel.rewardContentModels[indexPath.row];
    cell.gratuityListModel = model;
    return  cell;
}


#pragma mark - Getter/Settrt
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setCellLineUIEdgeInsetsZero];
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}

-(JHBoss_StaffRewardDetailHeaderView *)headerView{

    if (!_headerView) {
        _headerView = [[JHBoss_StaffRewardDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 80)];
    
    }

    return _headerView;
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
