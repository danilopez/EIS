//
//  EISProductDetailViewController.m
//  ExpandIT Shop
//
//  Created by Daniel López on 22/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import "EISProductDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "EISInventoryLocation.h"
#import "EISLocationsViewController.h"

#define BASE_URL @"http://demo2.expandit.com/daniel-master-project"
#define API_STRING @"http://demo2.expandit.com/daniel-master-project/api/v1"
#define kMaxHeight 200.f

@interface EISProductDetailViewController ()<NSURLSessionDownloadDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) CLLocation *lastLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *locations;

@end

@implementation EISProductDetailViewController

@synthesize textDescription, picture, theProduct, totalInclTaxLabel, getStockButton, locationManager, lastLocation, locations;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Get Picture
	NSString *thePicture = theProduct.picture1;
	if ([thePicture characterAtIndex:0] != '/') {
		thePicture = [NSString stringWithFormat:@"/%@",thePicture];
	}
	
	thePicture = [NSString stringWithFormat:@"%@%@",BASE_URL, thePicture];
	
	NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
	
	NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:thePicture]];
	[downloadTask resume];
    
    self.locations = [[NSMutableArray alloc] init];
    
    // Location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];

    // UI
	textDescription.text = theProduct.description;
    [textDescription sizeToFit];
    
	self.navigationItem.title = theProduct.productName;
    totalInclTaxLabel.text = theProduct.totalInclTax.stringValue;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tiendas" style:UIBarButtonItemStylePlain target:self action:@selector(showStores)];
}

- (void)viewWillAppear:(BOOL)animated {
    return [super viewWillAppear:animated];
}

- (void)doneButtonPressed {
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Session
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
	UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
	dispatch_async(dispatch_get_main_queue(), ^{
		self.picture.image = image;
		[self.picture setContentMode:UIViewContentModeScaleAspectFit];
		CGRect frame = self.picture.frame;
		frame.size = image.size;
		[self.picture setNeedsDisplayInRect:frame];
	});
}

- (void)showStores {
    if (self.dataTask)
        [self.dataTask cancel];
    
    NSString *postUrl = [NSString stringWithFormat:
                         @"%@/GetAllLocationsForProduct?productGuid=%@",
                         API_STRING,
                         theProduct.productGuid];
    
    NSLog(@"URL post: %@", postUrl);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postUrl]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.0f];
    
    self.dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error && error.code != -999) {
            NSLog(@"Error on REQUEST: %@",error);
            return;
        }
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        // Do something
        for (NSDictionary *result in results) {
            EISInventoryLocation *location = [[EISInventoryLocation alloc] initWithDictionary:result];
            [self.locations addObject:location];
        }
        
        [self performSegueWithIdentifier:@"Locations" sender:nil];
    }];
    if (self.dataTask)
        [self.dataTask resume];
                     
}

- (IBAction)getStock:(id)sender {
    if (self.dataTask)
        [self.dataTask cancel];
    
    NSString *postUrl = [NSString stringWithFormat:
                         @"%@/GetStockInLocation?productGuid=%@&latitude=%f&longitude=%f&accuracy=%f",
                         API_STRING,
                         self.theProduct.productGuid,
                         self.lastLocation.coordinate.latitude,
                         self.lastLocation.coordinate.longitude,
                         self.lastLocation.horizontalAccuracy];
    
    NSLog(@"URL post: %@", postUrl);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:postUrl]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.0f];
    
    self.dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error && error.code != -999) {
            NSLog(@"Error on REQUEST: %@",error);
            return;
        }
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"Stock: %@",[results objectForKey:@"Stock"]);
        NSNumber *stock = [results objectForKey:@"Stock"];
        if ([stock integerValue] == -1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Fallo del GPS"
                                                                           message:@"No se ha podido encontrar su localización con la suficiente exactitud."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Aceptar" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:defaultAction];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Code to update the UI/send notifications based on the results of the background processing
                [self presentViewController:alert animated:YES completion:nil];
                
            });
        } else {
            [getStockButton setTitle:[NSString stringWithFormat:@"Stock: %@",stock] forState:UIControlStateNormal];
            [getStockButton setTitle:[NSString stringWithFormat:@"Stock: %@",stock] forState:UIControlStateSelected];
        }
    }];
    
    if (self.dataTask)
        [self.dataTask resume];
}

#pragma mark - Session
- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfiguration setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

#pragma mark - Location delegate methods
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Se ha producido un error"
                                                                   message:@"No se ha podido encontrar su localización."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Code to update the UI/send notifications based on the results of the background processing
        [self presentViewController:alert animated:YES completion:nil];
        
    });
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)gpsLocations {
    self.lastLocation = [gpsLocations lastObject];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Locations"]){
        EISLocationsViewController *locationsVC = segue.destinationViewController;
        [locationsVC setLocations:self.locations];
    }
}
@end
