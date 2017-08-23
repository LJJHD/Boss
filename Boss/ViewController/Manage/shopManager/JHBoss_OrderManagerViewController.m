//
//  JHBoss_OrderManagerViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderManagerViewController.h"
#import "JHBoss_OrderManagerTableViewCell.h"
#import "JHBoss_tableHeaderSearchView.h"
#import "JHBoss_MenuOrderDetailViewController.h"
#import "JHCRM_LoadDataView.h"
#import "JHBoss_OrderListModel.h"
#import "JHBoss_OrderSearchViewController.h"
@interface JHBoss_OrderManagerViewController ()<UITableViewDelegate,UITableViewDataSource, MMComBoBoxViewDataSource, MMComBoBoxViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHBoss_tableHeaderSearchView *searchView;

// 筛选栏
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, strong) MMComBoBoxView *comBoBoxView;


@property (nonatomic, assign) int pageNum;//当前页码
@property (nonatomic, assign)  JH_RefreshType refreshType;
@property (nonatomic, assign) BOOL loading; //是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView;//数据加载过程中显示加载动画的view
@property (nonatomic, strong) NSMutableArray *dataArr;//数据
@end

@implementation JHBoss_OrderManagerViewController

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
    _pageNum = 1;
    _dataArr = [NSMutableArray array];
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

- (void)viewWillDisappear:(BOOL)animated {
    [self.comBoBoxView dimissPopView];
    [super viewWillDisappear:animated];
}

-(void)setUI{
    
    self.jhtitle = @"订单管理";
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
    
    // init menuView
    [self.view addSubview:self.menuView];
    [self.menuView addSubview:self.comBoBoxView];
    [self.comBoBoxView reload];
    
    @weakify(self)
    self.searchView = [[JHBoss_tableHeaderSearchView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.searchView];
    self.searchView.tapBlock = ^{
        @strongify(self);
          JHBoss_RestaurantModel *model = self.allShopArr[self.currentSelectShop];
        JHBoss_OrderSearchViewController *orderSearchVC = [[JHBoss_OrderSearchViewController alloc]init];
        orderSearchVC.currentSelectShop = model.Id.intValue;
        [self.navigationController pushViewController:orderSearchVC animated:YES];
        
    };
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.menuView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView.backgroundColor = DEF_COLOR_F5F5F5;
    _tableView.rowHeight = 161;
    _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    [_tableView setCellLineUIEdgeInsetsZero];
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.searchView.mas_bottom);
        make.left.right.and.bottom.mas_equalTo(0);
        
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_OrderManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_OrderManagerTableViewCell"];
//    [self.tableView registerClass:[JHBoss_MenuHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"JHBoss_OrderManagerTableViewCell";
    JHBoss_OrderManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JHBoss_OrderListModel *model = self.dataArr[indexPath.row];
    
    cell.orderListModel = model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHBoss_RestaurantModel *model = self.allShopArr[_currentSelectShop];
    JHBoss_OrderListModel *listModel = self.dataArr[indexPath.row];
    
    JHBoss_MenuOrderDetailViewController *detailVC = [[JHBoss_MenuOrderDetailViewController alloc]init];
    detailVC.orderId = [NSString stringWithFormat:@"%ld",listModel.ID];
    detailVC.currentSelectShop = model.Id.stringValue;
    [self.navigationController pushViewController:detailVC animated:YES];

}


-(NSMutableArray *)shopArray{
    
    
    if (!_shopArray) {
        
        _shopArray = [NSMutableArray array];
        
        JHBoss_RestaurantModel *model = self.allShopArr[_currentSelectShop];
        MMSingleItem *rootItem1 = [MMSingleItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:model.name];
        
        for (int i = 0; i < self.allShopArr.count ; i++) {
            
//            if (i == _currentSelectShop) {
//                
//                continue;
//            }
            
            JHBoss_RestaurantModel *otherShopModel = self.allShopArr[i];
            [rootItem1  addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:YES titleName:otherShopModel.name subtitleName:nil code:nil]];
            
        }
        
        [_shopArray addObject:rootItem1];
        
        [self.comBoBoxView reload];
        
    }
    return _shopArray;}


- (UIView *)menuView
{
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, DEF_WIDTH, 44)];
        _menuView.backgroundColor = [UIColor whiteColor];
    }
    return _menuView;
}

- (MMComBoBoxView *)comBoBoxView
{
    if (!_comBoBoxView) {
        _comBoBoxView = [[MMComBoBoxView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 44)];
        _comBoBoxView.dataSource = self;
        _comBoBoxView.delegate = self;
    }
    return _comBoBoxView;
}

#pragma mark - MMComBoBoxViewDataSource

- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView {
    return self.shopArray.count;
}

- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column {
    return self.shopArray[column];
}


#pragma mark - MMComBoBoxViewdelegate ---
- (void)comBoBoxView:(MMComBoBoxView *)comBoBoxViewd didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index{
    
    _currentSelectShop = (int)index;
    [self loadData];
    //    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:currentShopIdentify];
}

//获取订单列表
-(void)loadData{
    
    JHBoss_RestaurantModel *model = self.allShopArr[_currentSelectShop];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:model.Id.stringValue forKey:@"restId"];
    [parmDic setValue:@"0" forKey:@"requestType"];

    [parmDic setValue:[NSString stringWithFormat:@"%d",_pageNum] forKey:@"pageIndex"];
    @weakify(self);
    
    [JHHttpRequest postRequestWithParams:parmDic path:jh_orderListURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        [self commonConfiguration];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            _pageNum ++;
            if (self.refreshType == JH_RefreshType_pullDown && self.dataArr.count > 0 ) {
                
                [self.dataArr removeAllObjects];
            }
            
            if (isObjNotEmpty(dic[@"data"])) {
                
                [self.dataArr addObjectsFromArray:[JHBoss_OrderListModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
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
    
    if (self.loading ) {
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
    _pageNum = 1;
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
