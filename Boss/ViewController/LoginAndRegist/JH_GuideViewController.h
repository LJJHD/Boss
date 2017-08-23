//
//  JH_GuideViewController.h
//  JinghanLife
//
//  Created by 晶汉mac on 2017/3/11.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JH_GuideViewControllerDelegate <NSObject>

- (void)willDissGuideView;

@end

@interface JH_GuideViewController : UIViewController
@property (nonatomic,weak) id    delegate;
+(void)showWithImageNameArray:(NSArray*)imageNameArray;
+(JH_GuideViewController*)shareGuide;
@end
