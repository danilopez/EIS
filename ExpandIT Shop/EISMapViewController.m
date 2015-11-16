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
#import "EISAnnotation.h"

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
    
    self.navigationItem.title = location.inventoryLocationName;
    
    mapView.showsUserLocation = YES;
    [mapView setMapType:MKMapTypeHybrid];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.location.latitude doubleValue], [self.location.longitude doubleValue]);
    EISAnnotation *point = [[EISAnnotation alloc]initWithTitle:self.location.inventoryLocationName stock:self.location.quantity homePage:self.location.homePage location:coordinate];
   
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

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[EISAnnotation class]]) {
        EISAnnotation *myAnnotation = (EISAnnotation *)annotation;
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:@"EISAnnotation"];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:myAnnotation reuseIdentifier:@"EISAnnotation"];
            annotationView.canShowCallout = YES;
            annotationView.pinTintColor = [UIColor redColor];
            if (myAnnotation.homePage != (NSString *)[NSNull null]) {
                UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                leftButton.frame = CGRectMake(0, 0, annotationView.frame.size.height, annotationView.frame.size.height);
                [leftButton setImage:[UIImage imageNamed:@"homepage"] forState:UIControlStateNormal];
                leftButton.tintColor = [UIColor greenColor];
                leftButton.tag = 1;
                annotationView.leftCalloutAccessoryView = leftButton;
            }
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            rightButton.frame = CGRectMake(0, 0, annotationView.frame.size.height, annotationView.frame.size.height);
            [rightButton setImage:[UIImage imageNamed:@"car"] forState:UIControlStateNormal];
            rightButton.tag = 2;
            annotationView.rightCalloutAccessoryView = rightButton;
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    EISAnnotation *theAnnotation = (EISAnnotation *)view.annotation;
    if (control == view.leftCalloutAccessoryView) {
        // Left Accessory Button Tapped
        NSURL *url = nil;
        if (![theAnnotation.homePage hasPrefix:@"http://"]) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",theAnnotation.homePage]];
        } else {
            url = [NSURL URLWithString:theAnnotation.homePage];
        }
        [[UIApplication sharedApplication] openURL:url];
    } else if (control == view.rightCalloutAccessoryView) {
        // "Right Accessory Button Tapped
        MKPlacemark *theLocation = [[MKPlacemark alloc] initWithCoordinate:theAnnotation.coordinate addressDictionary:nil];
        MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:theLocation];
        
        if ([destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)]) {
            [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking}];
        } else {
            NSString *url = [NSString stringWithFormat:@"http://maps.google.com/maps?saddr=Current+Location&daddr=%f,%f",theAnnotation.coordinate.latitude, theAnnotation.coordinate.longitude];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }
}



@end
