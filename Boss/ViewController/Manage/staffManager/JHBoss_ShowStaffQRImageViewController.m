//
//  JHBoss_ShowStaffQRImageViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ShowStaffQRImageViewController.h"
@interface JHBoss_ShowStaffQRImageViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation JHBoss_ShowStaffQRImageViewController

#pragma mark - Lifecycle

//- (void)loadView {
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.view = imageView;
//}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    // 显示图片
//    UIImageView *imageView = (UIImageView *)self.view;
//    float scaleFactor = MIN(self.view.frame.size.width / self.image.size.width,
//                            self.view.frame.size.height / self.image.size.height);
//    CGRect popoverFrame = CGRectMake(0,
//                                     0,
//                                     250 ,
//                                     250 );
//    UIGraphicsBeginImageContextWithOptions(popoverFrame.size, NO, 0.0);
//    [self.image drawInRect:popoverFrame];
//    UIImage *fitImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    imageView.image = fitImage;
//}

#pragma mark - Private
// 重写 preferredContentSize, 返回 popover 的大小
// tableView
/*
- (CGSize)preferredContentSize {
    if (self.presentingViewController) {
        float scaleFactor = MIN(self.view.frame.size.width / self.image.size.width,
                                self.view.frame.size.height / self.image.size.height);
        CGSize fitSize = CGSizeMake(self.image.size.width * scaleFactor,
                                    self.image.size.height * scaleFactor);
        CGSize size = [self.view sizeThatFits:fitSize];
        return size;
    }else{
        return [self preferredContentSize];
    }
}
 */


-(BOOL)disableAutomaticSetNavBar{

    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRGBValue:0 g:0 b:0 alpha:0.9];
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(MYDIMESCALE(37.5));
        make.right.mas_equalTo(MYDIMESCALE(-37.5));
        make.top.bottom.mas_equalTo(MYDIMESCALE(42));
         make.bottom.mas_equalTo(MYDIMESCALE(-42));
    }];
}

-(UIImageView *)imageView{
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithImage:self.image];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
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
