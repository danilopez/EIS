//
//  EISProductDetailViewController.h
//  ExpandIT Shop
//
//  Created by Daniel López on 22/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EISProduct.h"

@interface EISProductDetailViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *totalInclTaxLabel;
@property (strong, nonatomic) IBOutlet UITextView *textDescription;
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) EISProduct *theProduct;
@property (strong, nonatomic) IBOutlet UILabel *priceText;
@property (strong, nonatomic) IBOutlet UIButton *getStockButton;

- (IBAction)getStock:(id)sender;

@end
