//
//  EISAnnotation.m
//  ExpandIT Shop
//
//  Created by Daniel Lopez on 15/11/15.
//  Copyright © 2015 Daniel Lopez. All rights reserved.
//

#import "EISAnnotation.h"

@implementation EISAnnotation

@synthesize title, homePage, coordinate, stock;

- (id)initWithTitle:(NSString *)newTitle stock:(NSNumber *)newStock homePage:(NSString *)newHomePage location:(CLLocationCoordinate2D)newLocation {
    self = [super init];
    if (self) {
        self.title = newTitle;
        self.stock = newStock;
        self.homePage = newHomePage;
        self.coordinate = newLocation;
    }
    return self;
}

- (MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"EISAnnotation"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    return annotationView;
}

@end
