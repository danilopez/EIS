//
//  Barcode.m
//  ExpandIT Shop
//
//  Created by Daniel Lopez on 14/10/15.
//  Copyright © 2015 Daniel Lopez. All rights reserved.
//

#import "Barcode.h"

@interface Barcode()

@property (nonatomic, strong) AVMetadataMachineReadableCodeObject *metadataObject;
@property (nonatomic, strong) NSString *barcodeData;
@property (nonatomic, strong) NSString *barcodeType;

@end

@implementation Barcode

+ (Barcode * )processMetadataObject: (AVMetadataMachineReadableCodeObject*)code
{
    
    Barcode *barcode = [[Barcode alloc]init];
    
    barcode.barcodeType = [NSString stringWithString:code.type];
    barcode.barcodeData = [NSString stringWithString:code.stringValue];
    barcode.metadataObject = code;
    
    return barcode;
}

- (NSString *) getBarcodeData{
    return self.barcodeData;
}

- (NSString *)getBarcodeType {
    return self.barcodeType;
}

- (void) printBarcodeData{
    NSLog(@"Barcode of type: %@ and data: %@",self.metadataObject.type, self.barcodeData);
}

@end
