//
//  ProductsViewController.h
//  ExpandIT Shop
//
//  Created by Daniel López on 18/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EISCatalogViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end