//
//  EISProductDetailViewController.m
//  ExpandIT Shop
//
//  Created by Daniel López on 22/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import "EISProductDetailViewController.h"

@interface EISProductDetailViewController ()

@end

@implementation EISProductDetailViewController

@synthesize productNameLabel, theProduct;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	productNameLabel.text = theProduct.productName;
	self.navigationItem.title = theProduct.productName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
