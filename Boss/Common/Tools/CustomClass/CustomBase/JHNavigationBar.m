//
//  JHNavigationBar.m
//  JinghanLife
//
//  Created by 晶汉mac on 2016/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JHNavigationBar.h"

@interface JHNavigationBar ()
@property (nonatomic ,strong)UIImageView *bottomLine;
@end

@implementation JHNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundImageView = [[UIImageView alloc] init];
        self.backgroundImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundImageView];
    
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 14, 13, 14);
        [self.leftBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:self.leftBtn];
      
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.center = CGPointMake(DEF_WIDTH/2,20+44/2);
        self.titleLabel.bounds = CGRectMake(0, 0, 250, 30);
        self.titleLabel.textColor = [UIColor whiteColor];//DEF_COLOR_RGB(67, 67, 67)
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
//        //创建一个导航栏集合
//        UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
//        
//        //向导航栏集合中添加横向按钮列表
//        NSArray *buttons = [NSArray arrayWithObjects:@"店铺管理", @"员工管理", nil];
//        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:buttons];
//        
//        //添加按钮响应事件
//        [[segmentedControl rac_newSelectedSegmentIndexChannelWithNilValue:nil] subscribeNext:^(id x) {
//            
//        }];
//        
//        //把导航栏集合添加入导航栏中，设置动画关闭
//        [self pushNavigationItem:navigationItem animated:NO];
//        
//        //将横向列表添加到导航栏
//        navigationItem.titleView = segmentedControl;
        
        self.bottomLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 - 0.5, DEF_WIDTH, 0.5)];
        self.bottomLine.backgroundColor = DEF_COLOR_ECECEC;
        [self addSubview:self.bottomLine];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.rightBtn];
        [self insertSubview:self.overlay atIndex:0];
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.offset(-15);
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.width.offset(44);
            make.height.offset(44);
        }];
        
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.offset(0);
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.width.offset(44);
            make.height.offset(44);
        }];
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
        __weak typeof(self) weakself = self;
        [[RACSignal merge:@[RACObserve(self.leftBtn.imageView, image),
                            RACObserve(self.leftBtn.titleLabel, text)]]subscribeNext:^(id x) {
            [weakself changeButtonRect:weakself.leftBtn];
        }];
        [[RACSignal merge:@[RACObserve(self.rightBtn.imageView, image),
                            RACObserve(self.rightBtn.titleLabel, text)]]subscribeNext:^(id x) {
            [weakself changeButtonRect:weakself.rightBtn];
        }];
    }
        return self;
}

- (void)changeButtonRect:(UIButton *)button{
    if (isObjNotEmpty(button.imageView.image) || isObjNotEmpty(button.titleLabel.text)) {
        CGFloat width = 1 + button.imageView.image.size.width + (isObjNotEmpty(button.titleLabel.text) ? [button.titleLabel.text stringWidth:^(StringRectParamModel *param) {
            param.setFontNumber(14);
        }]:0);
        if (width > CGRectGetWidth(button.frame)) {
            [button mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.offset(width);
                
            }];
        }
    }
}

- (void)updateBackgroundColor:(UIColor *)backgroundColor
{
    self.backgroundColor = backgroundColor;
    [self hideLineOfNavtionBar];
//    self.overlay.backgroundColor = backgroundColor;
}

- (UIView*)overlay
{
    if (!_overlay) {
        _overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds) + 20)];
        _overlay.userInteractionEnabled = NO;
        _overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _overlay;
}
- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    self.backgroundImageView.image = backgroundImage;
}
- (void)hideLineOfNavtionBar{
    self.bottomLine.hidden = YES;
}

- (void)showLineOfNavtionBar{
    self.bottomLine.hidden = NO;
}

@end
