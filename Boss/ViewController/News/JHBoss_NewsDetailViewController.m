//
//  JHBoss_NewsDetailViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_NewsDetailViewController.h"
#import <WebKit/WebKit.h>
@interface JHBoss_NewsDetailViewController ()<WKScriptMessageHandler,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (strong, nonatomic)   UIProgressView  *progressView;//进度条
@end

@implementation JHBoss_NewsDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"资讯详情"];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"资讯详情"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}


-(void)setUI{
    
    self.jhtitle = @"资讯内容";
    
//    [self initProgressView];
    
    // 创建UserContentController（提供JavaScript向webView发送消息的方法）
    WKUserContentController *userContentV = [[WKUserContentController alloc]init];
//    [userContentV addScriptMessageHandler:self name:@"NewsDetails"];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.userContentController = userContentV;
    
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    _wkWebView.allowsBackForwardNavigationGestures = YES;
    _wkWebView.navigationDelegate = self;
    [self.view addSubview:self.wkWebView];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.and.bottom.mas_equalTo(0);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.wkWebView loadRequest:request];
    
    //开启监听进度条!
//    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
   
}


#pragma mark --- WKScriptMessageHandler -----
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"NewsDeatails"]) {
        
        JHBoss_NewsDetailViewController *newsDetailVC = [[JHBoss_NewsDetailViewController alloc]init];
        [self.navigationController pushViewController:newsDetailVC animated:YES];
    }
}

//进度条
- (void)initProgressView
{
    //    CGFloat kScreenWidth = [[UIScreen mainScreen] bounds].size.width;
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

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

//开始加载，对应UIWebView的- (void)webViewDidStartLoad:(UIWebView *)webView;
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

//加载成功，对应UIWebView的- (void)webViewDidFinishLoad:(UIWebView *)webView;
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}



-(void)onClickLeftNavButton:(UIButton *)leftNavButton{

    [self.navigationController popViewControllerAnimated:YES];
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
