//
//  EISLocationsViewController.h
//  ExpandIT Shop
//
//  Created by Daniel Lopez on 14/11/15.
//  Copyright © 2015 Daniel Lopez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EISLocationsViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *locations;

@end
