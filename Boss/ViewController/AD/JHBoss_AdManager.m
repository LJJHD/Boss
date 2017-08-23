//
//  JHBoss_AdManager.m
//  Boss
//
//  Created by jinghankeji on 2017/6/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_AdManager.h"
#import <XHLaunchAd.h>
#import "JHBoss_AdDeatailViewController.h"
#import "JHBoss_ADModel.h"
@interface JHBoss_AdManager ()<XHLaunchAdDelegate>
@property (nonatomic, strong) NSMutableArray *AdArr;//存储广告
@property (nonatomic, strong) JHBoss_ADModel *adModel;
@property (nonatomic, strong) XHLaunchImageAdConfiguration *imageAdconfiguration;
@end

@implementation JHBoss_AdManager

+(void)load{

    [self shareManager];
}

+(JHBoss_AdManager *)shareManager{

    static JHBoss_AdManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHBoss_AdManager alloc]init];
    });
    return instance;
}

-(instancetype)init{

    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter]addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
            
            [self setupLaunchAd];
        }];
        
    }

    return self;
}


-(void)setupLaunchAd{

    @weakify(self);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setValue:@"1" forKey:@"page"];
     [param setValue:@"4" forKey:@"port"];//那一端 boss 用4 表示
     [XHLaunchAd setWaitDataDuration:1];
    [JHHttpRequest postRequestWithParams:param path:JH_ADURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
//            self.adModel = [JHBoss_ADModel mj_objectWithKeyValues:dic[@"res"][@"data"]];
            self.AdArr = [JHBoss_ADModel mj_objectArrayWithKeyValuesArray:dic[@"res"][@"data"]];
            self.adModel = self.AdArr.firstObject;
            //配置广告数据
            self.imageAdconfiguration = [XHLaunchImageAdConfiguration new];
            //广告停留时间
            _imageAdconfiguration.duration = 3;
            //广告frame
            _imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/1242*1786);
            //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
            _imageAdconfiguration.imageNameOrURLString = self.adModel.picture;
            //图片填充模式
            _imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;
            //广告点击打开链接
            _imageAdconfiguration.openURLString = self.adModel.address;
            //缓存机制
            _imageAdconfiguration.imageOption = XHLaunchAdImageCacheInBackground;
            //广告显示完成动画
            _imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
            //跳过按钮类型
            _imageAdconfiguration.skipButtonType = SkipTypeTimeText;
            //后台返回时,是否显示广告
            _imageAdconfiguration.showEnterForeground = NO;
            //设置自定义调过按钮
            _imageAdconfiguration.customSkipView = [self customeSkipBtn];
            //显示开屏广告
            [XHLaunchAd imageAdWithImageAdConfiguration:_imageAdconfiguration delegate:self];
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

//自定义调过按钮
-(UIView *)customeSkipBtn{
    
    CGFloat addBtnY = 0.0;
    if (DEF_WIDTH <= 320) {
     addBtnY = 50;
    }else if (DEF_WIDTH > 320 && DEF_WIDTH<= 375){
    
    addBtnY = 50;
    }else{
    
     addBtnY = 43;
    }

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor =[UIColor whiteColor];
    button.layer.cornerRadius = MYDIMESCALE(15);
    button.layer.borderWidth = 0.5;
    [button setTitle:@"跳过"];
    button.layer.borderColor = DEF_COLOR_CDA265.CGColor;
    [button setTitleColor:DEF_COLOR_965800 forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    CGFloat btnY = CGRectGetMaxY(self.imageAdconfiguration.frame)+MYDIMESCALE(addBtnY);
    button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-MYDIMESCALE(104),btnY, MYDIMESCALE(70), MYDIMESCALE(30));
    [button addTarget:self action:@selector(skipAction) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//跳过按钮点击事件
-(void)skipAction
{
    [XHLaunchAd skipAction];
}

- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenURLString:(NSString *)openURLString{

    JHBoss_AdDeatailViewController *adDeatail = [[JHBoss_AdDeatailViewController alloc]init];
    adDeatail.adURL = openURLString;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = window.rootViewController;
    [vc presentViewController:adDeatail animated:YES completion:nil];
}

@end
