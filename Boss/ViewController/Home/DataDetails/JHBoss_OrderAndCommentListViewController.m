//
//  JHBoss_OrderAndCommentListViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/6/21.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderAndCommentListViewController.h"
#import "JHBoss_OrderAndCommentListTableViewCell.h"
#import "JHBoss_OrderExceptionListTableViewCell.h"
#import "JHBoss_OrderExceptionListModel.h"
#import "JHBoss_MenuOrderDetailViewController.h"
@interface JHBoss_OrderAndCommentListViewController ()<UITableViewDelegate, UITableViewDataSource, JHBoss_NotificationReminderTableViewCellDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL loading; // 是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView; // 数据加载过程中显示加载动画的view
@end

@implementation JHBoss_OrderAndCommentListViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}


// 获取订单异常列表
- (void)requestData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSDictionary *pageDic = @{@"currentPage":@(self.page),@"pageSize":@"20"};
    [param setObject:pageDic forKey:@"page"];
//    self.merchanId
    [param setValue:self.merchanId forKey:@"merchantId"];
    [param setValue:self.BegainSelectedDate forKey:@"startTime"];
    [param setValue:self.EndSelectedDate forKey:@"endTime"];
    NSString *url;
    if (self.orderOrCommentEntInto == JHBoss_OrderEnterInto) {
        
        url = JH_OrderAbnormalListURL;
    }else{
    
       url = JH_badCommentsListURL;
    }
    [JHHttpRequest postRequestWithParams:param path:url isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            
            if (self.orderOrCommentEntInto == JHBoss_OrderEnterInto) {
                
                [self.dataArray addObjectsFromArray:[JHBoss_OrderExceptionListModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"list"]]];
            }else{
                
                [self.dataArray addObjectsFromArray:[JHBoss_BadEvaluateModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"list"]]];
            }
        }
        [self commonConfiguration];
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [self commonConfiguration];
    }];
}
//差评列表点击请求订单id
-(void)requestOrderNum:(NSString *)orderNum restId:(NSString *)restId{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:restId forKey:@"restId"];
    [param setValue:orderNum forKey:@"orderNo"];
    __block NSString *restid = restId;
    [JHUtility showGifProgressViewInView:self.view];
    [JHHttpRequest postRequestWithParams:param path:JH_getOrderIdURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
        
            [self jumpToMenuOrderVCOrderId:dic[@"data"][@"id"] restId:restid];
        }
        [JHUtility hiddenGifProgressViewInView:self.view];

    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.loading = YES;
    [self requestData];
    [self setUI];
}

#pragma mark - UI

- (void)setUI
{
    @weakify(self);
    
    if (self.orderOrCommentEntInto == JHBoss_OrderEnterInto) {
        
        self.jhtitle = @"订单异常";
    }else{
        self.jhtitle = @"差评列表";
    }
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
    
    // init tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
    
    
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self requestData];
        [self.tableView.mj_header endRefreshing];
    }];
    [self.tableView addCustomGifFooterWithRefreshingBlock:^{
        @strongify(self);
        self.page ++;
        [self requestData];
        [self.tableView.mj_footer endRefreshing];
    }];
}



#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return 2;
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.orderOrCommentEntInto == JHBoss_OrderEnterInto) {
        
        static NSString *reuse = @"JHBoss_OrderExceptionListTableViewCell";
        JHBoss_OrderExceptionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[JHBoss_OrderExceptionListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.model = self.dataArray[indexPath.row];
        return cell;
        
    }else{
        
        static NSString *reuse = @"UITableViewCell";
        JHBoss_OrderAndCommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[JHBoss_OrderAndCommentListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            cell.model = self.dataArray[indexPath.row];
        return cell;
    }
    
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *orderNumber;
    NSString *restId;
    if (self.orderOrCommentEntInto == JHBoss_OrderEnterInto) {
        
        JHBoss_OrderExceptionListModel *model = self.dataArray[indexPath.row];
        orderNumber = model.exOrderId.stringValue;
        restId = model.merchantId.stringValue;
        [self jumpToMenuOrderVCOrderId:orderNumber restId:restId];
    }else{
    
        JHBoss_BadEvaluateModel *badModel = self.dataArray[indexPath.row];
        orderNumber = badModel.orderNo;
        restId = badModel.merchantId.stringValue;
        [self requestOrderNum:orderNumber restId:restId];
    }
    
}

/**
 跳转订单详情

 @param orderId 订单ID
 @param restid 餐厅id
 */
-(void)jumpToMenuOrderVCOrderId:(NSString *)orderId restId:(NSString *)restid{

    JHBoss_MenuOrderDetailViewController *orderDVC = [[JHBoss_MenuOrderDetailViewController alloc]init];
    orderDVC.orderId = orderId;
    orderDVC.currentSelectShop = restid;
    [self.navigationController pushViewController:orderDVC animated:YES];

}

#pragma mark - JHBoss_NotificationReminderTableViewCellDelegate

/// 点击了 Label 的链接
- (void)cell:(JHBoss_NotificationReminderTableViewCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange {
    NSAttributedString *text = label.textLayout.text;
    if (textRange.location >= text.length) return;
    //    YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:textRange.location];
    //    NSDictionary *info = highlight.userInfo;
    //    if (info.count == 0) return;
    //
    //    if (info[kWBLinkHrefName]) {
    //        NSString *url = info[kWBLinkHrefName];
    //        YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    //        [self.navigationController pushViewController:vc animated:YES];
    //        return;
    //    }
    //
    //    if (info[kWBLinkURLName]) {
    //        WBURL *url = info[kWBLinkURLName];
    //        WBPicture *pic = url.pics.firstObject;
    //        if (pic) {
    //            // 点击了文本中的 "图片链接"
    //            YYTextAttachment *attachment = [label.textLayout.text attribute:YYTextAttachmentAttributeName atIndex:textRange.location];
    //            if ([attachment.content isKindOfClass:[UIView class]]) {
    //                YYPhotoGroupItem *info = [YYPhotoGroupItem new];
    //                info.largeImageURL = pic.large.url;
    //                info.largeImageSize = CGSizeMake(pic.large.width, pic.large.height);
    //
    //                YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:@[info]];
    //                [v presentFromImageView:attachment.content toContainer:self.navigationController.view animated:YES completion:nil];
    //            }
    //
    //        } else if (url.oriURL.length){
    //            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url.oriURL]];
    //            [self.navigationController pushViewController:vc animated:YES];
    //        }
    //        return;
    //    }
    //
    //    if (info[kWBLinkTagName]) {
    //        WBTag *tag = info[kWBLinkTagName];
    //        NSLog(@"tag:%@",tag.tagScheme);
    //        return;
    //    }
    //
    //    if (info[kWBLinkTopicName]) {
    //        WBTopic *topic = info[kWBLinkTopicName];
    //        NSString *topicStr = topic.topicTitle;
    //        topicStr = [topicStr stringByURLEncode];
    //        if (topicStr.length) {
    //            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/k/%@",topicStr];
    //            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    //            [self.navigationController pushViewController:vc animated:YES];
    //        }
    //        return;
    //    }
    //
    //    if (info[kWBLinkAtName]) {
    //        NSString *name = info[kWBLinkAtName];
    //        name = [name stringByURLEncode];
    //        if (name.length) {
    //            NSString *url = [NSString stringWithFormat:@"http://m.weibo.cn/n/%@",name];
    //            YYSimpleWebViewController *vc = [[YYSimpleWebViewController alloc] initWithURL:[NSURL URLWithString:url]];
    //            [self.navigationController pushViewController:vc animated:YES];
    //        }
    //        return;
    //    }
}


#pragma mark - setter/getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
    NSString *text;
    if (self.orderOrCommentEntInto == JHBoss_OrderEnterInto) {
        
        text = @"暂无异常订单";
    }else{
        text = @"暂无差评";
    }
//    NSString *text = @"暂无提醒";
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
//    [self requestNoticeList];
}

//加载显示加载数据时的动画view
-(JHCRM_LoadDataView *)loadDataView{
    
    if (!_loadDataView) {
        _loadDataView = [[JHCRM_LoadDataView alloc]initWithFrame:CGRectMake(0, 0, 120, 120)];
    }
    [_loadDataView startAnimation];
    return _loadDataView;
}

-(void)commonConfiguration{
    _loading = NO;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.loadDataView stopAnimation];
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
