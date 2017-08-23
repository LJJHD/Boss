//
//  JHBoss_StaffManagerViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/4/28.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffManagerViewController.h"
#import "JHBoss_StaffManagerCollectionViewCell.h"
#import "JHBoss_StaffMngHeadReusableView.h"
#import "LXReorderableCollectionViewFlowLayout.h"
#import "JHBoss_staffDetailViewController.h"
#import "JHBoss_SectionManagerViewController.h"
#import "JHBoss_StaffInviteViewController.h"
#import "JHBoss_StaffListModel.h"
#import "JHBoss_ClassifyManagerViewController.h"
#import "JHBoss_RestaurantModel.h"
#import "JHCRM_LoadDataView.h"
#import "JHBoss_StaffRangkingTopFiveViewController.h"
@interface JHBoss_StaffManagerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,LXReorderableCollectionViewDataSource, LXReorderableCollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *sectionData;//部门数组
@property (nonatomic, strong) NSIndexPath *tapIndexPath;//当前点击的section
@property (nonatomic, strong) NSMutableArray *dataArr;//数据
@property (nonatomic, strong) JHBoss_StaffMngHeadReusableView *headView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic, strong) UIButton *addBtn;//右下角加号
@property (nonatomic, strong) UIView *marskingView;//点击button 后的蒙版
@property (nonatomic, strong) UIButton *staffInviteBtn;//员工招聘按钮
@property (nonatomic, strong) UILabel *staffLab;
@property (nonatomic, strong) UIButton *managerBtn;//员工招聘按钮
@property (nonatomic, strong) UILabel *manageLab;
@property (nonatomic, strong) UIButton *staffRankingBtn;//员工排行

@property (nonatomic, strong) NSIndexPath *fromIndexPath;//记录移动之前的位置
@property (nonatomic, strong) NSIndexPath *toIndexPath;//记录移动之后的位置

@property (nonatomic, assign) BOOL loading; //是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView;//数据加载过程中显示加载动画的view
@end

@implementation JHBoss_StaffManagerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"员工管理"];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"员工管理"];
}


-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"currentShop" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSection:) name:@"currentShop" object:nil];
    
    _loading = YES;
    self.dataArr = [NSMutableArray array];
    self.sectionData = [NSMutableArray array];
    //这个版本暂时不要
//    [self gainStaffInviitePermissions];
    [self gainSection];
    [self setUI];
    
}

-(void)setUI{
    
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
    LXReorderableCollectionViewFlowLayout *flowLayout = [[LXReorderableCollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((DEF_WIDTH-35)/5, 78);
    flowLayout.headerReferenceSize = CGSizeMake(DEF_WIDTH, 50);
    flowLayout.footerReferenceSize = CGSizeMake(DEF_WIDTH, 0);
    flowLayout.minimumLineSpacing = 10 ;
    flowLayout.minimumInteritemSpacing = 13;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = DEF_COLOR_F5F5F5;
    [self.view addSubview:self.collectionView];
    
    @weakify(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-60);
        make.left.right.mas_equalTo(0);
        
    }];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setimage:@"2.2_icon_vip_default"];
    [_addBtn addTarget:self action:@selector(addMore:) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.hidden = NO;
    [self.view addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.width.mas_equalTo(63.5);
        make.right.mas_equalTo(-35);
        make.bottom.mas_equalTo(-86);
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"JHBoss_StaffManagerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"JHBoss_StaffManagerCollectionViewCell"];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"JHBoss_StaffMngHeadReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JHBoss_StaffMngHeadReusableView"];
    
    [self.collectionView  addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        [self gainSection];
        
    }];
}


//获取餐厅所有员工
-(void)gainSection{

    JHBoss_RestaurantModel *model = self.allShopArr[_currentSelectShop];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:model.Id.stringValue forKey:@"restaurantId"];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_StaffManagerSectionURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
         [self commonConfiguration];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (self.dataArr.count > 0) {
                
                [self.dataArr removeAllObjects];
                [self.sectionData removeAllObjects];
            }
        
            if (isObjNotEmpty(dic[@"data"])) {
                
                self.dataArr = [JHBoss_StaffListModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
               
                for (JHBoss_StaffListModel *StaffListModel  in self.dataArr) {
                    
                JHBoss_tableMangSectionHeaderModel *HeaderModel = [[JHBoss_tableMangSectionHeaderModel alloc]init];
                HeaderModel.isExpand = NO;
                HeaderModel.title = StaffListModel.name;
                HeaderModel.sectionStaffNum = (int)StaffListModel.staffList.count;
                [self.sectionData addObject:HeaderModel];
                
                    //添加占位数据
                    if (isObjEmpty(StaffListModel.staffList)) {
                        
                        StaffList *staffList = [StaffList new];
                        staffList.name = @"jinhang_zhanwei";
                        staffList.ID = 999999;
                        StaffListModel.staffList = [NSMutableArray array];
                        
                        [StaffListModel.staffList addObject:staffList];
                       
                    }
                    
                }
                
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
    [self.collectionView.mj_header endRefreshing];
    [self.loadDataView stopAnimation];
}

//请求后台是否显示员工招聘按钮
- (void)gainStaffInviitePermissions{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_isShowStaffInvidteURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (isObjNotEmpty(dic[@"data"])) {
            
                BOOL isShow = dic[@"data"][@"state"];
                
                self.addBtn.hidden = NO;

            }
            
        }
        
        [self.collectionView reloadData];
        
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        
    }];
}

-(void)loadSection:(NSNotification *)notification{

    NSDictionary *dic = notification.userInfo;
    
    NSNumber *currShop = dic[@"currentShop"];
    _currentSelectShop = (int)[currShop unsignedIntegerValue];

    [self.collectionView.mj_header beginRefreshing];
}

//员工招聘
-(void)staffInviteHandler:(UIButton *)sender{

    [self hideMarkingView];
    
    JHBoss_RestaurantModel *model = self.allShopArr[_currentSelectShop];
    JHBoss_StaffInviteViewController *staffInviteVC = [[JHBoss_StaffInviteViewController alloc]init];
    staffInviteVC.shopid = model.Id.stringValue;
    [self.navigationController pushViewController:staffInviteVC animated:YES];
}

-(void)sectionManagerHandler:(UIButton *)sender{
    
    [self hideMarkingView];
    JHBoss_ClassifyManagerViewController *classMVC = [[JHBoss_ClassifyManagerViewController alloc]init];
    JHBoss_RestaurantModel *model = self.allShopArr[_currentSelectShop];
    classMVC.currentShop = model.Id.stringValue;
    @weakify(self);
    classMVC.modificationSectionBlock = ^{
        @strongify(self);
        [self gainSection];
    };
    [self.navigationController pushViewController:classMVC animated:YES];
}


-(void)addMore:(UIButton *)sender{
    
    UIView *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.marskingView];
}


#pragma mark -- collectionview delegate OR dataSoure ------
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return self.sectionData.count;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

     JHBoss_tableMangSectionHeaderModel *model = self.sectionData[section];
    
    JHBoss_StaffListModel *ListModel = self.dataArr[section];
   
    return model.isExpand ? ListModel.staffList.count  : 0;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"JHBoss_StaffManagerCollectionViewCell";
    JHBoss_StaffManagerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    JHBoss_StaffListModel *model = self.dataArr[indexPath.section];
    StaffList *stafflistModel = model.staffList[indexPath.row];
    cell.model = stafflistModel;

    if ([stafflistModel.name isEqual:@"jinhang_zhanwei"] && stafflistModel.ID == 999999) {
        
        cell.hidden = YES;
    }else{
    
        cell.hidden = NO;
    }
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    JHBoss_tableMangSectionHeaderModel *model = self.sectionData[section];
    JHBoss_StaffListModel *StaffListModel = self.dataArr[section];
    //
    return model.isExpand && StaffListModel.staffList.count > 0 ? UIEdgeInsetsMake(15, 17.5, 13, 17.5) : UIEdgeInsetsMake(0, 17.5, 0, 17.5);
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



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    JHBoss_staffDetailViewController *staffDetailVC = [[JHBoss_staffDetailViewController alloc]init];
    JHBoss_StaffListModel *listModel = self.dataArr[indexPath.section];
    StaffList *StaffModel = listModel.staffList[indexPath.row];
    staffDetailVC.staffInfo = StaffModel;
    staffDetailVC.sectionName = listModel.name;
    staffDetailVC.sectionId = listModel.ID;
     JHBoss_RestaurantModel *model = self.allShopArr[_currentSelectShop];
    staffDetailVC.currentSelectShop = model.Id.stringValue;
    @weakify(self);
    staffDetailVC.updateStaffListBlock = ^{
        @strongify(self);
        [self gainSection];
        
    };
    
    [self.navigationController pushViewController:staffDetailVC animated:YES];
}



#pragma mark - LXReorderableCollectionViewDataSource methods

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath {
   
        _fromIndexPath = fromIndexPath;
        _toIndexPath = toIndexPath;
    
        JHBoss_StaffListModel *fromModel = self.dataArr[fromIndexPath.section];
        StaffList *FromodelStafflistModel = fromModel.staffList[fromIndexPath.row];
    
        JHBoss_StaffListModel *toModel = self.dataArr[toIndexPath.section];

        [fromModel.staffList removeObjectAtIndex:fromIndexPath.row];

        [toModel.staffList insertObject:FromodelStafflistModel atIndex:toIndexPath.row];
    
    if (fromIndexPath.section == toIndexPath.section) {
        //员工排序
//        if (fromIndexPath.row != toIndexPath.row) {
//            
//            [self staffSort];
//        }
        
    }else{
    
         [self modificationStaffSectionitemAtIndexPath:fromModel fromIndexPath:fromIndexPath willMoveToIndexPath:toModel toIndexPath:toIndexPath];
    }
    
}


- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
     JHBoss_StaffListModel *StaffListModel = self.dataArr[indexPath.section];
    
    if (StaffListModel.staffList.count == 1) {
        
        StaffList *listModel = StaffListModel.staffList[indexPath.row];
        
        if ([listModel.name isEqualToString:@"jinhang_zhanwei"] && listModel.ID == 999999) {
            
            return NO;
        }
        
    }
    
    return YES;
}


- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath {
    if (fromIndexPath.section == toIndexPath.section) {
        
        return NO;
    }
    return YES;
}


//修改分组
-(void)modificationStaffSectionitemAtIndexPath:(JHBoss_StaffListModel *)fromModel fromIndexPath:(NSIndexPath *)fromIndexPath  willMoveToIndexPath:(JHBoss_StaffListModel *)toModel toIndexPath:(NSIndexPath *)toIndexPath{
    
     JHBoss_RestaurantModel *AllShopListModel = self.allShopArr[_currentSelectShop];
    StaffList *staffModel = toModel.staffList[toIndexPath.row];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:AllShopListModel.Id.stringValue forKey:@"restId"];
    [parmDic setValue:[NSString stringWithFormat:@"%ld",(long)staffModel.ID] forKey:@"staffId"];
    [parmDic setValue:toModel.ID forKey:@"newGroupId"];
    [parmDic setValue:fromModel.ID forKey:@"oldGroupId"];
    [JHUtility showGifProgressViewInView:self.view];
   
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_ModifyStaffSectionURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        [JHUtility hiddenGifProgressViewInView:self.view];
        NSDictionary *dic = object;
        [JHUtility showToastWithMessage:dic[@"showMsg"]];
        
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
//            JHBoss_StaffListModel *toModel = self.dataArr[_fromIndexPath.section];
            
                if (fromModel.staffList.count <= 0) {
            
                    StaffList *staffList = [StaffList new];
                    staffList.name = @"jinhang_zhanwei";
                    staffList.ID = 999999;
                    [fromModel.staffList addObject:staffList];
                    
                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:_fromIndexPath.section]];
                }
            
            //toModel.staffList 被移空后再往里面添加员工。删除占位数据
            if (toModel.staffList.count >= 1) {
                
                StaffList *stListMd = toModel.staffList.lastObject;
                
                if ([stListMd.name isEqualToString:@"jinhang_zhanwei"] && stListMd.ID == 999999) {
                    
                    [toModel.staffList removeLastObject];
                      [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:_toIndexPath.section]];
                }
                
            }
            
            //修改区头的数字
            JHBoss_tableMangSectionHeaderModel *fModel = self.sectionData[_fromIndexPath.section];
            fModel.sectionStaffNum = fModel.sectionStaffNum - 1;

            JHBoss_tableMangSectionHeaderModel *tModel = self.sectionData[_toIndexPath.section];
            tModel.sectionStaffNum = tModel.sectionStaffNum + 1;
            
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:_fromIndexPath.section]];
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:_toIndexPath.section]];
           
        }else{
        
         [self modifyStaffSectionfail];
        }
        
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];
         [JHUtility showToastWithMessage:@"修改部门失败"];
        [self modifyStaffSectionfail];
    }];
}

//修改员工部门失败
-(void)modifyStaffSectionfail{

    @weakify(self);
    
    JHBoss_StaffListModel *fromModel = self.dataArr[_toIndexPath.section];
    StaffList *FromodelStafflistModel = fromModel.staffList[_toIndexPath.row];
    
    JHBoss_StaffListModel *toModel = self.dataArr[_fromIndexPath.section];
    [fromModel.staffList removeObjectAtIndex:_toIndexPath.row];
    
    [toModel.staffList insertObject:FromodelStafflistModel atIndex:_fromIndexPath.row];

    //取消移动
    [self.collectionView performBatchUpdates:^{
        
        [self.collectionView moveItemAtIndexPath:_toIndexPath toIndexPath:_fromIndexPath];
    } completion:^(BOOL finished) {
        
    }];
   
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:_fromIndexPath.section]];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:_toIndexPath.section]];
    });

   
//    [self.collectionView reloadData];

}




//员工排序
-(void)staffSort{

    
    JHBoss_StaffListModel *toModel = self.dataArr[_toIndexPath.section];
    StaffList *staffModel = toModel.staffList[_toIndexPath.row];
    NSMutableArray *sectionStaffIds = [NSMutableArray array];
    
    [toModel.staffList enumerateObjectsUsingBlock:^(StaffList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        StaffList *staffModel = obj;
        [sectionStaffIds addObject:[NSString stringWithFormat:@"%ld",staffModel.ID]];
        
    }];
   
    
    JHBoss_RestaurantModel *AllShopListModel = self.allShopArr[_currentSelectShop];
   
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:AllShopListModel.Id.stringValue forKey:@"restId"];
    [parmDic setValue:[NSString stringWithFormat:@"%ld",(long)staffModel.ID] forKey:@"staffId"];
    [parmDic setValue:toModel.ID forKey:@"sectionId"];
    [parmDic setValue:sectionStaffIds forKey:@"sectionStaffIds"];
    [JHUtility showGifProgressViewInView:self.view];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_restStaffSortURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        [JHUtility hiddenGifProgressViewInView:self.view];
        NSDictionary *dic = object;
        [JHUtility showToastWithMessage:dic[@"showMsg"]];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            
            
        }else{
            
            [self modifyStaffSectionfail];
        }
        
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];
        [JHUtility showToastWithMessage:@"修改部门失败"];
        [self modifyStaffSectionfail];
    }];

}



//懒加载蒙版
-(UIView *)marskingView{

    if (!_marskingView) {
        _marskingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, DEF_HEIGHT)];
        _marskingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
        @weakify(self);
        UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [removeBtn setimage:@"2.2_icon_vip_default"];
        
        [removeBtn addTarget:self action:@selector(hideMarkingView) forControlEvents:UIControlEventTouchUpInside];
        [_marskingView addSubview:removeBtn];
        [removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            
            make.height.width.mas_equalTo(63.5);
            make.right.mas_equalTo(-35);
            make.bottom.mas_equalTo(-71);
        }];
        /*
        _staffInviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _staffInviteBtn.hidden = YES;
        [_staffInviteBtn setimage:@"2.2.1_btn_zhaopin"];
       
        [_staffInviteBtn addTarget:self action:@selector(staffInviteHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_marskingView addSubview:self.staffInviteBtn];
        
        _staffLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _staffLab.text = @"员工招聘";
        _staffLab.hidden = YES;
        _staffLab.textColor = DEF_COLOR_6E6E6E;
        _staffLab.font = DEF_SET_FONT(12);
        [_marskingView addSubview:_staffLab];
        */
        
        _managerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_managerBtn setimage:@"2.2.1_btn_fenlei"];
        [_managerBtn addTarget:self action:@selector(sectionManagerHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_marskingView addSubview:self.managerBtn];
        
        _manageLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _manageLab.text = @"分类管理";
        _manageLab.textColor = DEF_COLOR_6E6E6E;
        _manageLab.font = DEF_SET_FONT(12);
        [_marskingView addSubview:_manageLab];
        
        _staffRankingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_staffRankingBtn setTitle:@"员工排行"];
        [_staffRankingBtn setimage:@"2.2.2_icon_paihang"];
        _staffRankingBtn.imageRect = CGRectMake(8.5, 0, 40, 40);
        _staffRankingBtn.titleRect = CGRectMake(0, 45, 57, 12);
        _staffRankingBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _staffRankingBtn.titleLabel.font = DEF_SET_FONT(12);

        [_staffRankingBtn setTitleColor:DEF_COLOR_6E6E6E forState:UIControlStateNormal];
        [_staffRankingBtn addTarget:self action:@selector(staffRankingHandler:) forControlEvents:UIControlEventTouchUpInside];
        [_marskingView addSubview:self.staffRankingBtn];

        [_staffRankingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(57);
            make.width.mas_equalTo(57);
            make.centerX.equalTo(removeBtn.mas_centerX);
            make.bottom.equalTo(removeBtn.mas_top).offset(-10);
        }];
        
        /*
        [self.staffInviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.height.width.mas_equalTo(40);
            make.centerX.equalTo(self.staffLab.mas_centerX);
            make.bottom.equalTo(self.staffLab.mas_top).offset(-5);
        }];
        
        [self.staffLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(removeBtn.mas_centerX);
            make.bottom.equalTo(removeBtn.mas_top).offset(-10);
        }];
        */
        
        [self.managerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.height.width.mas_equalTo(40);
            
            make.bottom.equalTo(self.manageLab.mas_top).offset(-5);
        }];
        
        [self.manageLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.bottom.equalTo(removeBtn.mas_centerY).offset(-5);
            make.right.equalTo(removeBtn.mas_left).offset(-10);
            make.centerX.equalTo(self.managerBtn.mas_centerX);
        }];

        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideMarkingView)];
        [_marskingView addGestureRecognizer:tap];
    }
    return _marskingView;
}

-(void)hideMarkingView{
    
    [self.marskingView removeFromSuperview];
}

-(void)staffRankingHandler:(UIButton *)sender{

    [self hideMarkingView];
    JHBoss_StaffRangkingTopFiveViewController *staffRankingVC = [[JHBoss_StaffRangkingTopFiveViewController alloc]init];
    staffRankingVC.restArr = self.allShopArr;
    [self.navigationController pushViewController:staffRankingVC animated:YES];
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
    
    [self gainSection];
    
}

//加载显示加载数据时的动画view
-(JHCRM_LoadDataView *)loadDataView{
    
    if (!_loadDataView) {
        _loadDataView = [[JHCRM_LoadDataView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
        
    }
    [_loadDataView startAnimation];
    return _loadDataView;
}





#pragma mark - LXReorderableCollectionViewDelegateFlowLayout methods

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didBeginDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did begin drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout willEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"will end drag");
}

- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout didEndDraggingItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"did end drag");
}

//隐藏导航条
-(BOOL)disableAutomaticSetNavBar{
    
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
