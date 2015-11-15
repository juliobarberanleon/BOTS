//
//  GeotificationsViewController.m
//  GeofencesTest
//
//  Created by Guillermo Saenz on 6/14/15.
//  Copyright (c) 2015 Property Atomic Strong SAC. All rights reserved.
//

#import "GeoNotificacionesViewController.h"
#import "AddGeotificationViewController.h"
#import "GeoNotificaciones.h"
#import "Utilities.h"

@import MapKit;

@interface GeoNotificacionesViewController () <MKMapViewDelegate, AddGeotificationsViewControllerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) NSMutableArray *geotificaciones;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation GeoNotificacionesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [CLLocationManager new];
    [self.locationManager setDelegate:self];
    [self.locationManager requestAlwaysAuthorization];
    [self loadAllGeotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)loadAllGeotifications{
    self.geotificaciones = [NSMutableArray array];
    
    NSArray *savedItems = [[NSUserDefaults standardUserDefaults] arrayForKey:Datos];
    if (savedItems) {
        for (id savedItem in savedItems) {
            GeoNotificaciones *geotification = [NSKeyedUnarchiver unarchiveObjectWithData:savedItem];
            if ([geotification isKindOfClass:[GeoNotificaciones class]]) {
                [self addGeotification:geotification];
            }
        }
    }
}

- (void)saveAllGeotifications{
    NSMutableArray *items = [NSMutableArray array];
    for (GeoNotificaciones *geotification in self.geotificaciones) {
        id item = [NSKeyedArchiver archivedDataWithRootObject:geotification];
        [items addObject:item];
    }
    [[NSUserDefaults standardUserDefaults] setObject:items forKey:Datos];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)addGeotification:(GeoNotificaciones *)geotification{
    [self.geotificaciones addObject:geotification];
    [self.mapView addAnnotation:geotification];
    [self addRadiusOverlayForGeotification:geotification];
    [self updateGeotificationsCount];
}

- (void)removeGeotification:(GeoNotificaciones *)geotification{
    [self.geotificaciones removeObject:geotification];
    
    [self.mapView removeAnnotation:geotification];
    [self removeRadiusOverlayForGeotification:geotification];
    [self updateGeotificationsCount];
}

- (void)updateGeotificationsCount{
    self.title = [NSString stringWithFormat:@"Notaciones (%lu)", (unsigned long)self.geotificaciones.count];
    [self.navigationItem.rightBarButtonItem setEnabled:self.geotificaciones.count<20];
}


- (void)addGeotificationViewController:(AddGeotificationViewController *)controller didAddCoordinate:(CLLocationCoordinate2D)coordinate radius:(CGFloat)radius identifier:(NSString *)identifier note:(NSString *)note {
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    CGFloat clampedRadius = (radius > self.locationManager.maximumRegionMonitoringDistance)?self.locationManager.maximumRegionMonitoringDistance : radius;
    GeoNotificaciones *geotification = [[GeoNotificaciones alloc] initWithCoordinate:coordinate radius:clampedRadius identifier:identifier note:note];
    [self addGeotification:geotification];
    [self startMonitoringGeotification:geotification];
    
    [self saveAllGeotifications];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    static NSString *identifier = @"myGeotification";
    if ([annotation isKindOfClass:[GeoNotificaciones class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (![annotation isKindOfClass:[MKPinAnnotationView class]] || annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            [annotationView setCanShowCallout:YES];
            
            UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            removeButton.frame = CGRectMake(.0f, .0f, 23.0f, 23.0f);
            [removeButton setImage:[UIImage imageNamed:@"DeleteGeotification"] forState:UIControlStateNormal];
            [annotationView setLeftCalloutAccessoryView:removeButton];
        } else {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MKCircle class]]) {
        MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithOverlay:overlay];
        circleRenderer.lineWidth = 1.0f;
        circleRenderer.strokeColor = [UIColor purpleColor];
        circleRenderer.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:.4f];
        return circleRenderer;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    GeoNotificaciones *geotification = (GeoNotificaciones *) view.annotation;
    [self stopMonitoringGeotification:geotification];
    [self removeGeotification:geotification];
    [self saveAllGeotifications];
}


- (void)addRadiusOverlayForGeotification:(GeoNotificaciones *)geotification{
    if (self.mapView) [self.mapView addOverlay:[MKCircle circleWithCenterCoordinate:geotification.coordinate radius:geotification.radio]];
}

- (void)removeRadiusOverlayForGeotification:(GeoNotificaciones *)geotification{
    if (self.mapView){
        NSArray *overlays = self.mapView.overlays;
        for (MKCircle *circleOverlay in overlays) {
            if ([circleOverlay isKindOfClass:[MKCircle class]]) {
                CLLocationCoordinate2D coordinate = circleOverlay.coordinate;
                if (coordinate.latitude == geotification.coordinate.latitude && coordinate.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radio) {
                    [self.mapView removeOverlay:circleOverlay];
                    break;
                }
            }
        }
    }
}



- (IBAction)zoomToCurrentLocation:(id)sender{
    [Utilities zoomToUserLocationInMapView:self.mapView];
}



- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    [self.mapView setShowsUserLocation:status==kCLAuthorizationStatusAuthorizedAlways];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error{
    NSLog(@"Monitoring failed for region with identifer: %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Location Manager failed with the following error: %@", error);
}


- (CLCircularRegion *)regionWithGeotification:(GeoNotificaciones *)geotification{
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:geotification.coordinate radius:geotification.radio identifier:geotification.identificador];
    [region setNotifyOnExit:!region.notifyOnEntry];
    
    return region;
}

- (void)startMonitoringGeotification:(GeoNotificaciones *)geotification{
    if (![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        [Utilities showSimpleAlertWithTitle:@"Error" message:@"Geofencing is not supported on this device!" viewController:self];
        return;
    }
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) {
        [Utilities showSimpleAlertWithTitle:@"Warning" message:@"Your geotification is saved but will only be activated once you grant GeofencesTest permission to access the device location." viewController:self];
    }
    
    CLCircularRegion *region = [self regionWithGeotification:geotification];
    [self.locationManager startMonitoringForRegion:region];
}

- (void)stopMonitoringGeotification:(GeoNotificaciones *)geotification{
    for (CLCircularRegion *circularRegion in self.locationManager.monitoredRegions) {
        if ([circularRegion isKindOfClass:[CLCircularRegion class]]) {
            if ([circularRegion.identifier isEqualToString:geotification.identificador]) {
                [self.locationManager stopMonitoringForRegion:circularRegion];
            }
        }
    }
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"addGeotification"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddGeotificationViewController *vc = navigationController.viewControllers.firstObject;
        [vc setDelegate:self];
    }
}

@end
