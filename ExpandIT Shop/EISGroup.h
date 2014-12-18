//
//  EISGroup.h
//  ExpandIT Shop
//
//  Created by Daniel López on 18/12/14.
//  Copyright (c) 2014 Daniel Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EISGroup : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, copy) NSNumber *groupId;
@property (nonatomic, copy) NSNumber *parentId;

@end
