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
#import "Barcode.h"

@import AVFoundation;

#define API_STRING @"http://demo2.expandit.com/daniel-master-project/api/v1"
#define BASE_URL @"http://demo2.expandit.com/daniel-master-project"

@interface EISMainViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) EISProduct *theProduct;
@property (nonatomic, strong) NSMutableArray *allowedBarcodeTypes;

@end

@implementation EISMainViewController {
    AVCaptureDevice *_videoDevice;
    AVCaptureSession *_captureSession;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    BOOL _running;
    AVCaptureMetadataOutput *_metadataOutput;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCaptureSession];
    
    _previewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:_previewLayer];

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    self.allowedBarcodeTypes = [NSMutableArray new];
//    [self.allowedBarcodeTypes addObject:AVMetadataObjectTypeQRCode];
//    [self.allowedBarcodeTypes addObject:AVMetadataObjectTypePDF417Code];
//    [self.allowedBarcodeTypes addObject:AVMetadataObjectTypeUPCECode];
//    [self.allowedBarcodeTypes addObject:AVMetadataObjectTypeAztecCode];
//    [self.allowedBarcodeTypes addObject:AVMetadataObjectTypeCode39Code];
//    [self.allowedBarcodeTypes addObject:AVMetadataObjectTypeCode39Mod43Code];
//    [self.allowedBarcodeTypes addObject:AVMetadataObjectTypeEAN13Code];
//    [self.allowedBarcodeTypes addObject:AVMetadataObjectTypeEAN8Code];
//    [self.allowedBarcodeTypes addObject:AVMetadataObjectTypeCode93Code];
    [self.allowedBarcodeTypes addObject:AVMetadataObjectTypeCode128Code];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];
}


#pragma mark - AVFoundation setup
- (void) setupCaptureSession {
    if (_captureSession) return;
    
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (!_videoDevice) {
        return;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:nil];
    
    if ([_captureSession canAddInput:_videoInput])
        [_captureSession addInput:_videoInput];
    
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue = dispatch_queue_create("com.expandit.metadata", 0);
    [_metadataOutput setMetadataObjectsDelegate:self queue:metadataQueue];
    
    if ([_captureSession canAddOutput:_metadataOutput])
        [_captureSession addOutput:_metadataOutput];
}

- (void) startRunning {
    if (_running) return;
    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes = _metadataOutput.availableMetadataObjectTypes;
    _running = YES;
}

- (void) stopRunning {
    if (!_running) return;
    [_captureSession stopRunning];
    _running = NO;
}

- (void) applicationWillEnterForeground:(NSNotification *)note {
    [self startRunning];
}

- (void) applicationDidEnterBackground:(NSNotification *)note {
    [self stopRunning];
}

#pragma mark - Delegate functions
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [metadataObjects enumerateObjectsUsingBlock:^(AVMetadataObject *obj, NSUInteger index, BOOL *stop) {
        if ([obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *code = (AVMetadataMachineReadableCodeObject *)[_previewLayer transformedMetadataObjectForMetadataObject:obj];
            
            Barcode *barcode = [Barcode processMetadataObject:code];
            for (NSString *str in self.allowedBarcodeTypes) {
                if ([barcode.getBarcodeType isEqualToString:str]) {
                    [self validBarcodefound:barcode];
                    return;
                }
            }
        }
    }];
}

- (void)validBarcodefound:(Barcode *)barcode {
    [self stopRunning];
    [self getProduct:barcode.getBarcodeData];
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

- (void)productNotFoundError {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Código de barras incorrecto"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Volver a intentar" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self startRunning];
                                                          }];
    
    [alert addAction:defaultAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Code to update the UI/send notifications based on the results of the background processing
        [self presentViewController:alert animated:YES completion:nil];
        
    });
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
            [self productNotFoundError];
            return;
        }
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (results == nil)
            [self productNotFoundError];
        else {
            self.theProduct = [[EISProduct alloc] initWithDictionary:results];
            [self performSegueWithIdentifier:@"Detail" sender:nil];
        }
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
