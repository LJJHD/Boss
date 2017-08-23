//
//  JHBoss_NewsListViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_NewsListViewController.h"
#import "JHBoss_NewsListTableViewCell.h"
#import "JHBoss_NewsDetailViewController.h"
#import <WebKit/WebKit.h>
@interface JHBoss_NewsListViewController ()<WKScriptMessageHandler,WKNavigationDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) WKWebView *wkWebView;
@property (strong, nonatomic)   UIProgressView  *progressView;//进度条
@property (nonatomic, assign) BOOL loadFail;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView *abnormalView;//加载失败异常提醒view
@end

@implementation JHBoss_NewsListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}


-(void)dealloc{

    //需要移除不然会内存泄漏
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:@"jumpToDetail"];
    
//    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _loadFail = NO;
    [self setUI];
}

-(void)setUI{

    self.jhtitle = @"行业资讯";
//    初始化进度条
//    [self initProgressView];
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    WKUserContentController *userContentV = [[WKUserContentController alloc]init];
    [userContentV addScriptMessageHandler:self name:@"jumpToDetail"];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.userContentController = userContentV;
    
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    _wkWebView.navigationDelegate = self;
    _wkWebView.scrollView.emptyDataSetSource = self;
    _wkWebView.scrollView.emptyDataSetDelegate = self;
    
    [self.view addSubview:self.wkWebView];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.and.bottom.mas_equalTo(0);
    }];
    
    NSString *url;
    if (jH_Service_Environment == JH_Service_Environment_Test || jH_Service_Environment == JH_Service_Environment_Dev )
    {
        url = @"http://192.168.2.11:8092";
    }else{
        
        url = @"http://bossinfo.jinghanit.com";
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.wkWebView loadRequest:request];
    
    //开启监听进度条!
//    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma mark --- WKScriptMessageHandler ---,,,sld--
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{

    if ([message.name isEqualToString:@"jumpToDetail"]) {
        
        JHBoss_NewsDetailViewController *newsDetailVC = [[JHBoss_NewsDetailViewController alloc]init];
        newsDetailVC.url = (NSString *)message.body;
        [self.navigationController pushViewController:newsDetailVC animated:YES];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{

     [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.loadFail = YES;
}

//开始加载，对应UIWebView的- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{

    self.loadFail = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//加载成功，对应UIWebView的- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{

    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//进度条
- (void)initProgressView
{
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), 2)];
    progressView.tintColor = [UIColor greenColor];
    progressView.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
}

#pragma mark - KVO
// 计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
            
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma ----DZNEmptyDataSet -------datasoure
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (self.wkWebView.loading || !self.loadFail) {
        return nil;
    }
    if (NETWORK_CONNECTION_STAT == NotReachable) {
        return DEF_IMAGENAME(@"0.4_icon_wangluoyichang");
    }
    return DEF_IMAGENAME(@"1.1.3.2_icon_zanwutixing");
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
