//
//  JHBoss_NotificationReminderViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_NotificationReminderViewController.h"
#import "JHBoss_NotificationReminderTableViewCell.h"
#import "JHBoss_RemindSettingViewController.h"
#import "JHBoss_PayMessageViewController.h"
#import "JHUserInfoData.h"
#import "JHBoss_MenuOrderDetailViewController.h"
@interface JHBoss_NotificationReminderViewController ()<UITableViewDelegate, UITableViewDataSource, JHBoss_NotificationReminderTableViewCellDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<JHBoss_NotificationReminderModel*> *dataArray;
@property (nonatomic, strong) UIButton *emptyBtn; // 清空按钮
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) JHUserInfoData *userInfo;
@property (nonatomic, assign) BOOL loading; // 是否处于加载中
@property (nonatomic, strong) JHCRM_LoadDataView *loadDataView; // 数据加载过程中显示加载动画的view
@property (nonatomic, copy) NSString *merchantId;

@end

@implementation JHBoss_NotificationReminderViewController


-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"通知提醒"];

    [self modificationNotesStaute];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"通知提醒"];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.page = 1;
    
    [self requestUserInfo];
    [self setUI];
}


#pragma mark - request


//获取用户merchantId信息
-(void)requestUserInfo{
    
    @weakify(self);
    
    [self.userInfo getUserInfoIdentify:saveUserIdentify result:^(NSDictionary *result) {
        @strongify(self);
        self.merchantId = result[@"merchantId"];
       [self requestNoticeList];
    }];
}

//修改已读消息状态
-(void)modificationNotesStaute{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
   __block NSMutableArray *arr = [NSMutableArray array];
    @weakify(self);
    [self.dataArray enumerateObjectsUsingBlock:^(JHBoss_NotificationReminderModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (!obj.readStatus.intValue) {
            
            [arr addObject:obj.Id];
        }
        
    }];
    [param setValue:arr forKey:@"ids"];
    [JHHttpRequest postRequestWithParams:param path:JH_modificationNoticeStaute isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
        }
        [self commonConfiguration];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [self commonConfiguration];
    }];
}

// 获取通知列表
- (void)requestNoticeList
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@(self.page) forKey:@"currentPage"];
    [param setValue:@(20) forKey:@"pageSize"];
    [param setValue:self.merchantId forKey:@"merchantId"];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_NoticeList isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        @strongify(self);
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            if (self.page == 1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:[JHBoss_NotificationReminderModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"list"]]];
            if (self.page == 1 && self.dataArray.count == 0) {
                 self.emptyBtn.hidden = YES;
            }else{
            
                self.emptyBtn.hidden = NO;
            }
           
        }
        [self commonConfiguration];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [self commonConfiguration];
    }];
}

//// 清空通知列表
- (void)requestCleanNoticeList
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.merchantId forKey:@"merchantId"];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_SetNoticeEmpty isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            [self.dataArray removeAllObjects];
        }
        self.emptyBtn.hidden = YES;
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

//获取订单id
-(void)requestOrderNum:(NSString *)orderNum restId:(NSString *)restId{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:restId forKey:@"restId"];
    [param setValue:orderNum forKey:@"orderNo"];
    __block NSString *restid = restId;
    [JHUtility showGifProgressViewInView:self.view];
     @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_getOrderIdURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            [self jumptToOrderDeatail:dic[@"data"][@"id"] restId:restid];
        }
        [JHUtility hiddenGifProgressViewInView:self.view];
        
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];
        
    }];
}


#pragma mark - UI

- (void)setUI
{
    @weakify(self);
    
    self.jhtitle = @"通知提醒";
    [self.rightNavButton setTitle:@"设置"];
    [self.rightNavButton setTitleColor:DEF_COLOR_RGB_A(255, 255, 255, 0.7) forState:UIControlStateNormal];
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
    
    // init tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
    
    // init emptyBtn
    [self.view addSubview:self.emptyBtn];
    self.emptyBtn.hidden = YES;
    [self.emptyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.mas_equalTo(-40);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    [[self.emptyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认清空" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        [[alertView rac_buttonClickedSignal] subscribeNext:^(id x) {
            if ([x integerValue] == 1) {
                [self requestCleanNoticeList];
            }
        }];
    }];
    
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        self.page = 1;
        [self requestNoticeList];
        [self.tableView.mj_header endRefreshing];
    }];
    [self.tableView addCustomGifFooterWithRefreshingBlock:^{
        @strongify(self);
        self.page ++;
        [self requestNoticeList];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)onClickRightNavButton:(UIButton *)rightNavButton
{
    JHBoss_RemindSettingViewController *remindSettingVC = [[JHBoss_RemindSettingViewController alloc] init];
    [self.navigationController pushViewController:remindSettingVC animated:YES];
}


#pragma mark - tableView delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"UITableViewCell";
    JHBoss_NotificationReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[JHBoss_NotificationReminderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

  JHBoss_NotificationReminderModel *model = self.dataArray[indexPath.row];
    if (model.type == NotificationReminderTypeNoNote) {
        JHBoss_PayMessageViewController *payMessageVC = [[JHBoss_PayMessageViewController alloc]init];
        payMessageVC.merchanId = self.merchantId;
        [self.navigationController pushViewController:payMessageVC animated:YES];
    }else if (model.type == NotificationReminderTypeRestReceivedNegative || model.type == NotificationReminderTypeWiterReceivedNegative || model.type == NotificationReminderTypeOrderAbnormal){
    
        [self requestOrderNum:model.orderNumber restId:model.restaurantId.stringValue];
    }
}

-(void)jumptToOrderDeatail:(NSString*)orderId restId:(NSString *)restId{

    JHBoss_MenuOrderDetailViewController *orderDVC = [[JHBoss_MenuOrderDetailViewController alloc]init];
    orderDVC.orderId = orderId;
    orderDVC.currentSelectShop = restId;
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

- (UIButton *)emptyBtn
{
    if (!_emptyBtn) {
        _emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emptyBtn setimage:@"1.1.3.1_btn_empty"];
        _emptyBtn.layer.cornerRadius = 32;
        _emptyBtn.layer.masksToBounds = YES;
    }
    return _emptyBtn;
}


-(JHUserInfoData *)userInfo{

    if (!_userInfo) {
        _userInfo = [[JHUserInfoData alloc]init];
    }
    return _userInfo;
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
    
    NSString *text = @"暂无提醒";
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
    [self requestNoticeList];
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

@end
