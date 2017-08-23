//
//  JHBoss_OrderSearchViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderSearchViewController.h"
#import "JH_SearchView.h"
#import "JHCRM_LoadDataView.h"
#import "JHBoss_OrderListModel.h"
#import "JHBoss_OrderManagerTableViewCell.h"
#import "JHBoss_MenuOrderDetailViewController.h"
#import "JH_SearchRearchStorage.h"
#import "JHBoss_RestaurantModel.h"
@interface JHBoss_OrderSearchViewController ()<UITableViewDelegate,UITableViewDataSource,JH_SearchViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) JH_SearchView *searchView;
@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, assign) int pageNum;//当前页码
@property (nonatomic, assign) BOOL editeStaute; //编辑状态

@property (nonatomic, assign)  JH_RefreshType refreshType;
@property (nonatomic, assign) BOOL loading; //是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView;//数据加载过程中显示加载动画的view
@property (nonatomic, strong) NSMutableArray *dataArr;//数据
@property (nonatomic, strong) NSString *searchContent;//搜索内容

@property (nonatomic, strong) JH_SearchRearchStorage *searchRearchStorage;//搜索存储
@property (nonatomic, strong) NSMutableArray *historyDataArr;//存储历史
@property (nonatomic, copy)   NSString *currentSearchStr;//当前搜索的字段

@property (nonatomic, strong) UIView *headerView;//tableHeaderView;


@end

@implementation JHBoss_OrderSearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"订单搜索"];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"订单搜索"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _loading = NO;
    _dataArr = [NSMutableArray array];
    _historyDataArr = [NSMutableArray array];
    _searchRearchStorage = [[JH_SearchRearchStorage alloc]init];
    [self getSearchHistory];
    [self setUI];
    
    //下拉刷新
    @weakify(self);
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.pageNum = 1;
        self.refreshType = JH_RefreshType_pullDown;
        [self loadData:self.searchContent];
    }];
    
    //上提加载
    [self.tableView addCustomGifFooterWithRefreshingBlock:^{
        @strongify(self);
        
        self.refreshType = JH_RefreshType_pullUp;
        [self loadData:self.searchContent];
    }];

}

-(void)setUI{

    self.view.backgroundColor = DEF_COLOR_F5F5F5;
    [self.view addSubview:self.searchView];
    @weakify(self);
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    _tableView.tableHeaderView = self.headerView;
    _tableView.emptyDataSetDelegate = self;
    _tableView.emptyDataSetSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.searchView.mas_bottom);
        make.left.right.and.bottom.mas_equalTo(0);
        
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_OrderManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_OrderManagerTableViewCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"searchHistory"];

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _editeStaute ? self.dataArr.count : self.historyDataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    float height;
    if (_editeStaute) {
        height = 161;
    }else{
        height = 42;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"JHBoss_OrderManagerTableViewCell";
    static NSString *searchHistory = @"searchHistory";
    if (_editeStaute) {
        
        JHBoss_OrderManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        JHBoss_OrderListModel *model = self.dataArr[indexPath.row];
        cell.orderListModel = model;
        
         return cell;
        
    }else{
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchHistory];
        cell.imageView.image = DEF_IMAGENAME(@"2.1.3.6");
        cell.textLabel.textColor = DEF_COLOR_RGB(110, 110, 110);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text = self.historyDataArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
    }
   
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_editeStaute) {
        
        JHBoss_OrderListModel *listModel = self.dataArr[indexPath.row];
        JHBoss_MenuOrderDetailViewController *detailVC = [[JHBoss_MenuOrderDetailViewController alloc]init];
        detailVC.orderId = [NSString stringWithFormat:@"%ld",listModel.ID];
        detailVC.currentSelectShop = [NSString stringWithFormat:@"%d",self.currentSelectShop];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else{
    
        _editeStaute = YES;
        NSString *historyStr = self.historyDataArr[indexPath.row];
        
        self.searchView.textField.text = historyStr;
        
         [self.dataArr removeAllObjects];
        [self loadData:historyStr];
    
    }
    
}

//获取搜索记录
-(void)getSearchHistory{
    
    
    @weakify(self);
    [self.searchRearchStorage getStorageValueForIdentify:commodityManagerIdentify result:^(NSMutableArray * result) {
        @strongify(self);
        
        if ([result isKindOfClass:[NSNull class]] || result.count <= 0) {
            return ;
        }
        _loading = NO;
        self.historyDataArr  = [result mutableCopy];
        
        [self.tableView reloadData];
    }];
    
}

//存储搜索关键字
-(void)saveHistoryRecord:(NSString *)record{

    [self.historyDataArr addObject:record];
    [self.searchRearchStorage setStorageValue:self.historyDataArr forIdentify:commodityManagerIdentify maxNumStorage:10];
}


/**
 *  取消按钮点击回调
 */
- (void)jh_SearchViewCancelButtonClick:(JH_SearchView *)searchView{

    [self.navigationController popViewControllerAnimated:YES];
}


/**
 *  键盘return按钮点击回调
 */
- (void)jh_SearchViewShouldReturn:(UITextField *)textField{

   
    if (textField.text.length > 0) {
        _pageNum = 1;
        _loading = NO;
        _currentSearchStr = textField.text;
        [self.dataArr removeAllObjects];
        [self saveHistoryRecord:textField.text];
        [self.loadDataView startAnimation];
        [self loadData:textField.text];
    }


}

/**
 *  TextField内容改变
 */
- (void)jh_SearchViewTextFieldTextChange:(UITextField *)textField text:(NSString *)text{

    if (text.length <= 0) {
        self.tableView.tableHeaderView = self.headerView;
        [self.dataArr removeAllObjects];
      
        _editeStaute = NO;
        [self.tableView reloadData];
    }else{
    
        _editeStaute = YES;
    }

}


//获取订单列表
-(void)loadData:(NSString *)searchContent{
    
    if (!_editeStaute) {
        //处于非编辑状态 不能进行网络请求
        [self commonConfiguration];
        return;
    }
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:[NSString stringWithFormat:@"%d",self.currentSelectShop] forKey:@"restId"];
    [parmDic setValue:[NSString stringWithFormat:@"%d",_pageNum] forKey:@"pageIndex"];
    [parmDic setValue:searchContent forKey:@"searchContent"];

    if (!_loading && self.refreshType != JH_RefreshType_pullDown) {
        [JHUtility showGifProgressViewInView:self.view];
    }
   
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:jh_orderListURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
         [JHUtility hiddenGifProgressViewInView:self.view];
        NSDictionary *dic = object;
        [self commonConfiguration];
         self.tableView.tableHeaderView = nil;
        
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (self.refreshType == JH_RefreshType_pullDown && self.dataArr.count > 0 ) {
                [self.dataArr removeAllObjects];
            }
            
            if (isObjNotEmpty(dic[@"data"])) {
                
            [self.dataArr addObjectsFromArray:[JHBoss_OrderListModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
                
            }else{
            
            
//                [self.tableView reloadEmptyDataSet];
            }
        }
        
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        [self commonConfiguration];
         [JHUtility hiddenGifProgressViewInView:self.view];
    }];
}

-(void)commonConfiguration{
    
    _loading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.loadDataView stopAnimation];
    
}




-(JH_SearchView *)searchView{

    if (!_searchView) {
        _searchView = [[JH_SearchView alloc]initWithSearchViewType:JH_SearchViewType_Navigation];
        _searchView.delegate = self;
        [_searchView.textField becomeFirstResponder];
    }
    return _searchView;
}

-(UIView *)headerView{

    if (!_headerView) {
        
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 44)];
        _headerView.backgroundColor = DEF_COLOR_RGB(244, 244, 244);
        UILabel *warnLab = [[UILabel alloc]initWithFrame:CGRectZero];
        warnLab.textColor = DEF_COLOR_RGB(161, 161, 161);
        warnLab.font = DEF_SET_FONT(16);
        warnLab.text = @"搜索历史";
        [_headerView addSubview:warnLab];
        @weakify(self);
        [warnLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(20);
            make.centerY.equalTo(_headerView.mas_centerY);
            
        }];
        
        
    }

    return _headerView;
}



#pragma ----DZNEmptyDataSet -------datasoure
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (_loading ) {
        return nil;
    }
    if (NETWORK_CONNECTION_STAT == NotReachable) {
        
        
        return DEF_IMAGENAME(@"0.4_icon_wangluoyichang");
    }
    return DEF_IMAGENAME(@"1.1.3.2_icon_zanwutixing");
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.loading ) {
        return nil;
    }
    
    NSString *text = @"未搜索到相应订单\n请确认输入的搜索信息是否正确";
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



-(BOOL)disableAutomaticSetNavBar{

    return YES;
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
