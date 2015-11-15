//
//  Geotification.m
//  GeofencesTest
//
//  Created by Guillermo Saenz on 6/14/15.
//  Copyright (c) 2015 Property Atomic Strong SAC. All rights reserved.
//

#import "GeoNotificaciones.h"

static NSString * kGeotificationLatitudeKey = @"latitude";
static NSString * kGeotificationLongitudeKey = @"longitude";
static NSString * kGeotificationRadiusKey = @"radius";
static NSString * kGeotificationIdentifierKey = @"identifier";
static NSString * kGeotificationNoteKey = @"note";
static NSString * kGeotificationEventTypeKey = @"eventType";

@interface GeoNotificaciones ()

@end

@implementation GeoNotificaciones 

- (NSString *)title{
    if (self.nota.length==0) {
        return @"No hay nota";
    }
    return self.nota;
}

- (NSString *)subtitle{

    return [NSString stringWithFormat:@"Radio: %fm", self.radio];
}

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate radius:(CLLocationDistance)radius identifier:(NSString *)identifier note:(NSString *)note {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.radio = radius;
        self.identificador = identifier;
        self.nota = note;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        CGFloat latitude = [aDecoder decodeDoubleForKey:kGeotificationLatitudeKey];
                            CGFloat longitude = [aDecoder decodeDoubleForKey:kGeotificationLongitudeKey];
        self.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
        self.radio = [aDecoder decodeDoubleForKey:kGeotificationRadiusKey];
        self.identificador = [aDecoder decodeObjectForKey:kGeotificationIdentifierKey];
        self.nota = [aDecoder decodeObjectForKey:kGeotificationNoteKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeDouble:self.coordinate.latitude forKey:kGeotificationLatitudeKey];
    [aCoder encodeDouble:self.coordinate.longitude forKey:kGeotificationLongitudeKey];
    [aCoder encodeDouble:self.radio forKey:kGeotificationRadiusKey];
    [aCoder encodeObject:self.identificador forKey:kGeotificationIdentifierKey];
    [aCoder encodeObject:self.nota forKey:kGeotificationNoteKey];
}

@end
