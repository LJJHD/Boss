//
//  JHBoss_ClassifyManagerViewController.h
//  Boss
//
//  Created by jinghankeji on 2017/5/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHBoss_ClassifyManagerViewController : UIViewController
@property (nonatomic, copy) void(^modificationSectionBlock)();
@property (nonatomic, copy) NSString  *currentShop;//单前餐厅

@end
