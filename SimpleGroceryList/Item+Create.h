//
//  Item+Create.h
//  SimpleGroceryList
//
//  Created by Bill Richards on 4/21/13.
//  Copyright (c) 2013 Bill Richards. All rights reserved.
//

#import "Item.h"

@interface Item (Create)

+ (Item *)itemWithName:(NSString *)name forList:(List *)list inManagedObjectContext:(NSManagedObjectContext *)context;

@end
