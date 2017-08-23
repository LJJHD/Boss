//
//  JHBoss_ManagePageViewController.m
//  Boss
//
//  Created by sftoday on 2017/4/11.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ManagePageViewController.h"
#import "JHBoss_PageViewController.h"
#import "XlSegementControl.h"
#import "JHBoss_ShopManagerViewController.h"
#import "JHBoss_StaffManagerViewController.h"
#import "JHBoss_RestaurantModel.h"
#import "JHUserInfoData.h"
#import "JHUserInfoData.h"
@interface JHBoss_ManagePageViewController ()<PageViewControllerScrollDelegate,XlSegementControlDetegate, MMComBoBoxViewDataSource, MMComBoBoxViewDelegate>

@property (nonatomic, strong) JHBoss_PageViewController *pageViewController;
@property (nonatomic, strong) XlSegementControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray<JHBoss_RestaurantModel*> *dataArr;
@property (nonatomic, strong) JHUserInfoData *userInfo;
@property (nonatomic, copy)   NSString *merchanId;

@property (nonatomic, strong) JHBoss_ShopManagerViewController *shopManagerVC;//店铺管理
@property (nonatomic, strong) JHBoss_StaffManagerViewController *staffManagerVC;//员工管理


// 筛选栏
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, strong) MMComBoBoxView *comBoBoxView;
@property (nonatomic, assign) int currentSelectShop;//当前选中的店铺
@property (nonatomic, copy)   NSString *restaurantId;
@end

@implementation JHBoss_ManagePageViewController

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:loadRestListNotifiction object:nil];

}

//获取merchanId
-(void)requestUserInfo{
    
    @weakify(self);
    
    [self.userInfo getUserInfoIdentify:saveUserIdentify result:^(NSDictionary *result) {
        @strongify(self);
        self.merchanId = result[@"merchantId"];
        [self loadAllShopList];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArr = [NSMutableArray array];
    [self requestUserInfo];
    [self.view addSubview:self.menuView];
    [self.menuView addSubview:self.comBoBoxView];
    [self.comBoBoxView reload];
    [self initNaviBar];
    [self createPageViewController];
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:loadRestListNotifiction object:nil] subscribeNext:^(id x) {
        @strongify(self);
        
        [self loadAllShopList];
        
        
    }];
}

//获取所有店铺
-(void)loadAllShopList{

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:self.merchanId forKey:@"merchantId"];
       @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_MyRestaurant isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (isObjNotEmpty(dic[@"data"])) {
                
                if (isObjNotEmpty(self.dataArr)) {
                    [self.dataArr removeAllObjects];
                }
               [self.dataArr addObjectsFromArray:[JHBoss_RestaurantModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"branchDetailRecordVo"][@"branchDetail"]]];
                //设置筛选栏
                [self makeShop];
            }
            
        }
        [self.comBoBoxView reload];
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    NSDictionary *restInfoDic =  [JHUserInfoData getCurrentSelectRestInfo];
    NSString *selectedRsetNameStr;
    NSString *selectRsetId;
    if (isObjNotEmpty(restInfoDic)) {
        
        selectedRsetNameStr = restInfoDic[@"restName"];
        selectRsetId = restInfoDic[@"restId"];
        
        MMSingleItem *rootItem = self.shopArray.firstObject;
        if ([rootItem.title isEqualToString:selectedRsetNameStr]) {
            
            return;
        }else{
            rootItem.title = selectedRsetNameStr;
            [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                JHBoss_RestaurantModel *otherShopModel = obj;
                if (otherShopModel.Id.integerValue == selectRsetId.integerValue) {
                    _currentSelectShop = (int)idx;
                }
            }];
            _shopManagerVC.currentSelectShop = self.currentSelectShop;
            _staffManagerVC.currentSelectShop = self.currentSelectShop;
            NSDictionary *dic = @{@"currentShop":[NSNumber numberWithUnsignedInteger:_currentSelectShop]};
//            //发送通知用于员工管理请求数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"currentShop" object:nil userInfo:dic];
            [self.comBoBoxView reload];
        }
    }
}

//设置店铺
-(void)makeShop{

    NSDictionary *restInfoDic =  [JHUserInfoData getCurrentSelectRestInfo];
   __block NSString *selectedRsetNameStr;
    NSString *selectRsetId;
    if (isObjNotEmpty(restInfoDic)) {
       __block BOOL isqualt = NO;
        [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            JHBoss_RestaurantModel *otherShopModel = obj;
            if ([otherShopModel.Id.stringValue isEqualToString: restInfoDic[@"restName"]]) {
                
                isqualt = YES;
                selectedRsetNameStr = restInfoDic[@"restName"];
                 _currentSelectShop = (int)idx;
            }
            
        }];
        
        if (!isqualt) {
            
            JHBoss_RestaurantModel *model = self.dataArr[0];
            selectedRsetNameStr = model.name;
            _currentSelectShop = 0;
            
            //存储当前选中的餐厅信息
            NSDictionary *restInfo = @{@"restId":model.Id.stringValue,@"restName":model.name};
            [JHUserInfoData saveCurrentSelectRestInfo:restInfo];
        }
        
    }else{
    
        JHBoss_RestaurantModel *model = self.dataArr[0];
        selectedRsetNameStr = model.name;
        _currentSelectShop = 0;
    
    }
    
    MMSingleItem *rootItem1 = [MMSingleItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:selectedRsetNameStr];
   
    for (int i = 0; i < self.dataArr.count; i++) {
        
        JHBoss_RestaurantModel *otherShopModel = self.dataArr[i];
        [rootItem1  addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:YES titleName:otherShopModel.name subtitleName:nil code:nil]];
    }

    if (isObjNotEmpty(self.shopArray)) {
        
        [self.shopArray removeAllObjects];
    }
    [_shopArray addObject:rootItem1];
    
     [self.comBoBoxView reload];
    
    _shopManagerVC.allShopArr = [self.dataArr mutableCopy];
    _shopManagerVC.currentSelectShop = self.currentSelectShop;
    
    _staffManagerVC.allShopArr = [self.dataArr mutableCopy];
    _staffManagerVC.currentSelectShop = self.currentSelectShop;
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

-(JHUserInfoData *)userInfo{
    
    if (!_userInfo) {
        _userInfo = [[JHUserInfoData alloc]init];
    }
    return _userInfo;
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
    _shopManagerVC.currentSelectShop = self.currentSelectShop;
    
    _staffManagerVC.currentSelectShop = self.currentSelectShop;
    
    NSDictionary *dic = @{@"currentShop":[NSNumber numberWithUnsignedInteger:index]};
    //发送通知用于员工管理请求数据
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentShop" object:nil userInfo:dic];
}

//懒加载餐厅数组
-(NSMutableArray *)shopArray{
    
    if (_shopArray == nil) {
        _shopArray = [NSMutableArray array];
        NSMutableArray *mutableArray = [NSMutableArray array];
        //root 1
        MMSingleItem *rootItem1 = [MMSingleItem itemWithItemType:MMPopupViewDisplayTypeUnselected titleName:@"选择餐厅"];
        [rootItem1  addNode:[MMItem itemWithItemType:MMPopupViewDisplayTypeSelected isSelected:YES titleName:@"选择餐厅" subtitleName:nil code:nil]];
        [mutableArray addObject:rootItem1];
        [_shopArray addObjectsFromArray:mutableArray];
    }
    return _shopArray;
}


// 初始化分页导航
- (void)initNaviBar
{
    UIView *naviBarView = [[UIView alloc] init];
    naviBarView.backgroundColor = DEF_COLOR_CDA265;
    [self.view addSubview:naviBarView];
    [naviBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    
    [naviBarView addSubview:[self aSegmentedControl]];
}

-(XlSegementControl*)aSegmentedControl {
    NSInteger count = self.segementTitles.count;
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        XlSegementItem* item = [XlSegementItem itemWithTitle:self.segementTitles[i] image:nil highlightedImage:nil];
        [arr addObject:item];
    }
    _segmentedControl = [[XlSegementControl alloc] initWithItems:arr];
    _segmentedControl.frame = CGRectMake((DEF_WIDTH - 200)/2, 20, 200, 44);
    _segmentedControl.tag = 9999;
    _segmentedControl.delegate = self;
    _segmentedControl.font = [UIFont systemFontOfSize:18];
    _segmentedControl.textColor =  DEF_COLOR_RGB_A(255, 255, 255, 0.51);
    _segmentedControl.selectTextColor = [UIColor whiteColor];
    _segmentedControl.lineColor = DEF_COLOR_RGB(0x96, 0x58, 0x00);
    return _segmentedControl;
}

- (NSArray *)segementTitles{
    return @[@"店铺管理",@"员工管理"];
}


#pragma mark - XlSegementControl代理方法

-(void)segmentedControl:(XlSegementControl*)segmentedControl didSelectIndex:(NSInteger)index{
    [self changeSegmentControlFrameWithIndex:index];
    
    //切换视图控制器
    [self.comBoBoxView dimissPopView];
    [self.pageViewController setCurrentViewControllerAtIndex:index animated:YES];
}
- (void)changeSegmentControlFrameWithIndex:(NSInteger)index{
    [_segmentedControl segmentIndex:index dotShow:NO];
    _segmentedControl.selectedSegmentIndex = index;
}


#pragma mark - 初始化社区首页控制器

- (void)createPageViewController{
    _pageViewController = [[JHBoss_PageViewController alloc] init];
    _pageViewController.view.frame = CGRectMake(0, 118, DEF_WIDTH, DEF_HEIGHT-54);
    _pageViewController.pageScrollEnabled = YES;
    _pageViewController.delegate = self;
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0 ; i < self.segementTitles.count ; i++){
        if (i == 0){
            _shopManagerVC = [JHBoss_ShopManagerViewController new];
           
            [array addObject:_shopManagerVC];
        }else if (i == 1){
            
           _staffManagerVC = [JHBoss_StaffManagerViewController new];
            [array addObject:_staffManagerVC];
        }
    }
    _pageViewController.viewControllers = array;
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

- (void)changePage:(NSNotification *)noti
{
    NSInteger index = [noti.userInfo[@"pageNum"] integerValue];
    if (index < self.segementTitles.count && index >= 0){
        [self segmentedControl:_segmentedControl didSelectIndex:index];
    }
}


#pragma mark - 滚动切换导航栏

- (void)pageViewController:(JHBoss_PageViewController *)pageViewController currentIndex:(NSInteger)currentIndex{
    [self changeSegmentControlFrameWithIndex:currentIndex];
}

//隐藏导航条
-(BOOL)disableAutomaticSetNavBar{
    
    return YES;
}

@end
