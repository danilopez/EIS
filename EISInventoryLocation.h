//
//  EISInventoryLocation.h
//  ExpandIT Shop
//
//  Created by Daniel Lopez on 14/11/15.
//  Copyright © 2015 Daniel Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EISInventoryLocation : NSObject

@property (nonatomic, strong) NSString *inventoryLocationName;
@property (nonatomic, strong) NSString *inventoryLocationName2;
@property (nonatomic, strong) NSString *address1;
@property (nonatomic, strong) NSString *address2;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *phoneNo;
@property (nonatomic, strong) NSString *contactName;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *eMailAddress;
@property (nonatomic, strong) NSString *homePage;
@property (nonatomic, strong) NSString *countryGuid;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *quantity;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
