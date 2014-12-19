//
//  ProductsViewController.m
//  ExpandIT Shop
//
//  Created by Daniel López on 18/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import "EISCatalogViewController.h"
#import "EISGroup.h"
#import "EISProduct.h"
#import "EISProductsTableViewController.h"

#define API_STRING @"http://wks-dlp-1:53061/api/v1"

@interface EISCatalogViewController ()

@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *groupsInPlain;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSString *groupSelected;

@end

static NSString *Cell = @"Cell";

@implementation EISCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	
	// Fix UITableView position under navigation bar and tabBar
	UIEdgeInsets insets = self.tableView.contentInset;
	insets.top = self.navigationController.navigationBar.bounds.size.height +
	[UIApplication sharedApplication].statusBarFrame.size.height;
	insets.bottom = self.tabBarController.tabBar.bounds.size.height;
	self.tableView.contentInset = insets;
	self.tableView.scrollIndicatorInsets = insets;
	
	[self.view addSubview:self.tableView];
	[self getAllGroups];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.groupsInPlain count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
	EISGroup *group = [self.groupsInPlain objectAtIndex:indexPath.row];
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
	}
	// Configure cell
	cell.textLabel.text = group.name;
	cell.indentationLevel = group.indentationLevel;
	cell.indentationWidth = 20;
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSNumber *groupId = [[self.groupsInPlain objectAtIndex:indexPath.row] groupId];
	self.groupSelected = [[self.groupsInPlain objectAtIndex:indexPath.row] name];
	[self getProductsOfGroup:groupId];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Session
- (NSURLSession *)session {
	if (!_session) {
		NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
		[sessionConfiguration setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
		
		_session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
	}
	return _session;
}

- (void)getProductsOfGroup:(NSNumber *)groupId {
	if (self.dataTask) {
		[self.dataTask cancel];
	}
	
	NSString *groupIdString = groupId.stringValue;
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ProductsInGroup?groupId=%@",API_STRING, groupIdString]]];
	[request setHTTPMethod:@"POST"];
	[request setTimeoutInterval:30.0f];
	self.dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		if (error) {
			if (error.code != -999) {
				NSLog(@"%@", error);
			}
		}
		NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		dispatch_async(dispatch_get_main_queue(), ^{
			if (results) {
				self.products = [[NSMutableArray alloc] init];
				for (NSDictionary *dict in results) {
					EISProduct *product = [[EISProduct alloc] initWithDictionary:dict];
					[self.products addObject:product];
				}
				[self performSegueWithIdentifier:@"EISProductsTableViewController" sender:self];
			}
		});
	}];
	
	if (self.dataTask) {
		[self.dataTask resume];
	}
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.destinationViewController isKindOfClass:[EISProductsTableViewController class]]){
		EISProductsTableViewController *newVC = segue.destinationViewController;
		newVC.products = self.products;
		newVC.navigationItem.title = self.groupSelected;
	}
}

- (void)getAllGroups {
	if (self.dataTask) {
		[self.dataTask cancel];
	}
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/groups",API_STRING]]];
	[request setHTTPMethod:@"POST"];
	[request setTimeoutInterval:30.0f];
	
	self.dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		if (error) {
			if (error.code != -999) {
				NSLog(@"%@", error);
			}
		}
		NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
		dispatch_async(dispatch_get_main_queue(), ^{
			if (results) {
				[self parseResponse:results];
			}
		});
	}];
	
	if (self.dataTask) {
		[self.dataTask resume];
	}
}

- (void)parseResponse:(NSDictionary *)jsonObject {
	NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
	for(NSDictionary *dictionary in jsonObject) {
		EISGroup *group = [[EISGroup alloc] initWithDictionary:dictionary];
		[mutableArray addObject:group];
	}
	
	if (!self.groups) {
		self.groups = [NSMutableArray array];
	}
	
	[self.groups removeAllObjects];
	[self.groups addObjectsFromArray:mutableArray];
	self.groupsInPlain = [self transformGroups:self.groups withIndentation:0];
	[self.tableView reloadData];
}


- (NSMutableArray *)transformGroups:(NSMutableArray *)theGroups withIndentation:(NSInteger)indentationLevel {
	NSMutableArray *result = [[NSMutableArray alloc] init];
	for (EISGroup *group in theGroups) {
		group.indentationLevel = indentationLevel;
		[result addObject:group];
		if (group.children) {
			[result addObjectsFromArray:[self transformGroups:group.children withIndentation:++indentationLevel]];
			indentationLevel--;
		}
	}
	return result;
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
