//
//  ProductsViewController.m
//  ExpandIT Shop
//
//  Created by Daniel López on 18/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import "ProductsViewController.h"
#import "EISGroup.h"

#define API_STRING @"http://wks-dlp-1:53061/api/v1"

@interface ProductsViewController ()

@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@end

static NSString *Cell = @"Cell";

@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self getAllGroups];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.groups ? [self.groups count] : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.groups ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Cell];
	
	EISGroup *group = [self.groups objectAtIndex:indexPath.row];
	
	// Configure cell
	cell.textLabel.text = group.name;
	
	return cell;
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
		NSLog(@"Doing something");
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
	NSLog(@"%@",self.groups);
	[self.tableView reloadData];
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
