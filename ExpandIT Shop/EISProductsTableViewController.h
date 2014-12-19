//
//  EISProductsTableViewController.h
//  ExpandIT Shop
//
//  Created by Daniel López on 19/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EISProductsTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *products;

@end
