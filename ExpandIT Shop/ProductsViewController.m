//
//  ProductsViewController.m
//  ExpandIT Shop
//
//  Created by Daniel López on 18/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import "ProductsViewController.h"
#import "EISGroup.h"

@interface ProductsViewController ()

@property (nonatomic, strong) NSMutableArray *groups;

@end

@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.groups = [[NSMutableArray alloc] init];
	for (int i = 0; i < 5; i++) {
		EISGroup *group = [[EISGroup alloc] init];
		NSString *name = [NSString stringWithFormat:@"Product %d", i+1];
		group.name = name;
		[self.groups addObject:group];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	EISGroup *group = [self.groups objectAtIndex:indexPath.row];
	
	// Configure cell
	cell.textLabel.text = group.name;
	
	return cell;
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
