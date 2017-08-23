//
//  JHLocationService.h
//  TestSvn
//
//  Created by 晶汉mac on 2016/12/29.
//  Copyright © 2016年 李聪会. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

/**
 自定义定位
 **/
typedef enum ELocationStatusTag
{
    
    //权限受限
    ELocationStatusUserDenyLocate,
    
    //无法定位
    ElocationStatusUnableLocate,
    
    //正在定位
    ELocationStatusLocating,
    
    //定位成功
    ELocationStatusLocateSuccessful,
    
    //定位出错
    ELocationStatusLocateError
    
}ELocationStatus;


@protocol JHLocationServiceDelegate <NSObject>
/**位置更新代理**/
- (void)didUpdateJHUserLocation:(BMKUserLocation *)userLocation;
/**根据地理位置检索结果代理**/
- (void)didonGetReverseGeoCodeResult:(BMKReverseGeoCodeResult*)result;

@end

@interface JHLocationService : NSObject

@property (nonatomic) ELocationStatus           locateStatus;

@property (nonatomic,strong) BMKLocationService *bmLocationservice;//百度定位服务

@property (nonatomic,strong) NSString           *currentAddress;//定位当前的位置

@property (nonatomic,strong) NSString           *currentCity;//定位当前城市

@property (nonatomic,strong) NSString           *currentDistrict;//定位当区

@property (nonatomic,strong) NSString           *currentProvince;//定位当前城市

@property (nonatomic,assign) BOOL               isChangeCurrentLocatio;//是否需要改变当前位置



@property (nonatomic,weak)   id<JHLocationServiceDelegate>                delegate;

+(instancetype)shareLocation;

- (void)startLocationService;//开始定位

- (void)stopLocationService;//停止定位
/**
 根据经纬度检索
 **/
- (void)reverseGeoCodeWithLatitude:(CLLocationCoordinate2D)coordinate;
@end


