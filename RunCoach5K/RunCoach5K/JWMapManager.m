//
//  JWMapManager.m
//  RunCoach5K
//
//  Created by YQ-011 on 7/30/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWMapManager.h"
#import "JWAnnotation.h"
#import "JWAppDelegate.h"

////测试的时候用
//#define kRoomTestMap 1


@interface JWMapManager ()

@property (nonatomic, strong) NSMutableArray *locations;//一条连续的线路，暂停后开始新的阶段；
@property (nonatomic, strong) NSMutableArray *allLocations;//所有走过的路线
@property (nonatomic, strong) NSMutableArray *annotations;//标记点集合
@property (nonatomic, strong) NSMutableArray *allRoutelines;//所有已经显示的路线段，不包括当前正在进行的阶段
@property (nonatomic, strong) NSMutableArray *instantaneousSpeedArray;//保存所有点的瞬时速度

@property (nonatomic, strong) CLLocationManager *loctionManager;
@property (nonatomic, strong) CLLocation *lastAccuratelocation;//最后gps返回位置
@property (nonatomic, strong) MKPolyline *routeline;//当前正在移动的路线
@property (nonatomic, strong) NSMutableArray *tempRoutelines;//所有等待删除的路线

@property (nonatomic, strong) JWAnnotation *nowAnnotation;//当前位置

@property (nonatomic) BOOL refreshMapView;//是否刷新地图
#ifdef kRoomTestMap
@property (nonatomic, strong) NSTimer *testTimer;
#endif




@end

@implementation JWMapManager

+(BOOL)locationServicesEnabled{
#ifdef kRoomTestMap
    return YES;
#else
    return [CLLocationManager locationServicesEnabled];
#endif
    
}

- (void)dealloc
{
#ifdef RUN_DEBUG
    NSLog(@"%s",__FUNCTION__);
#endif
    [self.loctionManager stopUpdatingLocation];
    self.loctionManager.delegate = nil;
}

- (id)init
{
    self = [super init];
    if (self) {
        _locations = [[NSMutableArray alloc] init];
        _allLocations = [[NSMutableArray alloc] init];
        _annotations = [[NSMutableArray alloc] init];
        _allRoutelines = [[NSMutableArray alloc] init];
        _tempRoutelines = [[NSMutableArray alloc] init];
        _instantaneousSpeedArray = [[NSMutableArray alloc] init];
        
#ifndef kRoomTestMap
        _loctionManager = [[CLLocationManager alloc]init];
        _loctionManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [_loctionManager setDistanceFilter:15.f];
        _roadDistance = 0.0f;
        _instantaneousSpeed = 0.0f;
        [self.loctionManager startUpdatingLocation];//预热
        [self.loctionManager stopUpdatingLocation];
#endif
    }
    return self;

}

-(void)beginRoadLog{
    
#ifndef kRoomTestMap
    self.loctionManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        self.loctionManager.purpose = @"The app use GPS only to generate the running track.";
    }
    [self.loctionManager startUpdatingLocation];
    
    
#else
    if (self.testTimer) {
        [self.testTimer invalidate];
        self.testTimer  = nil;
    }
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                      target:self
                                                    selector:@selector(loopNewlocation:)
                                                    userInfo:nil
                                                     repeats:YES];
    self.testTimer = timer;
#endif
}

#ifdef kRoomTestMap
-(void)loopNewlocation:(NSTimer *)timer{
    CLLocationCoordinate2D coordinate;
    if (!self.lastAccuratelocation) {
        coordinate = CLLocationCoordinate2DMake(34.785306f, 113.675523f);
    }else{
        coordinate = CLLocationCoordinate2DMake(self.lastAccuratelocation.coordinate.latitude - 0.00001,
                                                self.lastAccuratelocation.coordinate.longitude+ 0.0001);
    }
    
    CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinate altitude:0.f
                                               horizontalAccuracy:kCLLocationAccuracyNearestTenMeters
                                                 verticalAccuracy:kCLLocationAccuracyNearestTenMeters
                                                        timestamp:[NSDate date]];
    [self locationManager:nil didUpdateToLocation:location fromLocation:nil];
}
#endif

-(void)suspendRoadLog{
    
    
#ifndef kRoomTestMap
    [self.loctionManager stopUpdatingLocation];
    self.loctionManager.delegate = nil;
#else
    [self.testTimer invalidate];
    self.testTimer = nil;
#endif
    
    if (self.locations.count) {
        [self.allLocations addObject:self.locations];
        self.locations  = [[NSMutableArray alloc] init];
        if (self.routeline) {
            [self.allRoutelines addObject:self.routeline];
            self.routeline = nil;

        }
        if (self.lastAccuratelocation) {
            if (self.nowAnnotation) {
                [self.mapView removeAnnotation:self.nowAnnotation];
                self.nowAnnotation = nil;
            }
            JWAnnotation *ann = [[JWAnnotation alloc] init];
            [ann setCoordinate:self.lastAccuratelocation.coordinate];
            [ann setAnnotationType:kAnnotationSuspend];
            [self.mapView addAnnotation:ann];
            [self.annotations addObject:ann];
        }
    }
    _instantaneousSpeed = 0.0f;
    
}

-(NSString *)endAndSaveRoad{
    
#ifndef kRoomTestMap
    [self.loctionManager stopUpdatingLocation];
    self.loctionManager.delegate = nil;
#else
    [self.testTimer invalidate];
    self.testTimer = nil;
#endif
    if (_locations.count) {
        [self.allLocations addObject:_locations];
    }
    if (self.annotations.count) {
        JWAnnotation *ann = [[JWAnnotation alloc] init];
        [ann setCoordinate:self.lastAccuratelocation.coordinate];
        [ann setAnnotationType:kAnnotationEnd];
        [self.mapView addAnnotation:ann];
        [self.annotations addObject:ann];
    }
    if (_allLocations.count) {
        NSString *fileName = [NSString stringWithFormat:@"path_%@",[[NSDate date] description]];
        NSString *strUrl = [[NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()] stringByAppendingPathComponent:fileName];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.annotations.count];
        for (JWAnnotation *ann in self.annotations) {
            [array addObject:[ann coordinateDescribe]];
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_allLocations, kJWMapRouteline, array, kJWMapAnnotation,_instantaneousSpeedArray, kJWMapInstantaneousSpeed, nil];
        [dic writeToFile:strUrl atomically:YES];
        return fileName;
    }
    return nil;
    
}



-(void)refreshAllRouteline{
    if (_mapView) {
        
        if (self.lastAccuratelocation) {
            self.mapView.region = MKCoordinateRegionMake(self.lastAccuratelocation.coordinate, MKCoordinateSpanMake(.005f, .005f));
            
            [self.mapView removeAnnotations:self.annotations];
            [self.mapView addAnnotations:self.annotations];
            
            if (self.routeline) {
                [self.tempRoutelines addObject:_routeline];
            }//等待删除
            self.routeline = [self makePolylineWithLocations:_locations];
            [self.mapView addOverlay:_routeline];
        }
        
        
        if (self.allLocations.count) {
            [self.tempRoutelines addObjectsFromArray:_allRoutelines];//等待删除
            NSMutableArray *muArray = [[NSMutableArray alloc] init];
            for (NSMutableArray *arrar in self.allLocations) {
                [muArray addObject:[self makePolylineWithLocations:arrar]];
            }
            self.allRoutelines = muArray;
            [self.mapView addOverlays:_allRoutelines];
        }
        
        
        
        
        self.refreshMapView = YES;
    }
    
}

-(BOOL)mapViewIsShow{
    return _refreshMapView;
}

-(void)noRefreshMapView{
    self.refreshMapView = NO;
}

-(float)maxInstantaneousSpeed{
    if (self.instantaneousSpeedArray.count > 0) {
        NSNumber *num = [self.instantaneousSpeedArray valueForKeyPath:@"@max.self"];
        return num.floatValue;
    }
    return 0.f;
}

#pragma mark - CLLocationManager delegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
#ifdef RUN_DEBUG
    NSLog(@"%s  %@",__FUNCTION__, [error description]);
#endif
    if ([error code] == kCLErrorDenied) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Failed"
                                                            message:@"To use GPS tracking, please ensure location services are enabled for Run Coach."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        });
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if (newLocation.horizontalAccuracy < kCLLocationAccuracyHundredMeters) {
        _goodGPS = YES;
        if (self.lastAccuratelocation) {
            NSTimeInterval dTime = [newLocation.timestamp timeIntervalSinceDate:self.lastAccuratelocation.timestamp];
            float distance = [newLocation distanceFromLocation:self.lastAccuratelocation];
            if (distance < 1.f || dTime <= 0.f) {
                return;
            }
            _roadDistance += distance;
            if (self.locations.count == 0 && distance < 100 ) {
                //连接上一条线段
                [self.locations addObject:[NSString stringWithFormat:@"%f,%f", self.lastAccuratelocation.coordinate.latitude, self.lastAccuratelocation.coordinate.longitude]];
            }
            
            if (self.nowAnnotation) {
                [self.mapView removeAnnotation:self.nowAnnotation];
            }
            JWAnnotation *ann = [[JWAnnotation alloc] init];
            [ann setCoordinate:newLocation.coordinate];
            [ann setAnnotationType:kAnnotationNow];
            [self.mapView addAnnotation:ann];
            self.nowAnnotation = ann;
            
        }else{
            JWAnnotation *ann = [[JWAnnotation alloc] init];
            [ann setCoordinate:newLocation.coordinate];
            [ann setAnnotationType:kAnnotationBegin];
            [self.mapView addAnnotation:ann];
            [self.annotations addObject:ann];
            self.mapView.region = MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(.005f, .005f));
        }
        _instantaneousSpeed = newLocation.speed;
        [self.instantaneousSpeedArray addObject:@(newLocation.speed)];
        self.lastAccuratelocation = newLocation;
        [self.locations addObject:[NSString stringWithFormat:@"%f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude]];
        if (self.refreshMapView && [JWAppDelegate applicationIsInForeground]) {
            MKPolyline *route = [self makePolylineWithLocations:_locations];
            [self.mapView insertOverlay:route atIndex:0];
            if (self.routeline) {
                [self.tempRoutelines addObject:_routeline];
            }
            self.routeline = route;
        }
    }
    
    
}

- (MKPolyline *)makePolylineWithLocations:(NSMutableArray *)newLocations{
    MKMapPoint *pointArray = malloc(sizeof(MKMapPoint)* newLocations.count);
    for(int i = 0; i < newLocations.count; i++)
    {
        NSString* currentPointString = [newLocations objectAtIndex:i];
        NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        CLLocationDegrees latitude  = [[latLonArr objectAtIndex:0] doubleValue];
        CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        pointArray[i] = MKMapPointForCoordinate(coordinate);
    }
    MKPolyline *polyline = [MKPolyline polylineWithPoints:pointArray count:newLocations.count];
    free(pointArray);
    return polyline;
}

#pragma mark - MKMapView delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[JWAnnotation class]]) {
        
        static NSString *Identifier = @"CalloutView";
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:Identifier];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView"];
            annotationView.centerOffset = CGPointMake(0, -12);
        }
        if ([(JWAnnotation*)annotation annotationType] == kAnnotationBegin) {
            [annotationView setImage:[UIImage imageNamed:@"map_start_icon"]];
        }else if ([(JWAnnotation*)annotation annotationType] == kAnnotationEnd){
            [annotationView setImage:[UIImage imageNamed:@"map_stop_icon"]];
        }else if ([(JWAnnotation*)annotation annotationType] == kAnnotationSuspend){
            [annotationView setImage:[UIImage imageNamed:@"map_susoend_icon"]];
        }else if ([(JWAnnotation*)annotation annotationType] == kAnnotationNow){
            [annotationView setImage:[UIImage imageNamed:@"currentlocation"]];
            annotationView.centerOffset = CGPointMake(0, 0);
        }
        return annotationView;
	} 
	return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay{

    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView *routeLineView = [[MKPolylineView alloc] initWithPolyline:overlay];
        routeLineView.strokeColor = kRGB255UIColor(20, 156, 76, 1.f);
        routeLineView.fillColor = kRGB255UIColor(20, 156, 76, .5f);
        routeLineView.lineWidth = 6;
        return routeLineView;
    }
    return nil;
}

-(void)mapView:(MKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews{
#ifdef RUN_DEBUG
    NSLog(@"%s return OverlayView...",__FUNCTION__);
#endif
    if (self.tempRoutelines.count >= 2) {
        for (int i = 0; i < self.tempRoutelines.count -2; i ++) {
            MKPolyline *line = [self.tempRoutelines objectAtIndex:i];
            [mapView removeOverlay:line];
            [self.tempRoutelines removeObjectAtIndex:i];
        }
    }
}

@end
