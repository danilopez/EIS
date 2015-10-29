//
//  EISProduct.h
//  ExpandIT Shop
//
//  Created by Daniel López on 19/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EISProduct : NSObject

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *htmlDesc;
@property (nonatomic, strong) NSString *hyperlink;
@property (nonatomic, strong) NSString *linkText;
@property (nonatomic, strong) NSString *picture1;
@property (nonatomic, strong) NSString *picture2;
@property (nonatomic, strong) NSNumber *pageTemplate;
@property (nonatomic, strong) NSString *parentGuid;
@property (nonatomic, strong) NSString *productGuid;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSNumber *listPrice;
@property (nonatomic, strong) NSString *productGrp;
@property (nonatomic, strong) NSString *currencyGuid;
@property (nonatomic, strong) NSNumber *totalInclTax;
@property (nonatomic, strong) NSNumber *stock;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
