//
//  GeoFencesTestBIT.m
//  GeofencesTest
//
//  Created by JULIO BARBERAN on 17/11/15.
//  Copyright © 2015 Property Atomic Strong SAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "GeoNotificacionesViewController.h"
#import "AddGeotificationViewController.h"
#import "GeoNotificaciones.h"
@import MapKit;
@import CoreLocation;

@interface GeoFencesTestBIT : XCTestCase

@end

@implementation GeoFencesTestBIT

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)TestInstanciaVacia {
    NSArray *items = [[NSUserDefaults standardUserDefaults] arrayForKey:Datos];
    XCTAssertNotNil(items);
}

- (void)TestInstanciaVaciaconTrue {
    
    NSArray *items = [[NSUserDefaults standardUserDefaults] arrayForKey:Datos];
    XCTAssertTrue(items);
}


@end
