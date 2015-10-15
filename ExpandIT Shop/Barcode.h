//
//  Barcode.h
//  ExpandIT Shop
//
//  Created by Daniel Lopez on 14/10/15.
//  Copyright © 2015 Daniel Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

@interface Barcode : NSObject

+ (Barcode *)processMetadataObject:(AVMetadataMachineReadableCodeObject*) code;
- (NSString *)getBarcodeData;
- (NSString *)getBarcodeType;
- (void) printBarcodeData;

@end
