//
//  JHBoss_HomeViewController.m
//  Boss
//
//  Created by sftoday on 2017/4/11.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_HomeViewController.h"
#import "JHBoss_PageViewController.h"
#import "XlSegementControl.h"
#import "JHBoss_GeneralViewController.h"
#import "JHBoss_SubbranchViewController.h"
#import "JHBoss_NotificationReminderViewController.h"
#import "JHBoss_PhysicalExaminationViewController.h"
#import "JHUserInfoData.h"
@interface JHBoss_HomeViewController ()<PageViewControllerScrollDelegate,XlSegementControlDetegate>

@property (nonatomic, strong) JHBoss_PageViewController *pageViewController;
@property (nonatomic, strong) XlSegementControl *segmentedControl;
@property (nonatomic, copy)   NSString *merchantId;
@property (nonatomic, strong)  JHUserInfoData *userInfoData;
@property (nonatomic, strong) UIButton *leftNavBtn;
@property (nonatomic, strong) UIButton *rightNavBtn;
@property (nonatomic, strong) UILabel *warnLb;//提醒小红点label
@end


@implementation JHBoss_HomeViewController


// 功能模块新消息和状态
- (void)requestFunctionState
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:self.merchantId forKey:@"merchantId"];
    @weakify(self);
    [JHHttpRequest postRequestWithParams:param path:JH_HomeFunctions isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            NSString *unreadNum = [NSString stringWithFormat:@"%@",dic[@"data"][@"unreadNum"]];
            if (!unreadNum.intValue) {
                
                self.warnLb.hidden = YES;
            }else{
                self.warnLb.hidden = NO;
                self.warnLb.text = unreadNum;
            }
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}


//获取用户merchantId信息
-(void)requestUserInfo{
    
    @weakify(self);
    
    [self.userInfoData getUserInfoIdentify:saveUserIdentify result:^(NSDictionary *result) {
        @strongify(self);
        self.merchantId = result[@"merchantId"];
        dispatch_async(dispatch_get_main_queue(), ^{
             [self requestFunctionState];
        });
    }];
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self requestFunctionState];

}

-(JHUserInfoData *)userInfoData{

    if (!_userInfoData) {
        _userInfoData = [[JHUserInfoData alloc]init];
    }
    return _userInfoData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestUserInfo];
    [self initNaviBar];
    [self createPageViewController];
}

// 初始化分页导航
- (void)initNaviBar
{
    @weakify(self);
    UIView *naviBarView = [[UIView alloc] init];
    naviBarView.backgroundColor = DEF_COLOR_CDA265;
    [self.view addSubview:naviBarView];
    [naviBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    
    [naviBarView addSubview:[self aSegmentedControl]];
    
    self.leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftNavBtn setimage:@"nav_icon_tixing"];
    [naviBarView addSubview:self.leftNavBtn];
    [self.leftNavBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(naviBarView.mas_left).offset(16);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(naviBarView.mas_bottom);
    }];
    
    self.warnLb = [UILabel new];
    self.warnLb.text = @"0";
    self.warnLb.font = DEF_SET_FONT(11);
    self.warnLb.textColor = [UIColor whiteColor];
    self.warnLb.textAlignment = NSTextAlignmentCenter;
    self.warnLb.backgroundColor = [UIColor colorWithHexString:@"#ff001f"];
    self.warnLb.layer.cornerRadius = 9;
    self.warnLb.layer.masksToBounds = YES;
    self.warnLb.hidden = YES;
    [naviBarView addSubview:self.warnLb];
    [self.warnLb mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.mas_equalTo(18);
        make.width.mas_equalTo(18);
        make.left.equalTo(self.leftNavBtn.mas_right).offset(-16);
        make.centerY.equalTo(self.leftNavBtn.mas_centerY).offset(-1);
    }];
    
    self.rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightNavBtn setimage:@"nav_icon_tijian"];
    [naviBarView addSubview:self.rightNavBtn];
    [self.rightNavBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(naviBarView.mas_right).offset(-16);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(naviBarView.mas_bottom);
    }];

    [[self.leftNavBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        JHBoss_NotificationReminderViewController *notificationReminderVC = [[JHBoss_NotificationReminderViewController alloc] init];
        [self.navigationController pushViewController:notificationReminderVC animated:YES];
    }];
    
    [[self.rightNavBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        JHBoss_PhysicalExaminationViewController *physicalExaminationVC = [[JHBoss_PhysicalExaminationViewController alloc] init];
        [self.navigationController pushViewController:physicalExaminationVC animated:YES];

    }];
    
}

-(XlSegementControl*)aSegmentedControl {
    NSInteger count = self.segementTitles.count;
    NSMutableArray* arr = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i ++) {
        XlSegementItem* item = [XlSegementItem itemWithTitle:self.segementTitles[i] image:nil highlightedImage:nil];
        [arr addObject:item];
    }
    _segmentedControl = [[XlSegementControl alloc] initWithItems:arr];
    _segmentedControl.frame = CGRectMake((DEF_WIDTH - 144)/2, 20, 144, 44);
    _segmentedControl.tag = 9999;
    _segmentedControl.delegate = self;
    _segmentedControl.font = [UIFont systemFontOfSize:18];
    _segmentedControl.textColor =  DEF_COLOR_RGB_A(255, 255, 255, 0.51);
    _segmentedControl.selectTextColor = [UIColor whiteColor];
    _segmentedControl.lineColor = DEF_COLOR_RGB(0x96, 0x58, 0x00);
    return _segmentedControl;
}

- (NSArray *)segementTitles{
    return @[@"概况",@"分店"];
}


#pragma mark - XlSegementControl代理方法

-(void)segmentedControl:(XlSegementControl*)segmentedControl didSelectIndex:(NSInteger)index{
    [self changeSegmentControlFrameWithIndex:index];
    //切换视图控制器
    [self.pageViewController setCurrentViewControllerAtIndex:index animated:YES];
}
- (void)changeSegmentControlFrameWithIndex:(NSInteger)index{
    [_segmentedControl segmentIndex:index dotShow:NO];
    _segmentedControl.selectedSegmentIndex = index;
}


#pragma mark - 初始化社区首页控制器

- (void)createPageViewController{
    _pageViewController = [[JHBoss_PageViewController alloc] init];
    _pageViewController.view.frame = CGRectMake(0, 64, DEF_WIDTH, DEF_HEIGHT);
    _pageViewController.pageScrollEnabled = YES;
    _pageViewController.delegate = self;
    NSMutableArray * array = [NSMutableArray array];
    for (int i = 0 ; i < self.segementTitles.count ; i++){
        if (i == 0){
            JHBoss_GeneralViewController * generalVc = [JHBoss_GeneralViewController new];
            [array addObject:generalVc];
        }else if (i == 1){
            JHBoss_SubbranchViewController * newsPosts = [JHBoss_SubbranchViewController new];
            [array addObject:newsPosts];
        }
    }
    _pageViewController.viewControllers = array;
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

- (void)changePage:(NSNotification *)noti
{
    NSInteger index = [noti.userInfo[@"pageNum"] integerValue];
    if (index < self.segementTitles.count && index >= 0){
        [self segmentedControl:_segmentedControl didSelectIndex:index];
    }
}


#pragma mark - 滚动切换导航栏

- (void)pageViewController:(JHBoss_PageViewController *)pageViewController currentIndex:(NSInteger)currentIndex{
    [self changeSegmentControlFrameWithIndex:currentIndex];
}


#pragma mark - other

- (BOOL)disableAutomaticSetNavBar{
    return YES;
}

@end
