//
//  EISGroup.m
//  ExpandIT Shop
//
//  Created by Daniel López on 18/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import "EISGroup.h"

@implementation EISGroup

@synthesize url, name, groupId, parentId;

- (id)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		name = [dict objectForKey:@"Name"];
		url = [dict objectForKey:@"Url"];
		groupId = [dict objectForKey:@"GroupId"];
		parentId = [dict objectForKey:@"ParentId"];
	}
	return self;
}

- (NSString *)description {
	NSString *groupIdStr = [self.groupId stringValue];
	NSString *parentIdStr = [self.parentId stringValue];
	
	NSString *descriptionString = [NSString stringWithFormat:@"Group name: %@, (%@)\n,Group Id: %@, Parent Id: %@", self.name, self.url, groupIdStr, parentIdStr];
	return descriptionString;
}

@end
