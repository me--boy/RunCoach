//
//  JWAnnotation.h
//  RunCoach5K
//
//  Created by YQ-011 on 8/1/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef enum {
    kAnnotationBegin,
    kAnnotationSuspend,
    kAnnotationEnd,
    kAnnotationNow
} JWAnnotationType;//不包括阶段开始的提示音，

@interface JWAnnotation : NSObject<MKAnnotation>

@property (nonatomic) JWAnnotationType annotationType;
@property (nonatomic) CLLocationCoordinate2D coordinate;

-(id)initWithString:(NSString *)string;

-(NSString *)coordinateDescribe;
@end
