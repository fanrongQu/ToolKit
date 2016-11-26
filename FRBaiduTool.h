//
//  FRBaiduTool.h
//  sugeOnlineMart
//
//  Created by 1860 on 2016/10/5.
//  Copyright © 2016年 FanrongQu. All rights reserved.
//


#define BAIDU_MAP_KEY @"uefMOxpN2ctvPZhfYHuZlHlbage2AeuW"


#import <Foundation/Foundation.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件


typedef void (^PlacemarkBlock)(NSString *cityName,NSString *cityDistrict,NSString *cityStreet);

typedef void (^UserLocationBlock)(CLLocationCoordinate2D userLocation);

@interface FRBaiduTool : NSObject


+ (instancetype)shareFRBaiduTool;


/**
 开始定位

 @param controller   需要定位的控制器
 @param userLocation 当前位置信息
 */
- (void)startLocationWithController:(UIViewController *)controller userLocation:(UserLocationBlock)userLocation;

#pragma mark - 根据地理位置坐标坐标获取位置信息
/**
 根据地理位置坐标坐标获取位置信息

 @param coordinate     位置坐标
 @param placemarkBlock 坐标信息
 */
- (void)getPlacemarkWithUserLocation:(CLLocationCoordinate2D)coordinate placemarkBlock:(PlacemarkBlock)placemarkBlock;



#pragma mark - 根据地理位置信息获取坐标
/**
 根据地理位置信息获取坐标
 
 @param locationCity        城市名
 @param locationCityAddress 地址
 @param locationBlock       位置坐标
 */
- (void)getLocationWithLocationCity:(NSString *)locationCity locationCityAddress:(NSString *)locationCityAddress locationBlock:(UserLocationBlock)locationBlock;

#pragma mark - 计算地图上的两点间的距离
/**
 计算地图上的两点间的距离(千米)
 
 @param otherLongitude 需要获取位置的X
 @param otherLatitude  需要获取位置的Y
 @param selfLongitude  当前X
 @param selfLatitude   当前Y
 
 @return 两点间的距离
 */
- (double)distabceWithOtherLongitude:(double)otherLongitude otherLatitude:(double)otherLatitude selfLongitude:(double)selfLongitude selfLatitude:(double)selfLatitude;

@end
