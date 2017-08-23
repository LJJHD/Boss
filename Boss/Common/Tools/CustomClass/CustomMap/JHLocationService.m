//
//  JHLocationService.m
//  TestSvn
//
//  Created by 晶汉mac on 2016/12/29.
//  Copyright © 2016年 李聪会. All rights reserved.
//

#import "JHLocationService.h"

@interface JHLocationService()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic, strong)  BMKGeoCodeSearch *geocodesearch;//检索
@property (nonatomic,strong)      BMKMapManager *mapManager;
@end
@implementation JHLocationService
#define KLocationStatusUpdateNotification @"KLocationStatusUpdateNotification"

+(instancetype)shareLocation
{
    static JHLocationService *__loacation;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __loacation = [[JHLocationService alloc] init];
     //   [__loacation initBaiduMap];
    });
    return __loacation;
}
- (void)initBaiduMap{
    BMKMapManager *mapManager  = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:@"UGlrPpAfKQIWPOrOsDvG6qT67OpviDvC"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
#define 开始和停止定位
- (void)startLocationService
{
    [self.bmLocationservice startUserLocationService];
    
    self.geocodesearch.delegate  = self;
    
    /**设置最小精度**/
    self.bmLocationservice.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    /// 设定定位的最小更新距离。默认为kCLDistanceFilterNone
    
    self.bmLocationservice.distanceFilter = 100.f;
    
    [self updateLocationStatusAccordingToSystemLocationStatus];
    
}

- (void)stopLocationService
{
    [self.bmLocationservice stopUserLocationService];
    
}
#pragma 定位代理
//位置更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
   // [self stopLocationService];
    //位置更新代理
    if ([self.delegate respondsToSelector:@selector(didUpdateJHUserLocation:)]) {
        [self.delegate didUpdateJHUserLocation:userLocation];
    }
    //地理编码解码
    [self reverseGeoCodeWithLatitude:userLocation.location.coordinate];

}
//定位失败
- (void)didFailToLocateUserWithError:(NSError *)error
{
    [self updateLocationStatusAccordingToSystemLocationStatus];
}
//已经停止定位
- (void)didStopLocatingUser
{
    
}
//根据系统定位状态更新业务层面的定位状态
-(void)updateLocationStatusAccordingToSystemLocationStatus
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status)
    {
        self.locateStatus = ELocationStatusUserDenyLocate;
    }
    else if( kCLAuthorizationStatusNotDetermined == status )
    {
        self.locateStatus = ELocationStatusLocating;
    }
    else
    {
        self.locateStatus = ELocationStatusLocating;
    }
}
#pragma 地理编码解码
- (void)reverseGeoCodeWithLatitude:(CLLocationCoordinate2D)coordinate
{
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [self.geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if (flag)
    {
        NSLog(@"反地理编码成功");//可注释
    }
    else
    {
        NSLog(@"反地理编码失败");//可注释
         self.locateStatus = ELocationStatusLocateError;
    }
}
//根据 经纬度 获取 地区信息
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        self.locateStatus = ELocationStatusLocateSuccessful;

        if ([self.delegate respondsToSelector:@selector(didonGetReverseGeoCodeResult:)])
        {
            [self.delegate didonGetReverseGeoCodeResult:result];
        }

        NSString *address = result.address;
        self.currentAddress = address;
        
        //result.addressDetail ///层次化地址信息
        
        NSLog(@"我的位置在 %@",address);
            [[NSNotificationCenter defaultCenter] postNotificationName:KLocationStatusUpdateNotification object:nil];

    }
    else
    {
        NSLog(@"未找到结果 %u",error);
        self.locateStatus = ELocationStatusLocateError;

    }
}
#pragma 懒加载
- (BMKGeoCodeSearch *)geocodesearch
{
    if (!_geocodesearch)
    {
        _geocodesearch = [[BMKGeoCodeSearch alloc] init];
        
        _geocodesearch.delegate = self;
    }
    return _geocodesearch;
}
- (BMKLocationService*)bmLocationservice
{
    if ((!_bmLocationservice)) {
        _bmLocationservice = [[BMKLocationService alloc] init];
        _bmLocationservice.delegate = self;

    }
    return _bmLocationservice;
}
@end
