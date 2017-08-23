//
//  JHBoss_tableManagerViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_tableManagerViewController.h"
#import "JHBoss_StaffMngHeadReusableView.h"
#import "JHBoss_TableMangerCollectionViewCell.h"
#import "JHBoss_ApproveHeaderView.h"
#import "JHBoss_TableListModel.h"
#import "JHBoss_tableTypeListModel.h"
#import "JHCRM_LoadDataView.h"
@interface JHBoss_tableManagerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,JHBoss_ApproveHeaderViewDelegate,MMComBoBoxViewDataSource, MMComBoBoxViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *sectionArr;//部门数组
@property (nonatomic,strong) NSMutableArray *sectionData;

@property (nonatomic, strong) NSMutableArray *sectionStauteArr;//部门状态
@property (nonatomic, strong) NSIndexPath *tapIndexPath;//当前点击的section
@property (nonatomic, strong) NSMutableArray *dataArr;//数据
@property (nonatomic, strong) JHBoss_ApproveHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *tableTypeListArr;//餐桌类型数据
@property (nonatomic, strong) NSString *currentTableType;//当前桌台类型

// 筛选栏
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSMutableArray *shopArray;
@property (nonatomic, strong) MMComBoBoxView *comBoBoxView;

@property (nonatomic, assign) BOOL loading; //是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView;//数据加载过程中显示加载动画的view
@end

@implementation JHBoss_tableManagerViewController

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
    [self loadTableTypeList];
    [self setUI];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.comBoBoxView dimissPopView];
    [super viewWillDisappear:animated];
}

-(void)setUI{
    
    self.jhtitle = @"桌台管理";
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
     @weakify(self);
    
    // init menuView
    [self.view addSubview:self.menuView];
    [self.menuView addSubview:self.comBoBoxView];
    [self.comBoBoxView reload];
    
    _headerView = [[JHBoss_ApproveHeaderView alloc]initWithFrame:CGRectZero];
    _headerView.delegate = self;
   
    _headerView.leftSpace = 20;
    _headerView.rightSpace = 20;
    _headerView.isShowBottonLine = NO;
    _headerView.itemFont = 14;
    _headerView.itemColor = DEF_COLOR_A1A1A1;
    _headerView.selectItemColor = DEF_COLOR_B48645;
    _headerView.ViewBackgroundColor = DEF_COLOR_F5F5F5;
    _headerView.ItemBackgroundColor = [UIColor clearColor];
   
    [self.view addSubview:_headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.and.right.mas_equalTo(0);
            make.top.equalTo(self.menuView.mas_bottom);
            make.height.mas_equalTo(44);
        }];

        
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((DEF_WIDTH-35)/4, 104);
    flowLayout.headerReferenceSize = CGSizeMake(DEF_WIDTH, 50);
    flowLayout.footerReferenceSize = CGSizeMake(DEF_WIDTH, 0);
    flowLayout.minimumLineSpacing = 0 ;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"JHBoss_TableMangerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JHBoss_TableMangerCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"JHBoss_StaffMngHeadReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JHBoss_StaffMngHeadReusableView"];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
   
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        
    }];
    
}

#pragma mark -- collectionview delegate OR dataSoure ------
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.sectionData.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    JHBoss_TableListModel *listModel = self.dataArr[section];
   
    
    JHBoss_tableMangSectionHeaderModel *model = self.sectionData[section];
    return model.isExpand ? listModel.tableModels.count : 0;
    
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"JHBoss_TableMangerCollectionViewCell";
    JHBoss_TableMangerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    
    JHBoss_TableListModel *listModel = self.dataArr[indexPath.section];
    TableModels *tableModel = listModel.tableModels[indexPath.row];
    cell.tableModels = tableModel;
    return cell;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    JHBoss_tableMangSectionHeaderModel *model = self.sectionData[section];
    return model.isExpand ? UIEdgeInsetsMake(0, 17.5, 0, 17.5) : UIEdgeInsetsMake(0, 17.5, 0, 17.5);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        static NSString *reuse = @"JHBoss_StaffMngHeadReusableView";
       JHBoss_StaffMngHeadReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuse forIndexPath:indexPath];
        headView.model = self.sectionData[indexPath.section];
        
        @weakify(self);
        headView.block = ^(BOOL isExpand) {
            @strongify(self);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                
                [self.collectionView reloadSections:[[NSIndexSet alloc]initWithIndex:indexPath.section]];
            });
        };
        
        return headView;
        
    }
    
    return nil;
}


#pragma mark - JHBoss_ApproveHeaderView delegate

- (void)didSelectMenuBtn:(MenuButton *)menuButton
{
    int index = (int)menuButton.index;
    NSString *tableType;
    if (index == 0) {
        
        tableType = @"";
    }else{
    
        JHBoss_tableTypeListModel *model = self.tableTypeListArr[index - 1];
        tableType = [NSString stringWithFormat:@"%ld",model.ID];
    }
    
        _currentTableType = tableType;
        [self loadData:tableType];
}


//获取桌台列表
-(void)loadData:(NSString *)tableType{
     JHBoss_RestaurantModel *model = self.allShopArr[_currentSelectShop];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:model.Id.stringValue forKey:@"restId"];
    [parmDic setValue:tableType forKey:@"typeId"];
    
    if (!_loading) {
        
     [JHUtility showGifProgressViewInView:self.view];
    }
  
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_tableListURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        [JHUtility hiddenGifProgressViewInView:self.view];
        [self commonConfiguration];
        NSDictionary *dic = object;
        
        [self.dataArr removeAllObjects];
        [self.sectionData removeAllObjects];
        
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (isObjNotEmpty(dic[@"data"])) {
                
                self.dataArr = [JHBoss_TableListModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
                
                for (JHBoss_TableListModel *ListModel in self.dataArr) {
                    
                    JHBoss_tableMangSectionHeaderModel *mode = [[JHBoss_tableMangSectionHeaderModel alloc]init];
                    mode.isExpand = NO;
                    mode.title = DEF_OBJECT_TO_STIRNG(ListModel.name);
                    mode.sectionStaffNum = (int)ListModel.count;
//                    mode.cellArray = ListModel.tableModels;
                    
                    [self.sectionData addObject:mode];
                }
                
            }
            
        }
        
        [self.collectionView reloadData];
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        
        [self commonConfiguration];
        
        if (errorState == JH_HttpRequestFailState_NetworkBreak && isObjEmpty(self.dataArr)) {
            [self.collectionView reloadEmptyDataSet];
            
        }
        [JHUtility hiddenGifProgressViewInView:self.view];
    }];

}

//获取桌台类型列表
-(void)loadTableTypeList{

    JHBoss_RestaurantModel *model = self.allShopArr[_currentSelectShop];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:model.Id.stringValue forKey:@"restId"];
   
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_tableTypeListURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        
        NSDictionary *dic = object;
//         [self commonConfiguration];
        
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (isObjNotEmpty(dic[@"data"])) {
                
                self.tableTypeListArr = [JHBoss_tableTypeListModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
                
                NSMutableArray *itemArray= [NSMutableArray array];
                [itemArray addObject:@"全部"];
                for (NSDictionary *contentDic in dic[@"data"]) {
                    
                    [itemArray addObject:contentDic[@"title"]];
                }
                
                 self.headerView.itemArray = itemArray;
                 [self.headerView showApproveHeaderView];
                //获取桌台类型
//                JHBoss_AllShopListModel *model = self.tableTypeListArr[0];
//                _currentTableType = [NSString stringWithFormat:@"%ld",model.ID];
//                 [self loadData:[NSString stringWithFormat:@"%ld",model.ID]];
            }
        }
        
        [self.collectionView reloadData];
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        
        [self commonConfiguration];
        if (errorState == JH_HttpRequestFailState_NetworkBreak && isObjEmpty(self.dataArr)) {
            [self.collectionView reloadEmptyDataSet];
            
        }
    }];
}

-(void)commonConfiguration{
    
    _loading = NO;
    
    [self.loadDataView stopAnimation];
}


//懒加载
- (NSMutableArray *)sectionData{
    if (_sectionData == nil) {
        _sectionData = [[NSMutableArray alloc]init];

    }
    return _sectionData;
    
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
    [self loadData:_currentTableType];
    //    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:currentShopIdentify];
}



#pragma ----DZNEmptyDataSet -------datasoure
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (_loading || self.sectionData.count > 0) {
        
        return nil;
    }
    if (NETWORK_CONNECTION_STAT == NotReachable) {
        
        
        return DEF_IMAGENAME(@"0.4_icon_wangluoyichang");
    }
    return DEF_IMAGENAME(@"1.1.3.2_icon_zanwutixing");
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.loading || self.sectionData.count > 0) {
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
    
    
    if (_loading && self.sectionData.count <= 0) {
        
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


/**
 *  数据源为空时是否渲染和显示 (默认为 YES)
 */
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    if (self.sectionData.count > 0) {
        
        return NO;
    }
    
    return YES;
}

#pragma ----DZNEmptyDataSet -------dataDelegate
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    
    //  从新进行网络请求
    _loading = YES;
    
    //请求没有网络数据时调用，展示空页面
    [self.collectionView reloadEmptyDataSet];
    
    [self.loadDataView startAnimation];
    
    [self loadData:_currentTableType];
    
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
