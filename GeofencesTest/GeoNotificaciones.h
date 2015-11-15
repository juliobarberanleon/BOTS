//
//  Geotification.h
//  GeofencesTest
//
//  Created by Guillermo Saenz on 6/14/15.
//  Copyright (c) 2015 Property Atomic Strong SAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;
@import CoreLocation;



@interface GeoNotificaciones : NSObject <NSCoding, MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) CLLocationDistance radio;
@property (nonatomic, strong) NSString *identificador;
@property (nonatomic, strong) NSString *nota;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)radius identifier:(NSString *)identifier note:(NSString *)note;

@end