//
//  EISMapViewController.m
//  ExpandIT Shop
//
//  Created by Daniel Lopez on 14/11/15.
//  Copyright © 2015 Daniel Lopez. All rights reserved.
//

#import "EISMapViewController.h"
#define MAP_PADDING 1.2
#define MINIMUN_VISIBLE_LATITUDE 0.01

@interface EISMapViewController ()

@end

@implementation EISMapViewController

@synthesize mapView, location;

- (void)viewDidLoad {
    [super viewDidLoad];

    mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [self.locationManager startUpdatingLocation];
    
    mapView.showsUserLocation = YES;
    [mapView setMapType:MKMapTypeHybrid];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    CLLocationCoordinate2D coordinate = {[self.location.latitude doubleValue], [self.location.longitude doubleValue]};
    point.title = self.location.inventoryLocationName;
    point.subtitle = [self.location.quantity stringValue];
    point.coordinate = coordinate;
    
    [self.mapView addAnnotation:point];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // View area
    MKCoordinateRegion region;
    double locationLat =  [self.location.latitude doubleValue];
    double locationLong = [self.location.longitude doubleValue];
    double userLat = self.locationManager.location.coordinate.latitude;
    double userLong = self.locationManager.location.coordinate.longitude;
    
    region.center.latitude = (locationLat + userLat) / 2;
    region.center.longitude = (locationLong + userLong) / 2;

    double latitudeSpan = fabs(locationLat - userLat) * MAP_PADDING;
    latitudeSpan = (region.span.latitudeDelta < MINIMUN_VISIBLE_LATITUDE) ? MINIMUN_VISIBLE_LATITUDE : region.span.latitudeDelta;
    
    double longitudeSpan = fabs(locationLong - userLong) * MAP_PADDING;

    region.span.latitudeDelta = latitudeSpan;
    region.span.longitudeDelta = longitudeSpan;

    [mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
