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

- (void)TestInstanciaVacia {
    NSArray *items = [[NSUserDefaults standardUserDefaults] arrayForKey:Datos];
    XCTAssertNotNil(items);
}

- (void)TestInstanciaVaciaconTrue {

    NSArray *items = [[NSUserDefaults standardUserDefaults] arrayForKey:Datos];
    XCTAssertTrue(items);
}
- (void)TestNotificaciones {
    
    NSArray *items = [[NSUserDefaults standardUserDefaults] arrayForKey:Datos];
    if (items) {
        for (id item in items) {
            GeoNotificaciones *geotificaciones = [NSKeyedUnarchiver unarchiveObjectWithData:item];
            XCTAssertEqualObjects(geotificaciones.nota, @"Manta");
        }
    }
}




@end
