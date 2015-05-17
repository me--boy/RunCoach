//
//  JWAnnotation.m
//  RunCoach5K
//
//  Created by YQ-011 on 8/1/13.
//  Copyright (c) 2013 YQ-011. All rights reserved.
//

#import "JWAnnotation.h"

@implementation JWAnnotation

@synthesize annotationType = _annotationType;
@synthesize coordinate = _coordinate;

-(id)initWithString:(NSString *)string{
    NSArray *array = [string componentsSeparatedByString:@","];
    if (array.count != 3) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.coordinate = CLLocationCoordinate2DMake([array[0] doubleValue], [array[1] doubleValue]);
        self.annotationType = [array[2] floatValue];
    }
    return self;
}

-(NSString *)coordinateDescribe{
    return [NSString stringWithFormat:@"%lf,%lf,%d", _coordinate.latitude, _coordinate.longitude, _annotationType];
}

@end
