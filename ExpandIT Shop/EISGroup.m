//
//  EISGroup.m
//  ExpandIT Shop
//
//  Created by Daniel López on 18/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import "EISGroup.h"

@implementation EISGroup

@synthesize url, name, groupId, parentId, children, indentationLevel;

- (id)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		name = [dict objectForKey:@"Name"];
		url = [dict objectForKey:@"Url"];
		groupId = [dict objectForKey:@"GroupId"];
		parentId = [dict objectForKey:@"ParentId"];
		indentationLevel = 0;
		if([[dict objectForKey:@"Children"] count] > 0) {
			children = [[NSMutableArray alloc] initWithCapacity:[[dict objectForKey:@"Children"] count]];
		}
		for(NSDictionary *dictionary in [dict objectForKey:@"Children"]) {
			EISGroup *group = [[EISGroup alloc] initWithDictionary:dictionary];
			[children addObject:group];
		}
	}
	return self;
}

- (NSString *)description {
	NSString *groupIdStr = [self.groupId stringValue];
	NSString *childrenStr = self.children ? [self.children description] : @"";
	childrenStr = [[childrenStr stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"] stringByReplacingOccurrencesOfString:@"\"" withString:@"''"];
	NSString *descriptionString = [NSString stringWithFormat:@"Group name: %@, Id: %@; %@", self.name, groupIdStr, childrenStr];
	return [descriptionString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

@end
