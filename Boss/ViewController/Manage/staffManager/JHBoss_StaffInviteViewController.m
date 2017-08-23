//
//  JHBoss_StaffInviteViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//
//员工招聘
#import "JHBoss_StaffInviteViewController.h"
#import "JHBoss_StaffInviteTableViewCell.h"
#import "JHBoss_InviteStaffDetailViewController.h"
#import "JHBoss_ApproveHeaderView.h"
#import "JHBoss_StaffInvitePositionModel.h"
#import "JHBoss_ applicantListModel.h"
#import "JHCRM_LoadDataView.h"
@interface JHBoss_StaffInviteViewController ()<UITableViewDelegate,UITableViewDataSource,JHBoss_ApproveHeaderViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray *tagsArr;
@property (nonatomic, strong) NSMutableArray *positionArr;//职位列表

@property (nonatomic, strong) JHBoss_ApproveHeaderView *headerView;

@property (nonatomic, assign) int pageNum;//当前页码
@property (nonatomic, assign)  JH_RefreshType refreshType;
@property (nonatomic, assign) BOOL loading; //是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView;//数据加载过程中显示加载动画的view

@end

@implementation JHBoss_StaffInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _loading = YES;
    [self loadPositionList];
    [self loadApplicantList:@"1"];
    [self setUI];
    
    //下拉刷新
    @weakify(self);
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.pageNum = 1;
        self.refreshType = JH_RefreshType_pullDown;
        [self loadApplicantList:@""];
    }];
    
    //上提加载
    [self.tableView addCustomGifFooterWithRefreshingBlock:^{
        @strongify(self);
        
        self.refreshType = JH_RefreshType_pullUp;
        [self loadApplicantList:@""];
    }];
}

-(void)setUI{

    self.jhtitle = @"员工招聘";
    
     @weakify(self);
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
            make.top.equalTo(self.navBar.mas_bottom);
            make.height.mas_equalTo(44);
        }];
        
        
    }];
    
    [self.view addSubview:self.tableView];
    _tableView.emptyDataSetSource = self;
    _tableView.emptyDataSetDelegate = self;
    _tableView.tableHeaderView.backgroundColor = DEF_COLOR_ECECEC;
   
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.headerView.mas_bottom);
        make.trailing.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_StaffInviteTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_StaffInviteTableViewCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.tagsArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"JHBoss_StaffInviteTableViewCell";
    JHBoss_StaffInviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JHBoss_applicantListModel *model = self.tagsArr[indexPath.row];
    cell.applicantListModel = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    // isObjEmpty(self.tagsArr[indexPath.row]
//    DPLog(@"=====:%lu",(unsigned long)[self.tagsArr[indexPath.row] count]);
    NSMutableArray *arr = self.tagsArr[indexPath.row];
    CGFloat height;
    if (arr.count > 0 ) {
        
        height = 170;
    }else {
    
     height = 90;
    }
    DPLog(@"height===%f",height);
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    JHBoss_InviteStaffDetailViewController *staffDetailVC = [[JHBoss_InviteStaffDetailViewController alloc]init];
    [self.navigationController pushViewController:staffDetailVC animated:YES];

}

#pragma mark -- JHBoss_ApproveHeaderViewDelegate ---
- (void)didSelectMenuBtn:(MenuButton *)menuButton{



}


//获取员工招聘职位列表
-(void)loadPositionList{


    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:self.shopid forKey:@"restaurantId"];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_StaffInvitePositionURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
    
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (isObjNotEmpty(dic[@"data"])) {
             
                self.positionArr = [JHBoss_StaffInvitePositionModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
                
                
            }
            
        }
        
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        
    }];
    
}


//获取应聘某个职位下的员工列表
-(void)loadApplicantList:(NSString *)position{

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:position forKey:@"typeId"];
   
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_applicantListURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
       
        NSDictionary *dic = object;
         [self commonConfiguration];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (self.refreshType == JH_RefreshType_pullDown && self.tagsArr.count > 0 ) {
                
                [self.tagsArr removeAllObjects];
            }
            
            if (isObjNotEmpty(dic[@"data"])) {
                
                self.tagsArr = [JHBoss_applicantListModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
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


#pragma mark - Getter/Settrt
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setCellLineUIEdgeInsetsZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    [self loadApplicantList:@""];
    
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
