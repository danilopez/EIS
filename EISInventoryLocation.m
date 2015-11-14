//
//  EISInventoryLocation.m
//  ExpandIT Shop
//
//  Created by Daniel Lopez on 14/11/15.
//  Copyright © 2015 Daniel Lopez. All rights reserved.
//

#import "EISInventoryLocation.h"

@implementation EISInventoryLocation

@synthesize inventoryLocationName, inventoryLocationName2, address1, address2, cityName, phoneNo, contactName, zipCode, eMailAddress, homePage, countryGuid, latitude, longitude, quantity;

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        inventoryLocationName = [dict objectForKey:@"InventoryLocationName"];
        inventoryLocationName2 = [dict objectForKey:@"InventoryLocationName2"];
        address1 = [dict objectForKey:@"Address1"];
        address2 = [dict objectForKey:@"Address2"];
        cityName = [dict objectForKey:@"CityName"];
        phoneNo = [dict objectForKey:@"PhoneNo"];
        contactName = [dict objectForKey:@"ContactName"];
        zipCode = [dict objectForKey:@"ZipCode"];
        eMailAddress = [dict objectForKey:@"EMailAddress"];
        homePage = [dict objectForKey:@"HomePage"];
        countryGuid = [dict objectForKey:@"CountryGuid"];
        latitude = [dict objectForKey:@"Latitude"];
        longitude = [dict objectForKey:@"Longitude"];
        quantity = [dict objectForKey:@"Quantity"];
    }
    return self;
}
@end
