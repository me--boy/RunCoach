//
//  JWMapManager.h
//  RunCoach5K
//
//  Created by YQ-011 on 7/30/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define kJWMapRouteline     @"kJWMapRouteline"
#define kJWMapAnnotation    @"kJWMapAnnotation"
#define kJWMapInstantaneousSpeed   @"kJWInstantaneousSpeed"

@interface JWMapManager : NSObject<CLLocationManagerDelegate,MKMapViewDelegate>

@property (nonatomic, weak)MKMapView *mapView;
@property (nonatomic) float instantaneousSpeed;//gps返回的瞬时速度,m/s
@property (nonatomic) float roadDistance;//总行程
@property (nonatomic) BOOL goodGPS;

+(BOOL)locationServicesEnabled;


-(BOOL)mapViewIsShow;
-(void)beginRoadLog;//开始记录路径
-(void)suspendRoadLog;//暂停记录

-(NSString *)endAndSaveRoad;//停止并且保存路径，返回文件名

-(void)refreshAllRouteline;//将地图上的所有信息刷新一遍；
-(void)noRefreshMapView;

-(float)maxInstantaneousSpeed;//最大的瞬时速度，

@end
