//
//  JHBoss_RecordViewController.m
//  Boss
//
//  Created by SeaDragon on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_RecordViewController.h"

#import "JHBoss_RecordHeardView.h"

#import "JHBoss_recordTableViewCell.h"
#import "JHBoss_RecordModel.h"
#import "JHBoss_NoteConsumeRecordModel.h"
#define DEF_CELL_HEIGHT 60

@interface JHBoss_RecordViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource,
    DZNEmptyDataSetSource,
    DZNEmptyDataSetDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *recordDataSources;

@property (nonatomic, assign) int page;//当前页码
@property (nonatomic, assign)  JH_RefreshType refreshType;
@property (nonatomic, assign) BOOL loading; //是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView;//数据加载过程中显示加载动画的view
@end

@implementation JHBoss_RecordViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}

//加载数据
-(void)loadDate{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.merchanId forKey:@"merchantId"];
    [param setValue:@(self.page) forKey:@"pageNo"];
    if (self.recordType == JHBoss_recordType_consum) {
        //消费
        [param setValue:@"0" forKey:@"type"];
    }else if (self.recordType == JHBoss_recordType_recharge){
    //充值
         [param setValue:@"1" forKey:@"type"];
    }
    [JHHttpRequest postRequestWithParams:param path:JH_WalletRecordsURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
         [self commonConfiguration];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (self.refreshType == JH_RefreshType_pullDown) {
                [self.recordDataSources removeAllObjects];
            }
            self.page ++;
        [self.recordDataSources addObjectsFromArray:[JHBoss_RecordModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [self commonConfiguration];
        if (errorState == JH_HttpRequestFailState_NetworkBreak && isObjEmpty(self.recordDataSources)) {
            [self.tableView reloadEmptyDataSet];
            
        }
    }];
}
//加载短信消费记录
-(void)loadNoteRecord{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.merchanId forKey:@"merchantId"];
    [param setValue:@(self.page) forKey:@"pageNo"];
    [param  setValue:@(10) forKey:@"pageSize"];
    [JHHttpRequest postRequestWithParams:param path:JH_NoteRecordsURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        [self commonConfiguration];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (self.refreshType == JH_RefreshType_pullDown) {
                [self.recordDataSources removeAllObjects];
            }
             self.page ++;
            [self.recordDataSources addObjectsFromArray:[JHBoss_NoteConsumeRecordModel mj_objectArrayWithKeyValuesArray:dic[@"data"]]];

        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [self commonConfiguration];
        if (errorState == JH_HttpRequestFailState_NetworkBreak && isObjEmpty(self.recordDataSources)) {
            [self.tableView reloadEmptyDataSet];
            
        }
    }];

}

-(void)judgeLoad{

    if (self.recordType == JHBoss_recordType_consum || self.recordType == JHBoss_recordType_recharge) {
        //钱包消费 充值
        [self loadDate];
    }else if (self.recordType == JHBoss_recordType_noteRecord){
        //短信消费记录
        [self loadNoteRecord];
    }
}

-(void)commonConfiguration{
    
    _loading = NO;
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.loadDataView stopAnimation];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    _loading = YES;
    _page = 1;
    self.recordDataSources = [NSMutableArray array];
    [self judgeLoad];
    [self navigationConfig];
    
    [self createUI];
    
    //下拉刷新
    @weakify(self);
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        self.refreshType = JH_RefreshType_pullDown;
        [self judgeLoad];
    }];
    
    //上提加载
    [self.tableView addCustomGifFooterWithRefreshingBlock:^{
        @strongify(self);
        
        self.refreshType = JH_RefreshType_pullUp;
        [self judgeLoad];
    }];

}

#pragma mark - Private Method

- (void)navigationConfig {
    
    self.jhtitle = _recordTittle;

}

- (void)createUI {

    //表格视图
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.and.bottom.right.mas_equalTo(0);
    }];
    
}

#pragma mark - Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.recordDataSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number;
    if (self.recordType == JHBoss_recordType_consum || self.recordType == JHBoss_recordType_recharge) {
        //消费
        JHBoss_RecordModel *model = self.recordDataSources[section];
        number = model.records.count;
        return number == 0 ? 1 : number;
    } else {
        JHBoss_NoteConsumeRecordModel *model = self.recordDataSources[section];
        number = model.merchantMessageList.count;
        return number == 0 ? 1 : number;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JHBoss_recordTableViewCell *recordCell = [tableView dequeueReusableCellWithIdentifier:@"JHBoss_recordTableViewCellID"];
    
    if (self.recordType == JHBoss_recordType_consum || self.recordType == JHBoss_recordType_recharge) {
        //钱包消费 充值
        JHBoss_RecordModel *model = self.recordDataSources[indexPath.section];
        if (model.records.count > 0) {
            
           recordCell.recordModel = model.records[indexPath.row];
        }else{
        
            if (self.recordType == JHBoss_recordType_consum) {
                
               recordCell.warningStr = @"本月暂无消费记录";
            }else if (self.recordType == JHBoss_recordType_recharge){
            
               recordCell.warningStr = @"本月暂无充值记录";
            }
        }
    }else if (self.recordType == JHBoss_recordType_noteRecord){
        //短信消费记录
        JHBoss_NoteConsumeRecordModel *model = self.recordDataSources[indexPath.section];
        if (model.merchantMessageList.count > 0) {
            recordCell.noteConRecordModel = model.merchantMessageList[indexPath.row];

        } else {
             recordCell.warningStr = @"本月暂无短信使用记录";

        }
    }
    return recordCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DEF_CELL_HEIGHT - 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    JHBoss_RecordHeardView *heardView = [[JHBoss_RecordHeardView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH, DEF_CELL_HEIGHT)];
    NSString *timeStr;
    NSString *contentStr;
    if (self.recordType == JHBoss_recordType_consum) {
        //消费
        JHBoss_RecordModel *model = self.recordDataSources[section];
        timeStr = model.operateMonthDate;
        contentStr = [NSString stringWithFormat:@"本月消费%g元",model.totalAmount.doubleValue/100];
    }else if (self.recordType == JHBoss_recordType_noteRecord){
         //短信使用
         JHBoss_NoteConsumeRecordModel *model = self.recordDataSources[section];
        timeStr = model.queryDate;
        contentStr = [NSString stringWithFormat:@"本月使用%@条",[model.consumeTotalAmountOneMonth stringValue]];
    }else{
        //充值
        JHBoss_RecordModel *model = self.recordDataSources[section];
         timeStr = model.operateMonthDate;
        contentStr = [NSString stringWithFormat:@"本月充值总额%g元",model.totalAmount.doubleValue/100];
    }
    [heardView showDetailWithDate:timeStr consumptionStr:contentStr];
    return heardView;
}

#pragma mark - Setter And Getter

- (NSMutableArray *)recordDataSources {

    if (!_recordDataSources) {
    
        _recordDataSources = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _recordDataSources;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate        = self;
        _tableView.rowHeight       = DEF_CELL_HEIGHT;
        _tableView.dataSource      = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
        _tableView.tableFooterView = [UIView new];
        _tableView.allowsSelection = NO;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorInset  = UIEdgeInsetsZero;
        [_tableView registerNib:[UINib nibWithNibName:@"JHBoss_recordTableViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"JHBoss_recordTableViewCellID"];
    }
    
    return _tableView;
}

#pragma mark - Dealloc

#pragma ----DZNEmptyDataSet -------datasoure
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (_loading || self.recordDataSources.count > 0) {
        return nil;
    }
    
    if (NETWORK_CONNECTION_STAT == NotReachable) {
        
        return DEF_IMAGENAME(@"0.4_icon_wangluoyichang");
    }
    return DEF_IMAGENAME(@"1.1.3.2_icon_zanwutixing");
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    
    if (self.loading || self.recordDataSources.count > 0) {
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
    
    if (self.recordType == JHBoss_recordType_consum || self.recordType == JHBoss_recordType_recharge) {
        
        [self loadDate];
    }else if (self.recordType == JHBoss_recordType_noteRecord){
       
        //短信消费记录
        [self loadNoteRecord];
    }
    
}

//加载显示加载数据时的动画view
-(JHCRM_LoadDataView *)loadDataView{
    
    if (!_loadDataView) {
        _loadDataView = [[JHCRM_LoadDataView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
        
    }
    [_loadDataView startAnimation];
    return _loadDataView;
}




@end
