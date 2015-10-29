//
//  EISProduct.m
//  ExpandIT Shop
//
//  Created by Daniel López on 19/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import "EISProduct.h"

@implementation EISProduct

@synthesize
description,
htmlDesc,
hyperlink,
linkText,
picture1,
picture2,
pageTemplate,
parentGuid,
productGuid,
productName,
language,
listPrice,
productGrp,
currencyGuid,
totalInclTax,
stock;

- (id)initWithDictionary:(NSDictionary *)dict {
	self = [super init];
	if (self) {
        NSDictionary *prod = [[[dict objectForKey:@"ProductInfoNodes"] objectAtIndex:0] objectForKey:@"Prod"];
        NSDictionary *propDict = [[prod objectForKey:@"Properties"] objectForKey:@"PropDict"];
        NSDictionary *line = [[[dict objectForKey:@"ProductInfoNodes"] objectAtIndex:0] objectForKey:@"Line"];
        
		description =   [propDict objectForKey:@"DESCRIPTION"];
		htmlDesc =      [propDict objectForKey:@"HTMLDESC"];
		hyperlink =     [propDict objectForKey:@"HYPERLINK"];
		linkText =      [propDict objectForKey:@"LINKTEXT"];
		picture1 =      [propDict objectForKey:@"PICTURE1"];
		picture2 =      [propDict objectForKey:@"PICTURE2"];
		parentGuid =    [[prod objectForKey:@"Properties"] objectForKey:@"parentGuid"];
		productGuid =   [prod objectForKey:@"ProductGuid"];
		productName =   [prod objectForKey:@"ProductName"];
		language =      [propDict objectForKey:@"_DESCRIPTION"];
        listPrice =     [prod objectForKey:@"ListPrice"];
        productGrp =    [prod objectForKey:@"ProductGrp"];
        currencyGuid =  [line objectForKey:@"CurrencyGuid"];
        totalInclTax =  [line objectForKey:@"TotalInclTax"];
        stock =         [prod objectForKey:@"Stock"];
        
	}
	return self;
}

@end
