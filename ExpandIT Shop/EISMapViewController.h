//
//  EISMapViewController.h
//  ExpandIT Shop
//
//  Created by Daniel Lopez on 14/11/15.
//  Copyright © 2015 Daniel Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import "EISInventoryLocation.h"

@interface EISMapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) EISInventoryLocation *location;

@end
