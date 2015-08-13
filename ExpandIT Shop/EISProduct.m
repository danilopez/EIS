//
//  EISProduct.m
//  ExpandIT Shop
//
//  Created by Daniel López on 19/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import "EISProduct.h"

@implementation EISProduct

@synthesize groupGuid,
groupProductGuid,
alias,
attachment,
attachText,
textDesc,
htmlDesc,
hyperlink,
linkText,
picture1,
picture2,
pageTemplate,
parentGuid,
productGuid,
productName,
language;

- (id)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		groupGuid = [dict objectForKey:@"GroupGuid"];
		groupProductGuid = [dict objectForKey:@"GroupProductGuid"];
		alias = [[[dict objectForKey:@"Properties"]
						objectForKey:@"PropDict"]
						objectForKey:@"ALIAS"];
		attachment = [[[dict objectForKey:@"Properties"]
					   objectForKey:@"PropDict"]
					  objectForKey:@"ATTACHMENT"];
		attachText = [[[dict objectForKey:@"Properties"]
					   objectForKey:@"PropDict"]
					  objectForKey:@"ATTACHTEXT"];
		textDesc = [[[dict objectForKey:@"Properties"]
						objectForKey:@"PropDict"]
					objectForKey:@"DESCRIPTION"];
		htmlDesc = [[[dict objectForKey:@"Properties"]
						objectForKey:@"PropDict"]
					objectForKey:@"HTMLDESC"];
		hyperlink = [[[dict objectForKey:@"Properties"]
					  objectForKey:@"PropDict"]
						objectForKey:@"HYPERLINK"];
		linkText = [[[dict objectForKey:@"Properties"]
						objectForKey:@"PropDict"]
					objectForKey:@"LINKTEXT"];
		picture1 = [[[dict objectForKey:@"Properties"]
						objectForKey:@"PropDict"]
					objectForKey:@"PICTURE1"];
		picture2 = [[[dict objectForKey:@"Properties"]
						objectForKey:@"PropDict"]
					objectForKey:@"PICTURE2"];
		pageTemplate = [[[dict objectForKey:@"Properties"]
						 objectForKey:@"PropDict"]
						objectForKey:@"TEMPLATE"];
		parentGuid = [[dict objectForKey:@"Properties"]
					   objectForKey:@"parentGuid"];
		productGuid = [dict objectForKey:@"ProductGuid"];
		productName = [[[[dict objectForKey:@"ProductInfoNodes"] objectAtIndex:0] objectForKey:@"Prod"] objectForKey:@"ProductName"];
		language = [[[dict objectForKey:@"Properties"]
					 objectForKey:@"PropDict"]
					objectForKey:@"_DESCRIPTION"];
	}
	return self;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@",self.productName];
}

@end
