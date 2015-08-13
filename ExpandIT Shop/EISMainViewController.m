//
//  EISMainViewController.m
//  ExpandIT Shop
//
//  Created by Daniel Lopez on 13/08/15.
//  Copyright (c) 2015 Daniel Lopez. All rights reserved.
//

#import "EISMainViewController.h"
#import "EISProductDetailViewController.h"
#import "EISProduct.h"

#define API_STRING @"http://demo2.expandit.com/daniel-master-project/api/v1"
#define BASE_URL @"http://demo2.expandit.com/daniel-master-project"

@interface EISMainViewController ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) EISProduct *theProduct;

@end

@implementation EISMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GetInfoButton:(id)sender {
    [self getProduct:@"8102-05"];
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

- (void)getProduct:(NSString *)productGuid {
    if (self.dataTask)
        [self.dataTask cancel];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/Product?productGuid=%@",API_STRING, productGuid]]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.0f];
    
    self.dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error && error.code != -999) {
            NSLog(@"Error on REQUEST: %@",error);
            return;
        }
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.theProduct = [[EISProduct alloc] initWithDictionary:results];
        NSLog(@"Product Name: %@",self.theProduct.productName);
        [self performSegueWithIdentifier:@"Detail" sender:nil];

    }];
    
    if (self.dataTask)
        [self.dataTask resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"Detail"]){
        UINavigationController *navigation = (UINavigationController *)segue.destinationViewController;
        EISProductDetailViewController *detailVC = [navigation.viewControllers lastObject];
        [detailVC setTheProduct:self.theProduct];
    }
}

@end
