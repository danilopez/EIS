//
//  EISProductDetailViewController.m
//  ExpandIT Shop
//
//  Created by Daniel López on 22/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import "EISProductDetailViewController.h"

#define BASE_URL @"http://demo2.expandit.com/daniel-master-project"
#define kMaxHeight 200.f

@interface EISProductDetailViewController ()<NSURLSessionDownloadDelegate>


@end

@implementation EISProductDetailViewController

@synthesize textDescription, picture, theProduct, totalInclTaxLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//	NSString *thePicture = theProduct.picture1;
//	if ([thePicture characterAtIndex:0] != '/') {
//		thePicture = [NSString stringWithFormat:@"/%@",thePicture];
//	}
//	
//	thePicture = [NSString stringWithFormat:@"%@%@",BASE_URL, thePicture];
//	
//	NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
//	NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
//	
//	NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:thePicture]];
//	[downloadTask resume];
	
	textDescription.text = theProduct.description;
    [textDescription sizeToFit];
    
	self.navigationItem.title = theProduct.productName;
    totalInclTaxLabel.text = theProduct.totalInclTax.stringValue;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
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

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
	
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
	
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
