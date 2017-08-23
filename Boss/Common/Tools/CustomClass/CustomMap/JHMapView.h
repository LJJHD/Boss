//
//  JHMapView.h
//  TestSvn
//
//  Created by 晶汉mac on 2016/12/29.
//  Copyright © 2016年 李聪会. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapView.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
//#import "JHBigPinAnnotationView.h"
#import "JHLocationService.h"
/**
 自定义地图，继承BMView
**/
@interface JHMapView : BMKMapView


@property(nonatomic,strong) BMKPoiSearch                 *poiSearch;//检索


- (void)startMapLocation;


@end
