//
//  EISAnnotation.h
//  ExpandIT Shop
//
//  Created by Daniel Lopez on 15/11/15.
//  Copyright © 2015 Daniel Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EISAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *homePage;
@property (nonatomic, copy) NSNumber *stock;

- (id)initWithTitle:(NSString *)title stock:(NSNumber *)stock homePage:(NSString *)homePage location:(CLLocationCoordinate2D)location;
- (MKAnnotationView *)annotationView;

@end
