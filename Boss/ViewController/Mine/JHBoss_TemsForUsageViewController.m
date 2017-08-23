//
//  JHBoss_TemsForUsageViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/6/14.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_TemsForUsageViewController.h"
#import <WebKit/WebKit.h>
@interface JHBoss_TemsForUsageViewController ()
@property (nonatomic, strong) WKWebView *wkWebView;
@end

@implementation JHBoss_TemsForUsageViewController

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

    
    self.view.backgroundColor = DEF_COLOR_ECECEC;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:configuration];
    [self.view addSubview:self.wkWebView];
    @weakify(self);
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.leading.trailing.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    NSString *url;
    if (self.protocalType == JHBoss_protocalType_UseProtocal) {
        self.jhtitle = @"使用条款";
        url = @"http://bossinfo.jinghanit.com/#/agreement";
    }else{
         self.jhtitle = @"增值服务说明";
         url = @"http://bossinfo.jinghanit.com/#/explanation";
    }

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.wkWebView loadRequest:request];
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
