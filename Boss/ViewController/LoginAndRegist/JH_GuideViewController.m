//
//  JH_GuideViewController.m
//  JinghanLife
//
//  Created by 晶汉mac on 2017/3/11.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JH_GuideViewController.h"

@interface JH_GuideViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView       *guideScrollView;
@property (nonatomic,strong) NSMutableArray            *imageArray;
@end

@implementation JH_GuideViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"引导页"];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"引导页"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navBar.hidden = YES;
}
- (void)initScrolleView
{
    
    self.guideScrollView = [[UIScrollView alloc] init];
    
    self.guideScrollView.delegate = self;
    
    [self.view addSubview:self.guideScrollView];
    self.guideScrollView.frame = CGRectMake(0, 0, DEF_WIDTH, DEF_HEIGHT);
    self.guideScrollView.showsVerticalScrollIndicator = NO;
    self.guideScrollView.showsHorizontalScrollIndicator = NO;
    self.guideScrollView.bounces = NO;
    self.guideScrollView.pagingEnabled = YES;
    self.guideScrollView.contentSize = CGSizeMake(DEF_WIDTH*self.imageArray.count, DEF_HEIGHT);
    __weak JH_GuideViewController *safeSelf = self;
    
    
    
    [self.imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imageView = [[UIImageView alloc] init];

        imageView.backgroundColor = [UIColor redColor];
        
        imageView.image = [UIImage imageNamed:(NSString*)obj];
        
        imageView.frame  = CGRectMake(idx*DEF_WIDTH, 0, DEF_WIDTH, DEF_HEIGHT);
        
        imageView.userInteractionEnabled = YES;
        
        [safeSelf.guideScrollView addSubview:imageView];
        if (idx+1 == safeSelf.imageArray.count) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
            [imageView addGestureRecognizer:tap];
        }
        
    }];
    
     UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
     [window addSubview:self.view];
    
}
- (void)dismiss:(UITapGestureRecognizer*)tap
{
    [self removeFromSupperView];
}
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    @weakify(self);
//    CGFloat contentOffet =[self.imageArray count]*DEF_WIDTH-DEF_WIDTH;
//    if (scrollView.contentOffset.x>contentOffet+30) {
//        
////        if ([self.delegate respondsToSelector:@selector(willDissGuideView)]) {
////            [self.delegate willDissGuideView];
////        }
//          }
//}
- (void)removeFromSupperView
{
    @weakify(self);

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        @strongify(self);
//        self.view.frame = CGRectMake(-DEF_WIDTH, 0, DEF_WIDTH, DEF_HEIGHT);
//    } completion:^(BOOL finished) {
//        @strongify(self);
//        
//        [ self.view removeFromSuperview];
//    }];
    [ self.view removeFromSuperview];


}
+(JH_GuideViewController*)shareGuide
{
    static JH_GuideViewController *__guideVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __guideVC = [[JH_GuideViewController alloc] init];
    });
    return __guideVC;
}
+(void)showWithImageNameArray:(NSArray*)imageNameArray
{
  
    JH_GuideViewController *vc =  [JH_GuideViewController shareGuide];
        
     [vc.imageArray addObjectsFromArray:imageNameArray];
    
     [vc initScrolleView];
        
}

- (NSMutableArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}
@end
