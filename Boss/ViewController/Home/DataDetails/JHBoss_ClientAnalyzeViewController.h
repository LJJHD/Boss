//
//  JHBoss_ClientAnalyzeViewController.h
//  Boss
//
//  Created by jinghankeji on 2017/6/23.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_RestaurantModel.h"
//客单价或客流量
typedef NS_ENUM(NSInteger , ClientPricOrFlow) {

    JHBoss_ClientPrice,//客单价
    JHBoss_ClientFlow,//客流量

};

@interface JHBoss_ClientAnalyzeViewController : UIViewController
@property (nonatomic, copy) NSMutableArray<JHBoss_RestaurantModel *> *restArr;//餐厅数组
@property (nonatomic, copy) NSString *BegainSelectedDate;//选中的开始日期
@property (nonatomic, copy) NSString *EndSelectedDate;//选中的结束日期
@property (nonatomic, assign) ClientPricOrFlow clientPricOrFlow;
@end
