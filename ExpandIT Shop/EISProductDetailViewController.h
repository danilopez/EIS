//
//  EISProductDetailViewController.h
//  ExpandIT Shop
//
//  Created by Daniel López on 22/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EISProduct.h"

@interface EISProductDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) EISProduct *theProduct;

@end
