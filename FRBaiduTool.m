//
//  FRBaiduTool.m
//  sugeOnlineMart
//
//  Created by 1860 on 2016/10/5.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//

#import "FRBaiduTool.h"
#import "FRAccessPermission.h"

@interface FRBaiduTool ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
    BOOL isGeoSearch;
}

/**  当前控制器  */
@property (nonatomic, strong) UIViewController *controller;

@property (nonatomic, copy) UserLocationBlock userLocation;

@property (nonatomic, copy) UserLocationBlock locationBlock;

@property (nonatomic, copy) PlacemarkBlock placemarkBlock;

@end

@implementation FRBaiduTool

// 用来保存唯一的单例
static id _instace;

+ (instancetype)shareFRBaiduTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [[self alloc]init];
    });
    return _instace;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instace = [super allocWithZone:zone];
    });
    return _instace;
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instace;
}


- (instancetype)init {
    if (self = [super init]) {
        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    return self;
}

//自iOS8起，系统定位功能进行了升级，SDK为了实现最新的适配，自v2.5.0起也做了相应的修改，开发者在使用定位功能之前，需要在info.plist里添加（以下二选一，两个都添加默认使用NSLocationWhenInUseUsageDescription）：
//
//NSLocationWhenInUseUsageDescription ，允许在前台使用时获取GPS的描述
//NSLocationAlwaysUsageDescription ，允许永久使用GPS的描述

#pragma mark - 地图定位
- (void)startLocationWithController:(UIViewController *)controller  userLocation:(UserLocationBlock)userLocation {
    
    self.controller = controller;
    self.userLocation = userLocation;
    controller.navigationController.navigationBar.translucent = NO;
 
    _locService = [[BMKLocationService alloc]init];
    
    [_locService startUserLocationService];
    _locService.delegate = self;
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    self.userLocation(userLocation.location.coordinate);
    
    //获取当前城市后关闭该页面的定位服务功能
    [_locService stopUserLocationService];
}


/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
    NSLog(@"Error: %@",[error localizedDescription]);
    if ([[FRAccessPermission shareFRAccessPermission] LocationPemissionWithController:self.controller]) [MBProgressHUD showInfo:@"请检查您的网络"];
}

#pragma mark - 根据地理位置坐标坐标获取位置信息
/**
 根据地理位置坐标坐标获取位置信息
 
 @param coordinate     位置坐标
 @param placemarkBlock 坐标信息
 */
- (void)getPlacemarkWithUserLocation:(CLLocationCoordinate2D)coordinate placemarkBlock:(PlacemarkBlock)placemarkBlock {
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    self.placemarkBlock = placemarkBlock;
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }

}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    if (error == 0) {
        
        BMKAddressComponent* addressDetail = result.addressDetail;
        
        NSString *cityName = addressDetail.city;//获取城市名
        
        NSString *cityDistrict = addressDetail.district;//县区名称
        
        NSString *cityStreet = [addressDetail.streetName stringByAppendingString:addressDetail.streetNumber];//获取街道地址
        
        self.placemarkBlock(cityName,cityDistrict,cityStreet);
        
    }

}


#pragma mark - 根据地理位置信息获取坐标
/**
 根据地理位置信息获取坐标

 @param locationCity        城市名
 @param locationCityAddress 地址
 @param locationBlock       位置坐标
 */
- (void)getLocationWithLocationCity:(NSString *)locationCity locationCityAddress:(NSString *)locationCityAddress locationBlock:(UserLocationBlock)locationBlock {
    
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= locationCity;
    geocodeSearchOption.address = locationCityAddress;
    self.locationBlock = locationBlock;
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    
}


- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        NSString* titleStr;
        NSString* showmeg;
        self.locationBlock(result.location);
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"纬度:%f,经度:%f",item.coordinate.latitude,item.coordinate.longitude];
        NSLog(@"%@---%@",titleStr,showmeg);
    }
}


#pragma mark - 计算地图上的两点间的距离
/**
 计算地图上的两点间的距离(千米)

 @param otherLongitude 需要获取位置的X
 @param otherLatitude  需要获取位置的Y
 @param selfLongitude  当前X
 @param selfLatitude   当前Y

 @return 两点间的距离
 */
- (double)distabceWithOtherLongitude:(double)otherLongitude otherLatitude:(double)otherLatitude selfLongitude:(double)selfLongitude selfLatitude:(double)selfLatitude {
    double er = 6378137; // 6378700.0f;
    
    double radotherLatitude = M_PI*otherLatitude/180.0f;
    double radselfLatitude = M_PI*selfLatitude/180.0f;
    //now long.
    double radlong1 = M_PI*otherLongitude/180.0f;
    double radlong2 = M_PI*selfLongitude/180.0f;
    if( radotherLatitude < 0 ) radotherLatitude = M_PI/2 + fabs(radotherLatitude);// south
    if( radotherLatitude > 0 ) radotherLatitude = M_PI/2 - fabs(radotherLatitude);// north
    if( radlong1 < 0 ) radlong1 = M_PI*2 - fabs(radlong1);//west
    if( radselfLatitude < 0 ) radselfLatitude = M_PI/2 + fabs(radselfLatitude);// south
    if( radselfLatitude > 0 ) radselfLatitude = M_PI/2 - fabs(radselfLatitude);// north
    if( radlong2 < 0 ) radlong2 = M_PI*2 - fabs(radlong2);// west
    //spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
    //zero ag is up so reverse lat
    double x1 = er * cos(radlong1) * sin(radotherLatitude);
    double y1 = er * sin(radlong1) * sin(radotherLatitude);
    double z1 = er * cos(radotherLatitude);
    double x2 = er * cos(radlong2) * sin(radselfLatitude);
    double y2 = er * sin(radlong2) * sin(radselfLatitude);
    double z2 = er * cos(radselfLatitude);
    double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
    //side, side, side, law of cosines and arccos
    double theta = acos((er*er+er*er-d*d)/(2*er*er));
    double dist  = theta*er;
    return dist * 0.001;
}



@end
