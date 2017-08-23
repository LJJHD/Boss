//
//  JHBoss_AdDeatailViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/6/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_AdDeatailViewController.h"
#import <WebKit/WebKit.h>
@interface JHBoss_AdDeatailViewController ()<WKNavigationDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, assign) BOOL loadFail;
@end

@implementation JHBoss_AdDeatailViewController

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
    [self setUpUI];
}

-(void)setUpUI{

    self.jhtitle = @"广告详情";
    self.view.backgroundColor = DEF_COLOR_ECECEC;
    [self.leftNavButton setimage:@"nav_icon_back"];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
    self.wkWebView.navigationDelegate = self;
    
    [self.view addSubview:self.wkWebView];
    @weakify(self);
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.trailing.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adURL]];
    [self.wkWebView loadRequest:request];
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

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{


}
- (void)onClickLeftNavButton:(UIButton *)leftNavButton{
 
    [self dismissViewControllerAnimated:YES completion:nil];
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
