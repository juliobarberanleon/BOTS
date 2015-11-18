//
//  GeofencesTestTests.m
//  GeofencesTestTests
//
//  Created by Guillermo Saenz on 6/14/15.
//  Copyright (c) 2015 Property Atomic Strong SAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GeoNotificacionesViewController.h"
#import "AddGeotificationViewController.h"
#import "GeoNotificaciones.h"
@import MapKit;
@import CoreLocation;

@interface GeofencesTestTests : XCTestCase

@end

@implementation GeofencesTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    [super tearDown];
}

- (void)testPase {
    XCTAssert(YES, @"Pass");
}

- (void)TestNotificacionesMan {
    
    NSArray *items = [[NSUserDefaults standardUserDefaults] arrayForKey:Datos];
    if (items) {
        for (id item in items) {
            GeoNotificaciones *geotificaciones = [NSKeyedUnarchiver unarchiveObjectWithData:item];
            XCTAssertEqualObjects(geotificaciones.nota, @"Manta");
        }
    }
}

- (void)TestNotificacionesMach {
    
    NSArray *items = [[NSUserDefaults standardUserDefaults] arrayForKey:Datos];
    if (items) {
        for (id item in items) {
            GeoNotificaciones *geotificaciones = [NSKeyedUnarchiver unarchiveObjectWithData:item];
            XCTAssertEqualObjects(geotificaciones.nota, @"Machala");
        }
    }
}
- (void)TestNotificacionesGye {
    
    NSArray *items = [[NSUserDefaults standardUserDefaults] arrayForKey:Datos];
    if (items) {
        for (id item in items) {
            GeoNotificaciones *geotificaciones = [NSKeyedUnarchiver unarchiveObjectWithData:item];
            XCTAssertEqualObjects(geotificaciones.nota, @"Guayaquil");
        }
    }
}
- (void)TestNotificacionesQui {
    
    NSArray *items = [[NSUserDefaults standardUserDefaults] arrayForKey:Datos];
    if (items) {
        for (id item in items) {
            GeoNotificaciones *geotificaciones = [NSKeyedUnarchiver unarchiveObjectWithData:item];
            XCTAssertEqualObjects(geotificaciones.nota, @"Quito");
        }
    }
}
- (void)TestNotificacionesCue {
    
    NSArray *items = [[NSUserDefaults standardUserDefaults] arrayForKey:Datos];
    if (items) {
        for (id item in items) {
            GeoNotificaciones *geotificaciones = [NSKeyedUnarchiver unarchiveObjectWithData:item];
            XCTAssertEqualObjects(geotificaciones.nota, @"Cuenca");
        }
    }
}

@end
