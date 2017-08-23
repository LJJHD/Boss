//
//  JHMapView.m
//  TestSvn
//
//  Created by 晶汉mac on 2016/12/29.
//  Copyright © 2016年 李聪会. All rights reserved.
//

#import "JHMapView.h"
@interface JHMapView()<JHLocationServiceDelegate>


@end
@implementation JHMapView
- (void)startMapLocation
{//开始定位
    
    [[JHLocationService shareLocation] startLocationService];
    [JHLocationService shareLocation].delegate = self;
    self.userTrackingMode  = BMKUserTrackingModeNone;//设置定位的状态
    self.showsUserLocation = YES;
    
}
- (void)didUpdateJHUserLocation:(BMKUserLocation *)userLocation
{   //在地图上显示我的位置
    [self updateLocationData:userLocation];
    BMKCoordinateRegion region;
    region.center.latitude = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.longitudeDelta = 0.1;
    region.span.latitudeDelta = 0.1;
    self.region = region;

//    //添加一个点
//    BMKPointAnnotation* annotationSecond = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D Secondcoor;
//    Secondcoor.latitude = userLocation.location.coordinate.latitude ;
//    Secondcoor.longitude = userLocation.location.coordinate.longitude;
//    annotationSecond.coordinate = Secondcoor;
//    annotationSecond.title = [JHLocationService shareLocation].currentAddress;
//    [self addAnnotation:annotationSecond];
//    [self mapForceRefresh];
}

@end
