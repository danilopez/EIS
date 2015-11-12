//
//  EISProductDetailViewController.m
//  ExpandIT Shop
//
//  Created by Daniel López on 22/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import "EISProductDetailViewController.h"

#define BASE_URL @"http://demo2.expandit.com/daniel-master-project"
#define API_STRING @"http://demo2.expandit.com/daniel-master-project/api/v1"
#define kMaxHeight 200.f

@interface EISProductDetailViewController ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

@implementation EISProductDetailViewController

@synthesize textDescription, picture, theProduct, totalInclTaxLabel, getStockButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	NSString *thePicture = theProduct.picture1;
	if ([thePicture characterAtIndex:0] != '/') {
		thePicture = [NSString stringWithFormat:@"/%@",thePicture];
	}
	
	thePicture = [NSString stringWithFormat:@"%@%@",BASE_URL, thePicture];
	
	NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
	NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
	
	NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:thePicture]];
	[downloadTask resume];
	
	textDescription.text = theProduct.description;
    [textDescription sizeToFit];
    
	self.navigationItem.title = theProduct.productName;
    totalInclTaxLabel.text = theProduct.totalInclTax.stringValue;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tiendas" style:UIBarButtonItemStylePlain target:nil action:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)getStock:(id)sender {
    if (self.dataTask)
        [self.dataTask cancel];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/GetStockFor?productGuid=%@",API_STRING, self.theProduct.productGuid]]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.0f];
    
    self.dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error && error.code != -999) {
            NSLog(@"Error on REQUEST: %@",error);
            return;
        }
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"Stock: %@",[results objectForKey:@"Stock"]);
        [getStockButton setTitle:[NSString stringWithFormat:@"Stock: %@",[results objectForKey:@"Stock"]]forState:UIControlStateNormal];
        [getStockButton setTitle:[NSString stringWithFormat:@"Stock: %@",[results objectForKey:@"Stock"]]forState:UIControlStateSelected];
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

@end
