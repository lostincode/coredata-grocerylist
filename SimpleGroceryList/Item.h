//
//  Item.h
//  SimpleGroceryList
//
//  Created by Bill Richards on 8/4/13.
//  Copyright (c) 2013 Bill Richards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * done;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) List *list;

@end
