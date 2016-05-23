//
//  ZYLocationManager.m
//  EngineeringStructure
//
//  Created by haodai on 15/8/21.
//  Copyright (c) 2015年 haodai. All rights reserved.
//

#import "ZYLocationManager.h"
@interface ZYLocationManager()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKGeoCodeSearch *search;

@property (nonatomic, copy) LocationBlock locationBlock;
@property (nonatomic, copy) LocationFailBlock failBlock;

@end

@implementation ZYLocationManager
+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static ZYLocationManager *location = nil;
    dispatch_once(&onceToken, ^{
        location = [[ZYLocationManager alloc] init];
    });
    return location;
}

- (void)fetchLocationSuccess:(LocationBlock)success fail:(LocationFailBlock)fail {
    if (!_locService) {
        //设置定位精确度，默认：kCLLocationAccuracyBest
        [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        [BMKLocationService setLocationDistanceFilter:100.f];
        self.locService = [[BMKLocationService alloc] init];
    }
    self.locationBlock = success;
    self.failBlock = fail;
    self.locService.delegate = self;
    [self.locService startUserLocationService];
}

- (void)stopLocation {
    [_locService stopUserLocationService];
     _locService.delegate = nil;
     _search.delegate = nil;
}

#pragma mark - Delegate
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.locService stopUserLocationService];
    
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = userLocation.location.coordinate;// (CLLocationCoordinate2D){39.322, 116.404};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    if (!self.search) {
         self.search = [[BMKGeoCodeSearch alloc] init];
    }
    self.search.delegate = self;
    BOOL flag = [self.search reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
        if (self.failBlock) {
            self.failBlock();
        }
    }
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"%@", error);
    if (self.failBlock) {
        self.failBlock();
    }
    [self.locService stopUserLocationService];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"%@", result.addressDetail.city);
    NSLog(@"%@", result.addressDetail.streetName);
    NSLog(@"%@", result.addressDetail.streetNumber);
    NSLog(@"%@", result.addressDetail.province);
    NSLog(@"%@", result.addressDetail.district);
    if (self.locationBlock) {
        self.locationBlock(result);
        self.locationBlock = nil;
    }
    [self.locService stopUserLocationService];
}



@end
