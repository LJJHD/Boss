//
//  JHBoss_MenuViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_MenuViewController.h"
#import "JHBoss_MenuTableViewCell.h"
#import "JHBoss_MenuHeaderView.h"
#import "JHBoss_MenuSectionModel.h"
#import "JHBoss_MenuFoodModel.h"
#import "JHBoss_DishesListModel.h"
#import "JHCRM_LoadDataView.h"
@interface JHBoss_MenuViewController ()<UITableViewDelegate,UITableViewDataSource, MMComBoBoxViewDataSource, MMComBoBoxViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sectionArr;

@property (nonatomic,strong) NSMutableArray *sectionData;

// 筛选栏
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, strong) MMComBoBoxView *comBoBoxView;


@property (nonatomic, assign) BOOL loading; //是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView;//数据加载过程中显示加载动画的view
@end

@implementation JHBoss_MenuViewController

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
     _loading = YES;
   
    [self loadData];
    [self setUI];
    
    //下拉刷新
    @weakify(self);
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        
        [self loadData];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.comBoBoxView dimissPopView];
    [super viewWillDisappear:animated];
}

-(void)setUI{
    
    self.jhtitle = @"菜单查看";
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
    
    // init menuView
    [self.view addSubview:self.menuView];
    [self.menuView addSubview:self.comBoBoxView];
    [self.comBoBoxView reload];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorColor = DEF_COLOR_LINEVIEW;
    _tableView.tableFooterView.backgroundColor = DEF_COLOR_F5F5F5;
    _tableView.rowHeight = 90;
    _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    [_tableView setCellLineUIEdgeInsetsZero];
    [self.view addSubview:_tableView];
    @weakify(self)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.comBoBoxView.mas_bottom).offset(10);
        make.left.right.and.bottom.mas_equalTo(0);
        
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_MenuTableViewCell"];
    [self.tableView registerClass:[JHBoss_MenuHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    JHBoss_MenuSectionModel *model = _sectionData[section];
     JHBoss_DishesListModel *dishesModel = self.sectionArr[section];
    return model.isExpand ? dishesModel.dishesList.count : 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

   return self.sectionArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    if (section == self.sectionData.count - 2) {
        return  15;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"JHBoss_MenuTableViewCell";
    JHBoss_MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    JHBoss_DishesListModel *dishesModel = self.sectionArr[indexPath.section];
    DishesList *dishesListModel = dishesModel.dishesList[indexPath.row];
    cell.dishesList = dishesListModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    JHBoss_MenuHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    JHBoss_MenuSectionModel *model = _sectionData[section];
    view.model = model;
    JHBoss_DishesListModel *dishesModel = self.sectionArr[section];
    view.dishesModel = dishesModel;
    //更变了section的cell数量，所以要刷新
    @weakify(self);
    view.block = ^(BOOL isExpanded){
        @strongify(self);
        self.loading = NO;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView reloadEmptyDataSet];
    };
    return view;
}


-(void)loadData{

    JHBoss_RestaurantModel *model = self.allShopArr[_currentSelectShop];
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:model.Id.stringValue forKey:@"restaurantId"];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:jh_dishesListURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        
        [self.sectionArr removeAllObjects];
        [self commonConfiguration];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (isObjNotEmpty(dic[@"data"])) {
                
                self.sectionArr = [JHBoss_DishesListModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
                [self sectionData];
            }
        }
        
        [self.tableView reloadData];
        [self.tableView reloadEmptyDataSet];
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
         [self commonConfiguration];
        if (errorState == JH_HttpRequestFailState_NetworkBreak && isObjEmpty(self.sectionArr)) {
            [self.tableView reloadEmptyDataSet];
            
        }
    }];
}

-(void)commonConfiguration{
    
    _loading = NO;
    [self.tableView.mj_header endRefreshing];
  
    [self.loadDataView stopAnimation];
    
}


//懒加载
- (NSMutableArray *)sectionData{
    if (_sectionData == nil) {
        _sectionData = [[NSMutableArray alloc]init];
        for (int i=0; i<self.sectionArr.count; i++) {
            JHBoss_MenuSectionModel *model = [[JHBoss_MenuSectionModel alloc]init];
            model.isExpand = NO;
            JHBoss_DishesListModel *dishesModel = self.sectionArr[i];
            model.cellArray = dishesModel.dishesList;
            [_sectionData addObject:model];
        }
    }
    return _sectionData;
    
}


-(NSMutableArray *)shopArray{


    if (!_shopArray) {
        
        _shopArray = [NSMutableArray array];
        
        JHBoss_RestaurantModel *model = self.allShopArr[_currentSelectShop];
        MMSingleItem *rootItem1 = [MMSingleItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:model.name];
        
        for (int i = 0; i < self.allShopArr.count ; i++) {
            
            JHBoss_RestaurantModel *otherShopModel = self.allShopArr[i];
            [rootItem1  addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:YES titleName:otherShopModel.name subtitleName:nil code:nil]];
            
        }
        
        [_shopArray addObject:rootItem1];
        
        [self.comBoBoxView reload];
        
    }
    return _shopArray;
}


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


#pragma ----DZNEmptyDataSet -------datasoure
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (_loading || self.sectionArr.count > 0) {
        return nil;
    }
    if (NETWORK_CONNECTION_STAT == NotReachable) {
        
        
        return DEF_IMAGENAME(@"0.4_icon_wangluoyichang");
    }
    return DEF_IMAGENAME(@"1.1.3.2_icon_zanwutixing");
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{

    return YES;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.loading || self.sectionArr.count > 0) {
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
